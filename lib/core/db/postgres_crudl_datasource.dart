import 'dart:convert';

import '../exception/db_exception.dart';
import '../pagination/pagination.dart';
import '../schema/schema.dart';
import '../schema/schema_view.dart';
import 'crudl_datasource.dart';
import 'pg.dart';

class PostgresCrudlDatasource<Entity, CreateEntity, UpdateEntity>
    implements CrudlDatasource<Entity, CreateEntity, UpdateEntity> {
  final PostgresConnectionFactory connectionFactory;
  String get tableName => throw UnimplementedError();
  String get identityName => "${tableName.toLowerCase()}Id";
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
      if (e is DbException) {
        rethrow;
      } else {
        throw DbException("Invalid create operation", e);
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

      final fieldsNames = entitySchema.fields.entries
          .where((f) => !f.value.related)
          .map((f) => f.key)
          .toList();
      final res = await connection.mappedResultsQuery(
        "SELECT ${fieldsNames.map((f) => '"$f"').join(', ')} "
        "FROM \"$tableName\" "
        "WHERE \"$identityName\" = @$identityName ",
        substitutionValues: {
          identityName: entityId,
        },
      );
      if (res.isEmpty) {
        throw DbException("Not found entity", null);
      }
      final entityData = res.single[tableName]!;

      return entityConstructor(entityData);
    } catch (e) {
      if (e is DbException) {
        rethrow;
      } else {
        throw DbException("Invalid read operation", e);
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
      if (res.isEmpty) {
        throw DbException("Not found entity", null);
      }
      final entityData = res.single[tableName]!;
      return entityConstructor(entityData);
    } catch (e) {
      if (e is DbException) {
        rethrow;
      } else {
        throw DbException("Invalid delete operation", e);
      }
    } finally {
      await connection.close();
    }
  }

  @override
  Future<PaginationResponse<Entity>> list(PaginationRequest request) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final fieldsNames = entitySchema.fields.entries
          .where((f) => !f.value.related)
          .map((f) => f.key)
          .toList();
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

        return PaginationResponse<Entity>(
          filter: request.filter,
          page: request.page,
          perPage: request.perPage,
          total: total,
          data: entities,
        );
      });
    } catch (e) {
      if (e is DbException) {
        rethrow;
      } else {
        throw DbException("Invalid list operation", e);
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
      if (res.isEmpty) {
        throw DbException("Not found entity", null);
      }
      final entityData = res.single[tableName]!;
      return entityConstructor(entityData);
    } catch (e) {
      if (e is DbException) {
        rethrow;
      } else {
        throw DbException("Invalid update operation", e);
      }
    } finally {
      await connection.close();
    }
  }
}
