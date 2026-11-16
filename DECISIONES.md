# Decisiones Técnicas y Arquitectónicas — Tu Mercado Ferretero (TMF)

Este documento detalla las decisiones clave de ingeniería tomadas para construir el flujo B2B de **Solicitud de Cotización (RFQ)** pensado para compradores ferreteros operando en galpones, depósitos y rutas con conectividad inestable.

---

## 1. Manejador de Estado: `flutter_riverpod` (`Notifier` / `NotifierProvider`)

### ¿Por qué Riverpod?
* **Seguridad en Tiempo de Compilación y Cero Dependencia de `BuildContext`:** A diferencia de `Provider` clásico, los `Notifier` de Riverpod no dependen del árbol de widgets para leer o mutar estado. Esto nos permitió encapsular toda la orquestación del borrador (`RfqDraftNotifier`), la simulación de caída de red (`simulateNoSignal`) y el escudo de idempotencia en una capa completamente aislada de la interfaz gráfica.
* **Reconstrucciones Quirúrgicas con `.select(...)`:** En el catálogo B2B (`ProductTierCard`) y en la barra de estado offline (`OfflineSimulatorBar`), cada tarjeta escucha únicamente la cantidad del producto que le corresponde (`ref.watch(rfqDraftProvider.select((s) => s.draft.quantityFor(product.id)))`). Así, al ajustar la cantidad del *Taladro*, no se reconstruyen innecesariamente las tarjetas del *Disco* ni del *Tubo PVC*.
* **Testabilidad Pura:** Gracias a `ProviderContainer` y `overrides`, probamos de forma aislada la máquina de estados, el modo *"Sin Señal"* y el bloqueo de toques múltiples sin necesidad de levantar un emulador.

---

## 2. Persistencia Local Resiliente (Offline-First): `isar` + `isar_flutter_libs`

### ¿Por qué Isar Database en lugar de `SharedPreferences` o `sqflite`?
* **Transacciones ACID Ultrarrápidas vía Dart FFI (C++):** Cada vez que el comprador modifica una cantidad, adjunta el comprobante/RIF comprimido o intenta enviar sin señal, el repositorio ejecuta una escritura inmediata (*Write-Through*) mediante `isar.writeTxn(...)` sobre la colección `IsarRfqDraft`.
* **Resiliencia ante Cierres Forzados (*Force Close*) sin Perder el Último Toque:** Se descartó explícitamente usar un *Debounce* (escritura diferida) porque si el comprador modifica una cantidad y cierra forzosamente la aplicación medio segundo después, ese último cambio en RAM se perdería. Con *Write-Through* inmediato cada toque queda asegurado en disco en `< 2 ms`.
* **Auto-Compactación Automática (`compactOnLaunch`) y Arranque No Bloqueante:** Como Isar utiliza un motor *Copy-on-Write* (MVCC) donde múltiples transacciones seguidas hacen crecer el archivo `.isar` con páginas obsoletas, configuramos `compactOnLaunch: CompactCondition(minFileSize: 1 MB, minBytes: 256 KB, minRatio: 2.0)`. Así, Isar limpia y compacta automáticamente el espacio muerto al abrir la app sin perder un solo dato persistido. Además, diferimos la apertura del motor `50 ms` fuera de la cola de microtareas del primer frame y añadimos un `.timeout(Duration(seconds: 3))`, garantizando que el Splash Screen de Android nunca se quede retenido aunque el sistema operativo haya matado el proceso previamente por `LOW_MEMORY`.

---

## 3. Captura, Redimensionado y Compresión de Imagen: `image_picker` + `image` en `Isolate.run`

### ¿Cómo se resolvió la compresión y el cálculo real de peso (`X MB → Y KB`)?
1. **Medición Real sin Pre-Recorte del Sistema Operativo:**
   Si se utilizara el parámetro `imageQuality` propio de `ImagePicker`, el sistema operativo entregaría el archivo ya comprimido y se perdería la referencia real del peso original de la fotografía tomada por la cámara. Por ello, capturamos primero los bytes originales crudos (`originalSizeBytes = rawBytes.length`) para medir con exactitud el peso inicial en **MB**.
