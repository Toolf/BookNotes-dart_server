import '../core/db/pg_config.dart';
import 'jwt_config.dart';
import 'pg_config.dart';

class Config {
  final PgConfig pgConfig;
  final JwtConfig jwtConfig;

  Config._({
    required this.pgConfig,
    required this.jwtConfig,
  });

  factory Config.debug() {
    return Config._(
      pgConfig: pgDefaultConfig,
      jwtConfig: jwtDefaultConfig,
    );
  }
}

final config = Config.debug();
