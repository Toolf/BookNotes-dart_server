import 'package:postgres/postgres.dart';

import '../../db/database.dart';
import 'pg_config.dart';

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
