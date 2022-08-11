import 'exception/validation_exception.dart';

import '../core/endpoint.dart';
import '../core/pagination/pagination.dart';
import 'schema/basic_shema.dart';
import 'schema/schema_base.dart';

abstract class CreateDatasource<CreateEntity> {
  Future<int> create(CreateEntity entity);
}

abstract class ReadDatasource<Entity> {
  Future<Entity> read(int entityId);
}

abstract class UpdateDatasource<Entity, UpdateEntity> {
  Future<Entity> update(UpdateEntity entity);
}

abstract class DeleteDatasource<Entity> {
  Future<Entity> delete(int entityId);
}

abstract class ListDatasource<Entity> {
  Future<PaginationResponce<Entity>> list(PaginationRequest request);
}

abstract class CrudlDatasource<Entity, CreateEntity, UpdateEntity>
    with
        CreateDatasource<CreateEntity>,
        ReadDatasource<Entity>,
        UpdateDatasource<Entity, UpdateEntity>,
        DeleteDatasource<Entity>,
        ListDatasource<Entity> {}

class CrudlApi<Entity, CreateEntity, UpdateEntity> {
  final String entity;
  final CrudlDatasource<Entity, CreateEntity, UpdateEntity> datasource;
  final SchemaBase<Entity> entitySchema;
  final SchemaBase<Entity> entityUpdateSchema;
  final SchemaBase<Entity> entityCreateSchema;

  CrudlApi({
    required this.entity,
    required this.datasource,
    required this.entitySchema,
    required this.entityUpdateSchema,
    required this.entityCreateSchema,
  });

  CreateEndpoint get create => CreateEndpoint(entityCreateSchema, datasource);
  ReadEndpoint get read => ReadEndpoint(datasource);
  // TODO: implement
  // UpdateEndoint get update => UpdateEndoint(entityUpdateSchema);
  // DeleteEndoint get delete => DeleteEndoint(intSchema);
  // ListEndoint get list => ListEndoint(PaginationResponceSchema(entitySchema));
}

class CreateEndpoint<Entity, DataSource extends CrudlDatasource>
    extends Endpoint<Entity, int> {
  final SchemaBase<Entity> param;
  final DataSource dataSource;

  CreateEndpoint(this.param, this.dataSource);

  @override
  SchemaBase<Entity>? get parameters => param;

  @override
  Future<int> method(Entity data) async {
    final entityId = dataSource.create(data);
    return entityId;
  }

  @override
  void validate(Entity data) {}
}

class ReadEndpoint<Entity, DataSource extends ReadDatasource<Entity>>
    extends Endpoint<int, Entity> {
  final DataSource dataSource;

  ReadEndpoint(this.dataSource);

  @override
  SchemaBase<int>? get parameters => intSchema;

  @override
  Future<Entity> method(int entityId) async {
    final entity = dataSource.read(entityId);
    return entity;
  }

  @override
  void validate(int entityId) {
    if (entityId < 0) {
      throw ValidationException("Entity id must be positive number");
    }
  }
}
