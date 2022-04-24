abstract class SchemaBase<Entity> {
  final String name;
  final Entity Function(dynamic obj) entityConstructor;

  SchemaBase(
    this.name,
    this.entityConstructor,
  );

  validate(dynamic obj);
}
