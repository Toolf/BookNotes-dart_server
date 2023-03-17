import 'package:postgres/postgres.dart';

import 'database.dart';
import 'pg_config.dart';

class PostgresConnectionFactory implements DatabaseConnectionFactory {
  final PgConfig config;

  PostgresConnectionFactory(this.config);

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
