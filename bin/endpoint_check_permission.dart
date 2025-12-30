part of 'server.dart';

extension EndpointCheckPermission on Endpoint {
  Future<void> checkPermission(Request req) async {
    if (access is Public){
      return;
    }
    final authHeader = req.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      throw ForbiddenException("Missing token");
    }
    try {
      final jwtService = JwtService(config.jwtConfig.secret);
      final token = authHeader.substring('Bearer '.length);
      final tokenInfo = jwtService.verifyToken(token); 
      final userId = tokenInfo.payload['sub'] as int;
      final user = await db.user.read(userId);

      if (access is Logged){
        return;
      }
      if (access is Login) {
        if ((access as Login).name == user.username) {
          return;
        } else {
          throw ForbiddenException("Access denied");
        }
      }
      final group = user.userGroupId != null ? await db.userGroup.read(user.userGroupId!) : null;
      if (group == null) {
        throw ForbiddenException("Access denied");
      }

      if (access is Group) {
        if ((access as Group).name == group.name){
          return;
        }
        else {
          throw ForbiddenException("Access denied");
        }
      }

      if (access is Acl) {
        if (!group.permissions.containsKey((access as Acl).entity)) {
          throw ForbiddenException("Access denied");
        }

        if (!await user.can((access as Acl).entity, (access as Acl).action)) {
          throw ForbiddenException("Access denied");          
        }

        return;
      }
    } catch (e){
      if (e is ForbiddenException){
        rethrow;
      }
      throw ForbiddenException("Invalid Token");
    }
  }
}