2. **Procesamiento Pesado Desacoplado en un `Isolate` (`Isolate.run`):**
   Para evitar cualquier caída de frames (*jank*) en el hilo principal de UI al decodificar fotografías de alta resolución (8–12 MP), enviamos los bytes a un **Isolate secundario** donde:
   * Se decodifica la matriz de píxeles.
   * Se redimensiona proporcionalmente a un lado máximo de `1024px` (preservando total legibilidad de textos fiscales del RIF o comprobante).
   * Se codifica en formato **JPEG optimizado (calidad 65%)**, logrando reducciones superiores al **90%** (pasando típicamente de `~2.75 MB` a `~75–140 KB`).
3. **Persistencia en Directorio de Documentos:**
   El archivo optimizado se escribe con `flush: true` en el directorio de documentos de la aplicación (`getApplicationDocumentsDirectory`), garantizando que la imagen comprimida tampoco se pierda tras un *Force Close*.

---

## 4. Decisiones de Diseño UI/UX (Google Stitch) y Reglas de Negocio B2B

* **Diseño Moderno B2B con Lenguaje Natural para el Ferretero (Google Stitch):** En lugar de saturar la interfaz con jerga técnica interna (`RFQ`, `MOQ`, `Tier`), diseñamos una interfaz limpia de bordes redondeados (`22px`), fondo suave (`#F5F7FB`) y acentos en azul real (`#2563EB`) donde el usuario ve términos naturales de negocio (**`Mi Pedido`**, **`Mínimo: 5 u.`**, **`ESCALAS DE PRECIO`**, **`ACTIVO`**, **`+ Agregar`**, **`Enviar Pedido →`**), manteniendo intactos todos los requerimientos técnicos de validación en el dominio.
* **Motor Puro de Escalas y MOQ (`PricingEngine`):** Separado en `lib/domain/services/pricing_engine.dart` sin dependencias de Flutter. Evalúa en tiempo real el tramo alcanzado (`reachedTierIndex`), calcula el ahorro mayorista obtenido frente al primer tramo (`Ahorras $X`) y emite advertencias claras si `cantidad < moq` o `cantidad > stock`, bloqueando proactivamente el botón inferior (`Corrige MOQ`) cuando algún producto incumple el mínimo mayorista.
* **Idempotencia Estricta ante Múltiples Toques:** En `RfqDraftNotifier.submitQuote()` se implementó un cerrojo sincrónico (`_isSubmittingMutex`) previo al primer `await`, acompañado de la deshabilitación reactiva del botón en la UI. Si el comprador presiona repetidamente *"Enviar Cotización"* en zonas de baja señal, todas las invocaciones concurrentes adicionales se descartan de forma determinista.

---

## 5. Diagnóstico y Solución de Errores / Warnings de Debug Console en Dispositivo Físico Android (`TECNO KJ5`)

Durante las pruebas en dispositivo físico (`TECNO KJ5` — HiOS / Android), inspeccionamos el `logcat` del proceso y detectamos cuatro eventos clave en la **Debug Console**, los cuales fueron corregidos de raíz:

### 5.1. `I/Choreographer: Skipped 36 frames! The application may be doing too much work on its main thread` / `E/TranChoreographerImpl: skippedFrames`
* **Causa raíz detectada:**
  1. En `main()`, se estaba ejecutando `await draftRepo.init()` (`getApplicationDocumentsDirectory()` + `Isar.open()` con el `inspector: true` por defecto) **antes** de invocar `runApp()`. Eso retenía el hilo principal de Android durante el arranque en frío.
  2. En `ImageCompressionService`, al generar y comprimir el comprobante/RIF de prueba (`~2.75 MB`), se lanzaban dos `Isolate.run` separados transfiriendo listas de bytes pesadas de ida y vuelta al Isolate principal, y finalmente se escribía el archivo en el hilo principal (`writeAsBytesSync`/`flush: true`).
  3. En `RfqDraftScreen.build()`, se llamaba a `File(path).existsSync()` (I/O sincrónico de disco dentro de `build()`) y se decodificaba la imagen completa sin `cacheWidth`.
