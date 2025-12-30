class JwtConfig {
  final String secret;

  const JwtConfig(this.secret);
}

const jwtDefaultConfig = JwtConfig('secret');
