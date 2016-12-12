// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'base_request.dart';
import 'package:http/src/http_headers/http_headers.dart';

/// The base class for HTTP responses.
///
/// Subclasses of [BaseResponse] are usually not constructed manually; instead,
/// they're returned by [BaseClient.send] or other HTTP client methods.
abstract class BaseResponse {
  /// The (frozen) request that triggered this response.
  final BaseRequest request;

  /// The status code of the response.
  final int statusCode;

  /// The reason phrase associated with the status code.
  final String reasonPhrase;

  /// The size of the response body, in bytes.
  ///
  /// If the size of the request is not known in advance, this is `null`.
  final int contentLength;

  /// The headers for this response.
  final HttpClientHeaders headers;

  List<Cookie> _cookies;

  List<Cookie> get cookies {
    if (_cookies != null) return _cookies;
    _cookies = new List<Cookie>();
    List<String> values = headers[HttpClientHeaders.SET_COOKIE];
    if (values != null) {
      values.forEach((value) {
        _cookies.add(new Cookie.fromSetCookieValue(value));
      });
    }
    return _cookies;
  }

  /// Whether this response is a redirect.
  final bool isRedirect;

  /// Whether the server requested that a persistent connection be maintained.
  final bool persistentConnection;

  /// Creates a new HTTP response.
  BaseResponse(this.statusCode,
      {this.contentLength,
      this.request,
      HttpClientHeaders headers,
      this.isRedirect: false,
      this.persistentConnection: true,
      this.reasonPhrase})
      : headers = headers ?? new HttpClientHeaders() {
    if (statusCode < 100) {
      throw new ArgumentError("Invalid status code $statusCode.");
    } else if (contentLength != null && contentLength < 0) {
      throw new ArgumentError("Invalid content length $contentLength.");
    }
  }
}