* **Solución implementada:**
  1. **Arranque no bloqueante en `lib/main.dart` y Lazy Init en `DraftRepository`:** `runApp()` se ejecuta inmediatamente tras `WidgetsFlutterBinding.ensureInitialized()`. `DraftRepository` inicializa Isar bajo demanda (*lazy singleton* con cerrojo `_openingFuture`) y con `inspector: false`, eliminando el bloqueo previo al primer frame.
  2. **Pipeline de un solo salto en `ImageCompressionService`:** Lectura/generación, redimensionado, codificación JPEG y escritura a disco (`flush: true`) ocurren íntegramente dentro de un **único `Isolate.run`**, devolviendo al hilo principal únicamente un objeto liviano con las rutas y tamaños en bytes.
  3. **Cero I/O sincrónico en `build()`:** Se reemplazó `File.existsSync()` por `Image.file(..., cacheWidth: 300, errorBuilder: ...)`, reduciendo el consumo de RAM de textura y evitando bloqueos de UI.

### 5.2. Adaptabilidad Responsiva en Pantallas Compactas (`360dp`) sin `RenderFlex overflow`
* **Causa raíz detectada:**
  En pantallas móviles compactas (`360dp` de ancho lógico, como el `TECNO KJ5`), los encabezados largos (`Tu Mercado Ferretero` junto al botón `Mi Pedido`), los metadatos de la tarjeta y las filas del desglose financiero podían truncarse o desbordar si no tenían restricciones elásticas.
* **Solución implementada:**
  1. Se envolvió el título principal en `FittedBox(fit: BoxFit.scaleDown)` para que siempre se lea completo sin truncarse con `...`.
  2. En `ProductTierCard` se simplificó el pie de tarjeta al patrón de Google Stitch: píldora **`+ Agregar`** cuando la cantidad es `0` y control **`- N +`** cuando es mayor a `0`, junto con `Wrap` para el subtotal y la insignia de ahorro.
  3. Se añadió un test de widgets explícito a resolución `360x800` (`test/widget_test.dart`) que certifica cero *overflows* en ambas pantallas.

### 5.3. Colisión de Instancia de Isar y Error `type 'Null' is not a subtype of type 'bool'` tras Hot Reload
* **Causa raíz detectada:**
  1. Al compartir el nombre de instancia por defecto (`default`) con esquemas previos o durante un *Hot Restart*, Isar podía arrojar conflicto de instancia abierta.
  2. Al agregar un campo booleano (`allowLazyOpen`) en `IsarDraftLocalDataSource` y aplicar *Hot Reload* (sin *Hot Restart*), la instancia singleton ya viva en el heap de la Dart VM conservó ese campo nuevo con valor `null` en tiempo de ejecución. Por eso, después de tomar y comprimir exitosamente la foto en el Isolate (`4.1 MB → 154 KB`), al intentar persistirla en `_getIsar()` la expresión booleana arrojaba `type 'Null' is not a subtype of type 'bool'`.
* **Solución implementada:**
  Se eliminó por completo la bandera booleana de `IsarDraftLocalDataSource`, haciendo que `_getIsar()` verifique directamente `_isar != null && _isar!.isOpen` y reutilice de forma segura `Isar.getInstance('tmf_b2b_rfq') ?? Isar.getInstance()`, garantizando compatibilidad total tanto en *Hot Reload* como en *Hot Restart*.

### 5.4. Logs del fabricante en `TECNO KJ5`: `W/AppResolutionTuner: Target file doesn't exist: /data/retuner/sf_resolution_tuner_app_list.xml` y `D/TranClassInfo`
* **¿Qué significan?:**
  Son mensajes informativos del sistema operativo **HiOS (Transsion / Tecno Mobile)** inyectados por la ROM del teléfono en todos los procesos Android para verificar si el paquete actual está en su lista de videojuegos (`sf_resolution_tuner_app_list.xml`) y aplicar escalado de resolución propietario. **No son errores de Flutter ni de la aplicación** y son completamente inocuos.


