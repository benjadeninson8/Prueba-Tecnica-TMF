# Tu Mercado Ferretero (TMF) — Solicitud de Cotización B2B (RFQ)

> 🎥 **Video Demostrativo en Loom (2–3 min):**  
> 👉 **[VER VIDEO DEMOSTRATIVO EN LOOM AQUÍ](https://www.loom.com/share/8e795d33dbfc4631ab5c3444be3ca148)**

---

## 📋 Descripción del Proyecto

Aplicación móvil B2B desarrollada en **Flutter** para **Tu Mercado Ferretero (TMF)**, diseñada específicamente para compradores ferreteros que operan en galpones, depósitos y rutas con conectividad inestable.

### Características Implementadas
1. **Pantalla 1 — Catálogo B2B con Escalas (`Tier Pricing`), `MOQ` y Buscador `SKU`:**
   * Carga asíncrona desde el JSON semilla oficial (`assets/datos-semilla-mobile.json`) simulando latencia de red con `Future.delayed` de **1.5 segundos**.
   * Buscador en tiempo real por **nombre, marca o código SKU** (`FER-TAL-800W`, `FER-DISC-45`, `CON-TUB-PVC2`).
   * Cálculo y resaltado visual en tiempo real del tramo de precio por volumen alcanzado (`tiers`), ahorro mayorista acumulado y validación clara cuando la cantidad es inferior al Pedido Mínimo (`moq`).
2. **Pantalla 2 — Borrador Resiliente (Offline-First) + Compresión de Foto + Switch `'Simular Sin Señal'`:**
   * **Persistencia Local Real con Isar Database:** El borrador completo (productos, cantidades, foto comprimida y estado de sincronización) se persiste inmediatamente en disco y sobrevive intacto a cierres forzados de la aplicación (**Force Close**).
   * **Captura y Compresión de Imagen en un `Isolate`:** Permite adjuntar fotografía desde Cámara, Galería o generar un RIF de alta resolución, redimensionándola y comprimiéndola en el dispositivo antes de enviarla y mostrando en pantalla:  
     `Peso original: X MB → Peso optimizado: Y KB`.
   * **Switch `'Simular Sin Señal'` e Idempotencia:** Interruptor visible en la parte superior para simular caída de internet. Si está activo al enviar la cotización, resguarda el pedido como **`Pendiente de Sincronización`**, permite reintentar cuando regresa la señal y bloquea envíos duplicados ante múltiples toques rápidos.

---

## 🏗️ Arquitectura del Proyecto

```text
lib/
├── core/
│   └── utils/
│       └── file_size_formatter.dart       # Formateo 'Peso original: X MB → Peso optimizado: Y KB'
├── domain/
│   ├── models/
│   │   ├── b2b_product.dart               # Entidades B2BProduct y PriceTier
│   │   └── rfq_draft.dart                 # Entidad RfqDraft, DraftLineItem y RfqSyncStatus
│   └── services/
│       └── pricing_engine.dart            # Motor puro de escalas por volumen y validación MOQ
├── data/
│   ├── models/
│   │   └── isar_rfq_draft.dart            # Esquema de persistencia local en Isar Database
│   ├── repositories/
│   │   ├── catalog_repository.dart        # Carga JSON semilla con Future.delayed de 1.5s
│   │   └── draft_repository.dart          # Persistencia Write-Through ante Force Close
│   └── services/
│       └── image_compression_service.dart # Redimensionado y compresión JPEG en Isolate.run
├── presentation/
│   ├── providers/
│   │   └── rfq_providers.dart             # Riverpod Notifiers + Mutex de Idempotencia
│   ├── screens/
│   │   ├── b2b_catalog_screen.dart        # Pantalla 1: Catálogo B2B con Tiers y MOQ
│   │   └── rfq_draft_screen.dart          # Pantalla 2: Borrador Resiliente + Foto + Sin Señal
│   └── widgets/
│       ├── offline_simulator_bar.dart     # Switch superior 'Simular Sin Señal'
│       └── product_tier_card.dart         # Tarjeta interactiva con tabla de escalas en vivo
└── main.dart
```

Para conocer en detalle la justificación técnica de cada paquete y patrón utilizado, consulta el archivo [**DECISIONES.md**](./DECISIONES.md).

---

## 🚀 Instrucciones de Ejecución y Pruebas

### 1. Instalar dependencias
```bash
flutter pub get
```

### 2. Ejecutar la aplicación
```bash
flutter run
```

### 3. Ejecutar la suite de pruebas automatizadas (Unit & Widget Tests por módulo)
```bash
flutter test
```
La suite incluye pruebas aisladas para:
* `test/module1_pricing_and_catalog_test.dart`: Parseo del JSON semilla, filtro por SKU/nombre, escalas por volumen y alertas de MOQ.
* `test/module2_draft_persistence_test.dart`: Persistencia del borrador ante *Force Close* y estado *Pendiente de Sincronización*.
* `test/module3_image_compression_test.dart`: Compresión real en `Isolate` de imagen `>2.5 MB` a `<150 KB` y formato `X MB → Y KB`.
* `test/module4_state_and_offline_sync_test.dart`: Simulación *Sin Señal*, reintento al recuperar conexión y escudo de idempotencia ante 5 toques simultáneos.
* `test/widget_test.dart`: Prueba integral de interfaz de usuario sobre las 2 pantallas.
