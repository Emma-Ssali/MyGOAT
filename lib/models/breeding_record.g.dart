// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breeding_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBreedingRecordCollection on Isar {
  IsarCollection<BreedingRecord> get breedingRecords => this.collection();
}

const BreedingRecordSchema = CollectionSchema(
  name: r'BreedingRecord',
  id: -3054617548344924986,
  properties: {
    r'expectedKiddingDate': PropertySchema(
      id: 0,
      name: r'expectedKiddingDate',
      type: IsarType.dateTime,
    ),
    r'goatId': PropertySchema(
      id: 1,
      name: r'goatId',
      type: IsarType.long,
    ),
    r'matingDate': PropertySchema(
      id: 2,
      name: r'matingDate',
      type: IsarType.dateTime,
    ),
    r'notes': PropertySchema(
      id: 3,
      name: r'notes',
      type: IsarType.string,
    ),
    r'numberOfKids': PropertySchema(
      id: 4,
      name: r'numberOfKids',
      type: IsarType.long,
    ),
    r'outcome': PropertySchema(
      id: 5,
      name: r'outcome',
      type: IsarType.string,
    ),
    r'sireTagId': PropertySchema(
      id: 6,
      name: r'sireTagId',
      type: IsarType.string,
    )
  },
  estimateSize: _breedingRecordEstimateSize,
  serialize: _breedingRecordSerialize,
  deserialize: _breedingRecordDeserialize,
  deserializeProp: _breedingRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _breedingRecordGetId,
  getLinks: _breedingRecordGetLinks,
  attach: _breedingRecordAttach,
  version: '3.1.0+1',
);

int _breedingRecordEstimateSize(
  BreedingRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.outcome.length * 3;
  {
    final value = object.sireTagId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _breedingRecordSerialize(
  BreedingRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.expectedKiddingDate);
  writer.writeLong(offsets[1], object.goatId);
  writer.writeDateTime(offsets[2], object.matingDate);
  writer.writeString(offsets[3], object.notes);
  writer.writeLong(offsets[4], object.numberOfKids);
  writer.writeString(offsets[5], object.outcome);
  writer.writeString(offsets[6], object.sireTagId);
}

BreedingRecord _breedingRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BreedingRecord();
  object.expectedKiddingDate = reader.readDateTimeOrNull(offsets[0]);
  object.goatId = reader.readLong(offsets[1]);
  object.id = id;
  object.matingDate = reader.readDateTime(offsets[2]);
  object.notes = reader.readStringOrNull(offsets[3]);
  object.numberOfKids = reader.readLongOrNull(offsets[4]);
  object.outcome = reader.readString(offsets[5]);
  object.sireTagId = reader.readStringOrNull(offsets[6]);
  return object;
}

P _breedingRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _breedingRecordGetId(BreedingRecord object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _breedingRecordGetLinks(BreedingRecord object) {
  return [];
}

void _breedingRecordAttach(
    IsarCollection<dynamic> col, Id id, BreedingRecord object) {
  object.id = id;
}

extension BreedingRecordQueryWhereSort
    on QueryBuilder<BreedingRecord, BreedingRecord, QWhere> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BreedingRecordQueryWhere
    on QueryBuilder<BreedingRecord, BreedingRecord, QWhereClause> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idBetween(
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

extension BreedingRecordQueryFilter
    on QueryBuilder<BreedingRecord, BreedingRecord, QFilterCondition> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedKiddingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expectedKiddingDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedKiddingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expectedKiddingDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedKiddingDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedKiddingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedKiddingDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expectedKiddingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedKiddingDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expectedKiddingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedKiddingDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expectedKiddingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      goatIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goatId',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      goatIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goatId',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      goatIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goatId',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      goatIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goatId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      idLessThan(
    Id? value, {
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      matingDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      matingDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      matingDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      matingDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      numberOfKidsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'numberOfKids',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      numberOfKidsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'numberOfKids',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      numberOfKidsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfKids',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      numberOfKidsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfKids',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      numberOfKidsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfKids',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      numberOfKidsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfKids',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outcome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'outcome',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outcome',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      outcomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'outcome',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sireTagId',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sireTagId',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sireTagId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sireTagId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sireTagId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sireTagId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sireTagId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sireTagId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sireTagId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sireTagId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sireTagId',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      sireTagIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sireTagId',
        value: '',
      ));
    });
  }
}

extension BreedingRecordQueryObject
    on QueryBuilder<BreedingRecord, BreedingRecord, QFilterCondition> {}

extension BreedingRecordQueryLinks
    on QueryBuilder<BreedingRecord, BreedingRecord, QFilterCondition> {}

extension BreedingRecordQuerySortBy
    on QueryBuilder<BreedingRecord, BreedingRecord, QSortBy> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByExpectedKiddingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedKiddingDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByExpectedKiddingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedKiddingDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByGoatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goatId', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByGoatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goatId', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByMatingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matingDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByMatingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matingDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByNumberOfKids() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfKids', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByNumberOfKidsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfKids', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortBySireTagId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sireTagId', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortBySireTagIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sireTagId', Sort.desc);
    });
  }
}

extension BreedingRecordQuerySortThenBy
    on QueryBuilder<BreedingRecord, BreedingRecord, QSortThenBy> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByExpectedKiddingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedKiddingDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByExpectedKiddingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedKiddingDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByGoatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goatId', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByGoatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goatId', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByMatingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matingDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByMatingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matingDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByNumberOfKids() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfKids', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByNumberOfKidsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfKids', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenBySireTagId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sireTagId', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenBySireTagIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sireTagId', Sort.desc);
    });
  }
}

extension BreedingRecordQueryWhereDistinct
    on QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> {
  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByExpectedKiddingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedKiddingDate');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctByGoatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goatId');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByMatingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matingDate');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByNumberOfKids() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfKids');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctByOutcome(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outcome', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctBySireTagId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sireTagId', caseSensitive: caseSensitive);
    });
  }
}

extension BreedingRecordQueryProperty
    on QueryBuilder<BreedingRecord, BreedingRecord, QQueryProperty> {
  QueryBuilder<BreedingRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BreedingRecord, DateTime?, QQueryOperations>
      expectedKiddingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedKiddingDate');
    });
  }

  QueryBuilder<BreedingRecord, int, QQueryOperations> goatIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goatId');
    });
  }

  QueryBuilder<BreedingRecord, DateTime, QQueryOperations>
      matingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matingDate');
    });
  }

  QueryBuilder<BreedingRecord, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<BreedingRecord, int?, QQueryOperations> numberOfKidsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfKids');
    });
  }

  QueryBuilder<BreedingRecord, String, QQueryOperations> outcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outcome');
    });
  }

  QueryBuilder<BreedingRecord, String?, QQueryOperations> sireTagIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sireTagId');
    });
  }
}
