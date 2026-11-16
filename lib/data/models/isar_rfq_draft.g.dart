// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_rfq_draft.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarRfqDraftCollection on Isar {
  IsarCollection<IsarRfqDraft> get isarRfqDrafts => this.collection();
}

const IsarRfqDraftSchema = CollectionSchema(
  name: r'IsarRfqDraft',
  id: -4027410062038123177,
  properties: {
    r'attachmentPath': PropertySchema(
      id: 0,
      name: r'attachmentPath',
      type: IsarType.string,
    ),
    r'compressedSizeBytes': PropertySchema(
      id: 1,
      name: r'compressedSizeBytes',
      type: IsarType.long,
    ),
    r'items': PropertySchema(
      id: 2,
      name: r'items',
      type: IsarType.objectList,
      target: r'IsarDraftItem',
    ),
    r'originalSizeBytes': PropertySchema(
      id: 3,
      name: r'originalSizeBytes',
      type: IsarType.long,
    ),
    r'syncStatus': PropertySchema(
      id: 4,
      name: r'syncStatus',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarRfqDraftEstimateSize,
  serialize: _isarRfqDraftSerialize,
  deserialize: _isarRfqDraftDeserialize,
  deserializeProp: _isarRfqDraftDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'IsarDraftItem': IsarDraftItemSchema},
  getId: _isarRfqDraftGetId,
  getLinks: _isarRfqDraftGetLinks,
  attach: _isarRfqDraftAttach,
  version: '3.1.0+1',
);

int _isarRfqDraftEstimateSize(
  IsarRfqDraft object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.attachmentPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.items.length * 3;
  {
    final offsets = allOffsets[IsarDraftItem]!;
    for (var i = 0; i < object.items.length; i++) {
      final value = object.items[i];
      bytesCount +=
          IsarDraftItemSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.syncStatus.length * 3;
  return bytesCount;
}

void _isarRfqDraftSerialize(
  IsarRfqDraft object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.attachmentPath);
  writer.writeLong(offsets[1], object.compressedSizeBytes);
  writer.writeObjectList<IsarDraftItem>(
    offsets[2],
    allOffsets,
    IsarDraftItemSchema.serialize,
    object.items,
  );
  writer.writeLong(offsets[3], object.originalSizeBytes);
  writer.writeString(offsets[4], object.syncStatus);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

IsarRfqDraft _isarRfqDraftDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarRfqDraft();
  object.attachmentPath = reader.readStringOrNull(offsets[0]);
  object.compressedSizeBytes = reader.readLongOrNull(offsets[1]);
  object.id = id;
  object.items = reader.readObjectList<IsarDraftItem>(
        offsets[2],
        IsarDraftItemSchema.deserialize,
        allOffsets,
        IsarDraftItem(),
      ) ??
      [];
  object.originalSizeBytes = reader.readLongOrNull(offsets[3]);
  object.syncStatus = reader.readString(offsets[4]);
  object.updatedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _isarRfqDraftDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readObjectList<IsarDraftItem>(
            offset,
            IsarDraftItemSchema.deserialize,
            allOffsets,
            IsarDraftItem(),
          ) ??
          []) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarRfqDraftGetId(IsarRfqDraft object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarRfqDraftGetLinks(IsarRfqDraft object) {
  return [];
}

void _isarRfqDraftAttach(
    IsarCollection<dynamic> col, Id id, IsarRfqDraft object) {
  object.id = id;
}

extension IsarRfqDraftQueryWhereSort
    on QueryBuilder<IsarRfqDraft, IsarRfqDraft, QWhere> {
  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarRfqDraftQueryWhere
    on QueryBuilder<IsarRfqDraft, IsarRfqDraft, QWhereClause> {
  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarRfqDraftQueryFilter
    on QueryBuilder<IsarRfqDraft, IsarRfqDraft, QFilterCondition> {
  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'attachmentPath',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'attachmentPath',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attachmentPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attachmentPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attachmentPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attachmentPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'attachmentPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'attachmentPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'attachmentPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'attachmentPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attachmentPath',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      attachmentPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'attachmentPath',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      compressedSizeBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'compressedSizeBytes',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      compressedSizeBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'compressedSizeBytes',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      compressedSizeBytesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compressedSizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      compressedSizeBytesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'compressedSizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      compressedSizeBytesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'compressedSizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      compressedSizeBytesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'compressedSizeBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      itemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      itemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      itemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      itemsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      itemsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      itemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      originalSizeBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'originalSizeBytes',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      originalSizeBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'originalSizeBytes',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      originalSizeBytesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalSizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      originalSizeBytesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalSizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      originalSizeBytesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalSizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      originalSizeBytesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalSizeBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarRfqDraftQueryObject
    on QueryBuilder<IsarRfqDraft, IsarRfqDraft, QFilterCondition> {
  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterFilterCondition> itemsElement(
      FilterQuery<IsarDraftItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'items');
    });
  }
}

extension IsarRfqDraftQueryLinks
    on QueryBuilder<IsarRfqDraft, IsarRfqDraft, QFilterCondition> {}

extension IsarRfqDraftQuerySortBy
    on QueryBuilder<IsarRfqDraft, IsarRfqDraft, QSortBy> {
  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      sortByAttachmentPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attachmentPath', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      sortByAttachmentPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attachmentPath', Sort.desc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      sortByCompressedSizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compressedSizeBytes', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      sortByCompressedSizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compressedSizeBytes', Sort.desc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      sortByOriginalSizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalSizeBytes', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      sortByOriginalSizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalSizeBytes', Sort.desc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarRfqDraftQuerySortThenBy
    on QueryBuilder<IsarRfqDraft, IsarRfqDraft, QSortThenBy> {
  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      thenByAttachmentPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attachmentPath', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      thenByAttachmentPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attachmentPath', Sort.desc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      thenByCompressedSizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compressedSizeBytes', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      thenByCompressedSizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compressedSizeBytes', Sort.desc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      thenByOriginalSizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalSizeBytes', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      thenByOriginalSizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalSizeBytes', Sort.desc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarRfqDraftQueryWhereDistinct
    on QueryBuilder<IsarRfqDraft, IsarRfqDraft, QDistinct> {
  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QDistinct> distinctByAttachmentPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attachmentPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QDistinct>
      distinctByCompressedSizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'compressedSizeBytes');
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QDistinct>
      distinctByOriginalSizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalSizeBytes');
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QDistinct> distinctBySyncStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarRfqDraft, IsarRfqDraft, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarRfqDraftQueryProperty
    on QueryBuilder<IsarRfqDraft, IsarRfqDraft, QQueryProperty> {
  QueryBuilder<IsarRfqDraft, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarRfqDraft, String?, QQueryOperations>
      attachmentPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attachmentPath');
    });
  }

  QueryBuilder<IsarRfqDraft, int?, QQueryOperations>
      compressedSizeBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compressedSizeBytes');
    });
  }

  QueryBuilder<IsarRfqDraft, List<IsarDraftItem>, QQueryOperations>
      itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'items');
    });
  }

  QueryBuilder<IsarRfqDraft, int?, QQueryOperations>
      originalSizeBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalSizeBytes');
    });
  }

  QueryBuilder<IsarRfqDraft, String, QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<IsarRfqDraft, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarDraftItemSchema = Schema(
  name: r'IsarDraftItem',
  id: -9130419688476284327,
  properties: {
    r'productId': PropertySchema(
      id: 0,
      name: r'productId',
      type: IsarType.string,
    ),
    r'quantity': PropertySchema(
      id: 1,
      name: r'quantity',
      type: IsarType.long,
    )
  },
  estimateSize: _isarDraftItemEstimateSize,
  serialize: _isarDraftItemSerialize,
  deserialize: _isarDraftItemDeserialize,
  deserializeProp: _isarDraftItemDeserializeProp,
);

int _isarDraftItemEstimateSize(
  IsarDraftItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.productId.length * 3;
  return bytesCount;
}

void _isarDraftItemSerialize(
  IsarDraftItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.productId);
  writer.writeLong(offsets[1], object.quantity);
}

IsarDraftItem _isarDraftItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarDraftItem();
  object.productId = reader.readString(offsets[0]);
  object.quantity = reader.readLong(offsets[1]);
  return object;
}

P _isarDraftItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarDraftItemQueryFilter
    on QueryBuilder<IsarDraftItem, IsarDraftItem, QFilterCondition> {
  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      productIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      quantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      quantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      quantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDraftItem, IsarDraftItem, QAfterFilterCondition>
      quantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarDraftItemQueryObject
    on QueryBuilder<IsarDraftItem, IsarDraftItem, QFilterCondition> {}
