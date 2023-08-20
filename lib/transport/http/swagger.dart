import 'dart:convert';

import 'package:book_notes/core/endpoint.dart';
import 'package:shelf/shelf.dart';

import 'openapi.dart';

String getSwaggerUiHtml({
  required String openapiUrl,
  required String title,
  String swaggerJsUrl =
      "https://cdn.jsdelivr.net/npm/swagger-ui-dist@5/swagger-ui-bundle.js",
  String swaggerCssUrl =
      "https://cdn.jsdelivr.net/npm/swagger-ui-dist@5/swagger-ui.css",
  String swaggerFaviconUrl = "https://fastapi.tiangolo.com/img/favicon.png",
  String? oauth2RedirectUrl,
  Map<String, dynamic>? initOauth,
  Map<String, dynamic>? swaggerUiParameters,
}) {
  var html = """
    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="$swaggerCssUrl">
    <link rel="shortcut icon" href="$swaggerFaviconUrl">
    <title>$title</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="$swaggerJsUrl"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '$openapiUrl',
    """;

  for (final parameter in (swaggerUiParameters ?? {}).entries) {
    html += "${jsonEncode(parameter.key)}: ${jsonEncode(parameter.value)},\n";
  }
  if (oauth2RedirectUrl != null) {
    html += "oauth2RedirectUrl: window.location.origin + '$oauth2RedirectUrl',";
  }
  html += """
    presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
    })""";

  if (initOauth != null) {
    html += """
        ui.initOAuth(${jsonEncode(initOauth)})
        """;
  }
  html += """
    </script>
    </body>
    </html>
    """;
  return html;
}

Middleware swagger(Map<String, Endpoint> endpoints) {
  return (Handler handler) {
    return (Request req) {
      if (req.method == "GET") {
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
      return handler(req);
    };
  };
}
