import 'pg_config.dart';

class Config {
  final PgConfig pgConfig;

  Config._({
    required this.pgConfig,
  });

  factory Config.debug() {
    return Config._(pgConfig: pgDefaultConfig);
  }
}

final config = Config.debug();
