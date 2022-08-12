import 'dart:convert';

import '../exception/db_exception.dart';
import '../schema/schema.dart';
import '../schema/schema_view.dart';
import 'crudl_datasource.dart';
import '../pagination/pagination.dart';
import 'pg.dart';

class PostgresCrudlDatasource<Entity, CreateEntity, UpdateEntity>
    implements CrudlDatasource<Entity, CreateEntity, UpdateEntity> {
  final PostgreConnectionFactory connectionFactory;
  String get tableName => throw UnimplementedError();
  String get identityName => throw UnimplementedError();
  final Schema<Entity> entitySchema;
  final SchemaView<CreateEntity> createEntitySchema;
  final SchemaView<UpdateEntity> updateEntitySchema;
  final Entity Function(dynamic obj) entityConstructor;

  PostgresCrudlDatasource(
    this.entityConstructor,
    this.entitySchema,
    this.createEntitySchema,
    this.updateEntitySchema,
    this.connectionFactory,
  );

  @override
  Future<int> create(CreateEntity entity) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final fieldsNames = createEntitySchema.fields.map((f) => f.name).toList();
      final res = await connection.mappedResultsQuery(
        "INSERT INTO \"$tableName\" (${fieldsNames.map((f) => '"$f"').join(', ')}) "
        "VALUES (${fieldsNames.map((f) => '@$f').join(', ')}) "
        "RETURNING \"$identityName\"",
        substitutionValues: jsonDecode(jsonEncode(entity)),
      );
      return res.single[tableName]![identityName] as int;
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid create operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }

  @override
  Future<Entity> read(int entityId) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final fieldsNames = entitySchema.fields.keys.toList();
      final res = await connection.mappedResultsQuery(
        "SELECT ${fieldsNames.map((f) => '"$f"').join(', ')} "
        "FROM \"$tableName\" "
        "WHERE \"$identityName\" = @$identityName ",
        substitutionValues: {
          identityName: entityId,
        },
      );
      final entityData = res.single[tableName]!;
      return entityConstructor(entityData);
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid read operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }

  @override
  Future<Entity> delete(int entityId) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final res = await connection.mappedResultsQuery(
          "DELETE "
          "FROM \"$tableName\" "
          "WHERE \"$identityName\" = @$identityName "
          "RETURNING *;",
          substitutionValues: {
            identityName: entityId,
          });
      final entityData = res.single[tableName]!;
      return entityConstructor(entityData);
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid delete operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }

  @override
  Future<PaginationResponce<Entity>> list(PaginationRequest request) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final fieldsNames = entitySchema.fields.keys.toList();
      return await connection.transaction((conn) async {
        final res = await conn.mappedResultsQuery(
            "SELECT ${fieldsNames.map((f) => '"$f"').join(', ')} "
            "FROM \"$tableName\" "
            "LIMIT @limit OFFSET @offset ",
            substitutionValues: {
              "limit": request.perPage,
              "offset": request.page * request.perPage,
            });
        final entities = res.map((entityMap) {
          final entityData = entityMap[tableName]!;
          return entityConstructor(entityData);
        }).toList();

        final totalResult = await conn.query(
          "SELECT COUNT(*) "
          "FROM \"$tableName\"",
        );
        final total = totalResult.first.first;

        return PaginationResponce<Entity>(
          filter: request.filter,
          page: request.page,
          perPage: request.perPage,
          total: total,
          data: entities,
        );
      });
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid list operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }

  @override
  Future<Entity> update(UpdateEntity entity) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final fieldsNames = updateEntitySchema.fields
          .where((f) => !f.identity)
          .map((f) => f.name)
          .toList();
      final res = await connection.mappedResultsQuery(
        "UPDATE \"$tableName\" "
        "SET "
        "${fieldsNames.map((f) => '  "$f" = COALESCE(@$f, "$f")').join(', ')} "
        "WHERE \"$identityName\" = @$identityName "
        "RETURNING *;",
        substitutionValues: jsonDecode(jsonEncode(entity)),
      );
      final enityData = res.single[tableName]!;
      return entityConstructor(enityData);
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid update operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }
}
