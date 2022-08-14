import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:book_notes/api/api.dart';
import 'package:book_notes/core/endpoint.dart';
import 'package:book_notes/core/exception/api_exception.dart';
import 'package:book_notes/core/exception/validation_exception.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

part 'endpoints.dart';

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

    endpoint.parameters?.validate(jsonData["data"]);
    final endpointData =
        endpoint.parameters?.entityConstructor(jsonData["data"]) ??
            jsonData["data"];
    endpoint.validate(endpointData);
    final res = await endpoint.method(endpointData);
    final resJsonString = jsonEncode(res);
    final resJson = jsonDecode(resJsonString);
    endpoint.returns?.validate(resJson);
    return Response.ok(resJsonString);
  } on ApiException catch (e) {
    return Response(400, body: e.message);
  } on ValidationException catch (e) {
    return Response(400, body: e.message);
  } catch (e) {
    print(e);
    return Response.internalServerError();
  }
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_rootHandler, ip, port);
  print('Server listening on port ${server.port}');
}
