import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:book_notes/api/api.dart';
import 'package:book_notes/core/endpoint.dart';
import 'package:book_notes/core/exception/api_exception.dart';
import 'package:book_notes/core/exception/db_exception.dart';
import 'package:book_notes/core/exception/validation_exception.dart';
import 'package:book_notes/core/schema/basic_schema.dart';
import 'package:book_notes/core/schema/schema.dart';
import 'package:book_notes/core/schema/schema_base.dart';
import 'package:book_notes/core/schema/schema_view.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'cors.dart';
import 'swagger.dart';

part 'endpoints.dart';
part 'openapi.dart';

FutureOr<Response> _rootHandler(Request req) async {
  try {
    // Swagger
    if (req.method == "GET") {
      print(req.url.path);
      if (req.url.path == "openapi.json") {
        return Response.ok(
          jsonEncode(OpenApiSchema(
            endpoints: endpoints,
            title: "BookNotes",
            version: "0.1.0",
          )),
          headers: {
            "Content-Type": "application/json",
          },
        );
      }
      if (req.url.path == "docs") {
        return Response.ok(
          getSwaggerUiHtml(
            openapiUrl: "/openapi.json",
            title: "BookNotes",
            // oauth2RedirectUrl: "/docs/oauth2-redirect",
            swaggerUiParameters: {
              "dom_id": "#swagger-ui",
              "layout": "BaseLayout",
              "deepLinking": true,
              "showExtensions": true,
              "showCommonExtensions": true,
            },
          ),
          headers: {
            "Content-Type": "text/html",
            "Cache-Control": "private, max-age=3000",
          },
        );
      }
    }

    // Main logic
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
  } on DbException catch (e) {
    return Response(400, body: e.message);
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
      .addHandler(_rootHandler);

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
