import 'package:postgres/postgres.dart';

import '../config/pg_config.dart';
import 'database.dart';

class PostgreConnectionFactory implements DatabaseConnectionFactory {
  final PgConfig config;

  PostgreConnectionFactory(this.config);

  @override
  PostgreSQLConnection createConnection() {
    return PostgreSQLConnection(
      config.url,
      config.port,
      config.database,
      username: config.username,
      password: config.password,
    );
  }
}
