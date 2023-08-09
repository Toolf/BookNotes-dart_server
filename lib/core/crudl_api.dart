import '../core/endpoint.dart';
import '../core/pagination/pagination.dart';
import 'db/crudl_datasource.dart';
import 'exception/validation_exception.dart';
import 'pagination/pagination_schema.dart';
import 'schema/basic_schema.dart';
import 'schema/schema.dart';
import 'schema/schema_base.dart';

class CrudlApi<Entity, CreateEntity, UpdateEntity> {
  final CrudlDatasource<Entity, CreateEntity, UpdateEntity> datasource;
  final Schema<Entity> entitySchema;
  final SchemaBase<UpdateEntity> entityUpdateSchema;
  final SchemaBase<CreateEntity> entityCreateSchema;
  final List<String>? tags;

  CrudlApi({
    required this.datasource,
    required this.entitySchema,
    required this.entityUpdateSchema,
    required this.entityCreateSchema,
    this.tags,
  });

  CreateEndpoint<CreateEntity, CreateDatasource<CreateEntity>> get create =>
      CreateEndpoint(entityCreateSchema, datasource, tags);
  ReadEndpoint<Entity, ReadDatasource<Entity>> get read =>
      ReadEndpoint(entitySchema, datasource, tags);
  UpdateEndpoint<Entity, UpdateEntity, UpdateDatasource<Entity, UpdateEntity>>
      get update =>
          UpdateEndpoint(entitySchema, entityUpdateSchema, datasource, tags);
  DeleteEndpoint<Entity, DeleteDatasource<Entity>> get delete =>
      DeleteEndpoint(entitySchema, datasource, tags);
  ListEndpoint<Entity, ListDatasource<Entity>> get list =>
      ListEndpoint(entitySchema, datasource, tags);
}

class CreateEndpoint<CreateEntity,
        DataSource extends CreateDatasource<CreateEntity>>
    extends Endpoint<CreateEntity, int> {
  final SchemaBase<CreateEntity> param;
  final DataSource dataSource;
  final List<String>? _tags;

  CreateEndpoint(this.param, this.dataSource, [this._tags]);

  @override
  SchemaBase<CreateEntity>? get parameters => param;
  @override
  SchemaBase<int>? get returns => intSchema;
  @override
  List<String> get tags => _tags ?? [];

  @override
  Future<int> method(CreateEntity data) async {
    final entityId = await dataSource.create(data);
    return entityId;
  }

  @override
  void validate(CreateEntity data) {}
}

class ReadEndpoint<Entity, DataSource extends ReadDatasource<Entity>>
    extends Endpoint<int, Entity> {
  final SchemaBase<Entity> entitySchema;
  final DataSource dataSource;
  final List<String>? _tags;

  ReadEndpoint(this.entitySchema, this.dataSource, [this._tags]);

  @override
  SchemaBase<int>? get parameters => intSchema;
  @override
  SchemaBase<Entity>? get returns => entitySchema;
  @override
  List<String> get tags => _tags ?? [];

  @override
  Future<Entity> method(int entityId) async {
    final entity = await dataSource.read(entityId);
    return entity;
  }

  @override
  void validate(int entityId) {
    if (entityId < 0) {
      throw ValidationException("Entity id must be positive number");
    }
  }
}

class UpdateEndpoint<Entity, UpdateEntity,
        DataSource extends UpdateDatasource<Entity, UpdateEntity>>
    extends Endpoint<UpdateEntity, Entity> {
  final SchemaBase<Entity> entitySchema;
  final SchemaBase<UpdateEntity> param;
  final DataSource dataSource;
  final List<String>? _tags;

  UpdateEndpoint(this.entitySchema, this.param, this.dataSource, [this._tags]);

  @override
  SchemaBase<UpdateEntity>? get parameters => param;
  @override
  SchemaBase<Entity>? get returns => entitySchema;
  @override
  List<String> get tags => _tags ?? [];

  @override
  Future<Entity> method(UpdateEntity updateEntity) async {
    final entity = await dataSource.update(updateEntity);
    return entity;
  }

  @override
  void validate(UpdateEntity updateEntity) {}
}

class DeleteEndpoint<Entity, DataSource extends DeleteDatasource<Entity>>
    extends Endpoint<int, Entity> {
  final SchemaBase<Entity> entitySchema;
  final DataSource dataSource;
  final List<String>? _tags;

  DeleteEndpoint(this.entitySchema, this.dataSource, [this._tags]);

  @override
  SchemaBase<int>? get parameters => intSchema;
  @override
  SchemaBase<Entity>? get returns => entitySchema;
  @override
  List<String> get tags => _tags ?? [];

  @override
  Future<Entity> method(int entityId) async {
    final entity = await dataSource.delete(entityId);
    return entity;
  }

  @override
  void validate(int entityId) {
    if (entityId < 0) {
      throw ValidationException("Entity id must be positive number");
    }
  }
}

class ListEndpoint<Entity, DataSource extends ListDatasource<Entity>>
    extends Endpoint<PaginationRequest, PaginationResponse<Entity>> {
  final Schema<Entity> entitySchema;
  final DataSource dataSource;
  final List<String>? _tags;

  ListEndpoint(this.entitySchema, this.dataSource, [this._tags]);

  @override
  SchemaBase<PaginationRequest>? get parameters => paginationRequestSchema;
  @override
  SchemaBase<PaginationResponse<Entity>>? get returns =>
      PaginationResponseSchema(entitySchema);
  @override
  List<String> get tags => _tags ?? [];

  @override
  Future<PaginationResponse<Entity>> method(PaginationRequest request) async {
    final entities = await dataSource.list(request);
    return entities;
  }

  @override
  void validate(PaginationRequest request) {}
}
