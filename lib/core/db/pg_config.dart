class PgConfig {
  final String url;
  final int port;
  final String database;
  final String username;
  final String password;

  const PgConfig({
    required this.url,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
  });
}
