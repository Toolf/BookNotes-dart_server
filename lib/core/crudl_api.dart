import '../core/endpoint.dart';
import '../core/pagination/pagination.dart';
import 'schema/basic_shema.dart';
import 'schema/schema_base.dart';

abstract class CrudlDatasource<Entity, CreateEntity, UpdateEntity> {
  Future<int> create(CreateEntity entity);
  Future<Entity> read(int entityId);
  Future<Entity> update(UpdateEntity entity);
  Future<Entity> delete(int entityId);
  Future<PaginationResponce<Entity>> list(PaginationRequest request);
}

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

  CreateEndoint get create => CreateEndoint(entityCreateSchema, datasource);
  // TODO: implement
  ReadEndoint get read => ReadEndoint(intSchema);
  // UpdateEndoint get update => UpdateEndoint(entityUpdateSchema);
  // DeleteEndoint get delete => DeleteEndoint(intSchema);
  // ListEndoint get list => ListEndoint(PaginationResponceSchema(entitySchema));
}

class CreateEndoint<Entity, DataSource extends CrudlDatasource>
    extends Endpoint<Entity, int> {
  final SchemaBase<Entity> param;
  final DataSource dataSource;

  CreateEndoint(this.param, this.dataSource);

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
