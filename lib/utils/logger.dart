import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HttpLogger {
  final Logger _logger;

  // Initialize with default logger or custom logger
  HttpLogger({Logger? logger})
      : _logger = logger ??
            Logger(
              printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5, lineLength: 75, colors: true, printEmojis: true, printTime: true),
            );

  // Create a client with logging
  http.Client createLoggingClient() {
    return _LoggingClient(_logger);
  }
}

class _LoggingClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final Logger _logger;

  _LoggingClient(this._logger);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final stopwatch = Stopwatch()..start();

    // Log the request
    _logRequest(request);

    // Forward the request to the inner client
    http.StreamedResponse response;
    try {
      response = await _inner.send(request);
    } catch (e) {
      _logger.e('Request failed: $e');
      rethrow;
    }

    // Create a copy of the response for logging
    final responseBytes = await response.stream.toBytes();
    final responseCopy = http.StreamedResponse(
      Stream.fromIterable([responseBytes]),
      response.statusCode,
      contentLength: responseBytes.length,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
      request: response.request,
    );

    // Log the response
    stopwatch.stop();
    _logResponse(responseCopy, responseBytes, stopwatch.elapsed);

    // Return a new stream with the response bytes
    return http.StreamedResponse(
      Stream.fromIterable([responseBytes]),
      response.statusCode,
      contentLength: responseBytes.length,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
      request: response.request,
    );
  }

  void _logRequest(http.BaseRequest request) {
    final logMessage = StringBuffer();
    logMessage.writeln('┌────── HTTP Request ──────');
    logMessage.writeln('│ ${request.method} ${request.url}');

    // Log headers
    request.headers.forEach((name, value) {
      // Avoid logging sensitive headers like auth tokens
      if (name.toLowerCase() == 'authorization') {
        logMessage.writeln('│ $name: ${_maskAuthToken(value)}');
      } else {
        logMessage.writeln('│ $name: $value');
      }
    });

    // Log body for POST/PUT requests
    if (request is http.Request && request.body.isNotEmpty) {
      try {
        // Try to parse as JSON for pretty printing
        final jsonBody = jsonDecode(request.body);
        logMessage.writeln('│ Body: ${JsonEncoder.withIndent('  ').convert(jsonBody)}');
      } catch (_) {
        // If not JSON or parsing fails, log as regular string
        logMessage.writeln('│ Body: ${request.body}');
      }
    }

    logMessage.writeln('└────────────────────────');
    _logger.d(logMessage.toString());
  }

  void _logResponse(http.StreamedResponse response, List<int> responseBytes, Duration duration) {
    final logMessage = StringBuffer();
    logMessage.writeln('┌────── HTTP Response ──────');
    logMessage.writeln('│ ${response.statusCode} - ${response.reasonPhrase} (${duration.inMilliseconds}ms)');

    // Log headers
    response.headers.forEach((name, value) {
      logMessage.writeln('│ $name: $value');
    });

    // Log body
    if (responseBytes.isNotEmpty) {
      final contentType = response.headers['content-type'] ?? '';

      if (contentType.contains('application/json')) {
        try {
          final jsonBody = jsonDecode(utf8.decode(responseBytes));
          logMessage.writeln('│ Body: ${JsonEncoder.withIndent('  ').convert(jsonBody)}');
        } catch (e) {
          logMessage.writeln('│ Body: ${utf8.decode(responseBytes)}');
        }
      } else if (contentType.contains('text/')) {
        logMessage.writeln('│ Body: ${utf8.decode(responseBytes)}');
      } else {
        logMessage.writeln('│ Body: Binary data (${responseBytes.length} bytes)');
      }
    }

    logMessage.writeln('└────────────────────────');

    // Log with appropriate level based on status code
    if (response.statusCode >= 500) {
      _logger.e(logMessage.toString());
    } else if (response.statusCode >= 400) {
      _logger.w(logMessage.toString());
    } else {
      _logger.i(logMessage.toString());
    }
  }

  String _maskAuthToken(String token) {
    if (token.length < 10) return '********';
    return '${token.substring(0, 5)}...${token.substring(token.length - 5)}';
  }

  @override
  void close() {
    _inner.close();
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}
