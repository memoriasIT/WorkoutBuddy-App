/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// Base provider class.
///
/// Provides a couple of comfort functions so we avoid a bit of boilerplate.
class WgerBaseProvider {
  late http.Client client;

  WgerBaseProvider([http.Client? client]) {
    this.client = client ?? http.Client();
  }

  /// Helper function to make a URL.
  Uri makeUrl(String path, {int? id, String? objectMethod, Map<String, dynamic>? query}) {
    final Uri uriServer = Uri.parse('https://wger.de/api/');

    final pathList = ['api', 'v2', path];
    if (id != null) {
      pathList.add(id.toString());
    }
    if (objectMethod != null) {
      pathList.add(objectMethod);
    }

    final uri = Uri(
      scheme: uriServer.scheme,
      host: uriServer.host,
      port: uriServer.port,
      path: '${pathList.join('/')}/',
      queryParameters: query,
    );

    return uri;
  }

  /// Fetch and retrieve the overview list of objects, returns the JSON parsed response
  Future<Map<String, dynamic>> fetch(Uri uri) async {
    // Send the request
    final response = await client.get(
      uri,
      headers: {
        // HttpHeaders.authorizationHeader: 'Token ${auth.token}',
        // HttpHeaders.userAgentHeader: auth.getAppNameHeader(),
      },
    );

    // Something wrong with our request
    if (response.statusCode >= 400) {
      throw HttpException(response.body);
    }

    // Process the response
    return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  /// POSTs a new object
  Future<Map<String, dynamic>> post(Map<String, dynamic> data, Uri uri) async {
    final response = await client.post(
      uri,
      headers: {
        // HttpHeaders.authorizationHeader: 'Token ${auth.token}',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        // HttpHeaders.userAgentHeader: auth.getAppNameHeader(),
      },
      body: json.encode(data),
    );

    // Something wrong with our request
    if (response.statusCode >= 400) {
      throw HttpException(response.body);
    }

    return json.decode(response.body);
  }

  /// PATCHEs an existing object
  Future<Map<String, dynamic>> patch(Map<String, dynamic> data, Uri uri) async {
    final response = await client.patch(
      uri,
      headers: {
        // HttpHeaders.authorizationHeader: 'Token ${auth.token}',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        // HttpHeaders.userAgentHeader: auth.getAppNameHeader(),
      },
      body: json.encode(data),
    );

    // Something wrong with our request
    if (response.statusCode >= 400) {
      throw HttpException(response.body);
    }

    return json.decode(response.body);
  }

  /// DELETEs an existing object
  Future<Response> deleteRequest(String url, int id) async {
    final deleteUrl = makeUrl(url, id: id);

    final response = await client.delete(
      deleteUrl,
      headers: {
        // HttpHeaders.authorizationHeader: 'Token ${auth.token}',
        // HttpHeaders.userAgentHeader: auth.getAppNameHeader(),
      },
    );

    // Something wrong with our request
    if (response.statusCode >= 400) {
      throw HttpException(response.body);
    }
    return response;
  }
}