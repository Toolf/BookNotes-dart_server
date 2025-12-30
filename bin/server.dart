import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:book_notes/api/api.dart';
import 'package:book_notes/config/config.dart';
import 'package:book_notes/core/access.dart';
import 'package:book_notes/core/endpoint.dart';
import 'package:book_notes/core/exception/api_exception.dart';
import 'package:book_notes/core/exception/db_exception.dart';
import 'package:book_notes/core/exception/validation_exception.dart';
import 'package:book_notes/core/jwt_service.dart';
import 'package:book_notes/core/permission.dart';
import 'package:book_notes/db/db.dart';
import 'package:book_notes/transport/http/cors.dart';
import 'package:book_notes/transport/http/swagger.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

part 'endpoints.dart';
part 'endpoint_check_permission.dart';

FutureOr<Response> _rootHandler(Request req) async {
  try {
    if (req.method != "POST") {
      return Response(400, body: "Invalid method");
    }

    final data = await req.readAsString();
    if (data.isEmpty) {
      return Response(400, body: "Invalid request");
    }
    final jsonData = jsonDecode(data);
    if (jsonData is! Map) {
      return Response(400, body: "Invalid request");
    }

    final method = jsonData["method"];
    if (method == null) {
      return Response(400, body: "Method field must exists");
    }

    final endpoint = endpoints[method];
    if (endpoint == null) {
      return Response(400, body: "Method not found");
    }

    await endpoint.checkPermission(req);
    endpoint.parameters?.validate(jsonData["data"]);
    final endpointData =
        endpoint.parameters?.parse(jsonData["data"]) ?? jsonData["data"];
    endpoint.validate(endpointData);
    final res = await endpoint.method(endpointData);
    final resJsonString = jsonEncode(res);
    final resJson = jsonDecode(resJsonString);
    endpoint.returns?.validate(resJson);
    return Response.ok(resJsonString);
  } on DbException catch (e) {
    return Response(400, body: '{"error": "${e.message}"}');
  } on ApiException catch (e) {
    return Response(400, body: '{"error": "${e.message}"}');
  } on ValidationException catch (e) {
    return Response(400, body: '{"error": "${e.message}"}');
  } on ForbiddenException catch (e) {
    return Response(403, body: '{"error": "${e.message}"}');
  } catch (e) {
    print(e);
    return Response.internalServerError();
  }
}

void main(List<String> args) async {
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(
        corsHeaders(
          headers: {
            ACCESS_CONTROL_ALLOW_ORIGIN: '*',
            'Content-Type': 'application/json;charset=utf-8',
          },
        ),
      )
      .addMiddleware(swagger(endpoints))
      .addHandler(_rootHandler);

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
