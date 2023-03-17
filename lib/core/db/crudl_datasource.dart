import '../pagination/pagination.dart';

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
  Future<PaginationResponse<Entity>> list(PaginationRequest request);
}

abstract class CrudlDatasource<Entity, CreateEntity, UpdateEntity>
    with
        CreateDatasource<CreateEntity>,
        ReadDatasource<Entity>,
        UpdateDatasource<Entity, UpdateEntity>,
        DeleteDatasource<Entity>,
        ListDatasource<Entity> {}
