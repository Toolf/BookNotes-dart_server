import 'access.dart';
import 'schema/schema_base.dart';

abstract class Endpoint<T, V> {
  String? caption;
  String? description;
  SchemaBase<T>? get parameters => null;
  SchemaBase<V>? returns;
  List<dynamic>? examples;
  List<dynamic>? errors;
  int timeout = -1;
  bool deprecated = false;
  Access access = Logged();

  void validate(T data);

  Future<V> method(T data);
}
