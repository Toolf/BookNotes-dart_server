abstract class SchemaBase<Entity> {
  final String name;
  final Entity? Function(dynamic obj)? _parse;

  SchemaBase(
    this.name,
    [this._parse,]
  );

  validate(dynamic obj);

  Entity? parse(dynamic obj) {
    if (_parse != null) {
      return _parse!(obj);
    }
    return null;
  }
}
