// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';

import 'base_request.dart';
import 'base_response.dart';
import 'streamed_response.dart';
import 'utils.dart';
import 'http_headers/http_headers.dart';

/// An HTTP response where the entire response body is known in advance.
class Response extends BaseResponse {
  /// The bytes comprising the body of this response.
  final Uint8List bodyBytes;

  /// The body of the response as a string. This is converted from [bodyBytes]
  /// using the `charset` parameter of the `Content-Type` header field, if
  /// available. If it's unavailable or if the encoding name is unknown,
  /// [LATIN1] is used by default, as per [RFC 2616][].
  ///
  /// [RFC 2616]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html
  String get body => _encodingForHeaders(headers).decode(bodyBytes);

  /// Creates a new HTTP response with a string body.
  Response(String body, int statusCode,
      {BaseRequest request,
      HttpClientHeaders headers,
      bool isRedirect: false,
      bool persistentConnection: true,
      String reasonPhrase})
      : this.bytes(_encodingForHeaders(headers).encode(body), statusCode,
            request: request,
            headers: headers,
            isRedirect: isRedirect,
            persistentConnection: persistentConnection,
            reasonPhrase: reasonPhrase);

  /// Create a new HTTP response with a byte array body.
  Response.bytes(List<int> bodyBytes, int statusCode,
      {BaseRequest request,
      HttpClientHeaders headers,
      bool isRedirect: false,
      bool persistentConnection: true,
      String reasonPhrase})
      : bodyBytes = toUint8List(bodyBytes),
        super(statusCode,
            contentLength: bodyBytes.length,
            request: request,
            headers: headers,
            isRedirect: isRedirect,
            persistentConnection: persistentConnection,
            reasonPhrase: reasonPhrase) {}

  /// Creates a new HTTP response by waiting for the full body to become
  /// available from a [StreamedResponse].
  static Future<Response> fromStream(StreamedResponse response) {
    return response.stream.toBytes().then((body) {
      return new Response.bytes(body, response.statusCode,
          request: response.request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase);
    });
  }
}

/// Returns the encoding to use for a response with the given headers. This
/// defaults to [LATIN1] if the headers don't specify a charset or
/// if that charset is unknown.
Encoding _encodingForHeaders(HttpClientHeaders headers) => encodingForCharset(
    _contentTypeForHeaders(headers ?? new HttpClientHeaders()).parameters[
        'charset']);

/// Returns the [MediaType] object for the given headers's content-type.
///
/// Defaults to `application/octet-stream`.
MediaType _contentTypeForHeaders(HttpClientHeaders headers) {
  String contentType = headers.value('content-type');
  if (contentType != null) return new MediaType.parse(contentType);
  return new MediaType("application", "octet-stream");
}
