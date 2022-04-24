import 'package:postgres/postgres.dart';

import '../config/config.dart';
import 'database.dart';

class PostgreConnectionFactory implements DatabaseConnectionFactory {
  @override
  PostgreSQLConnection createConnection() {
    return PostgreSQLConnection(
      config.pgConfig.url,
      config.pgConfig.port,
      config.pgConfig.database,
      username: config.pgConfig.username,
      password: config.pgConfig.password,
    );
  }
}
