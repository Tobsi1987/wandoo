import 'dart:convert';
import 'dart:io';

/// Holt OSM-Daten vom öffentlichen Overpass-Dienst.
///
/// Gesendet wird nur die Abfrage für eine Kachel, nie eine Spur.
class OverpassClient {
  OverpassClient({
    this.endpoint = 'https://overpass-api.de/api/interpreter',
    HttpClient? http,
  }) : _http = http ?? HttpClient();

  final String endpoint;
  final HttpClient _http;

  Future<String> fetch(String query) async {
    final request = await _http.postUrl(Uri.parse(endpoint));
    request.headers
      ..contentType = ContentType('application', 'x-www-form-urlencoded')
      ..set(HttpHeaders.userAgentHeader, 'Wandoo/0.1 (Walking game)');
    request.write('data=${Uri.encodeQueryComponent(query)}');
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('Overpass ${response.statusCode}: $body');
    }
    return body;
  }
}
