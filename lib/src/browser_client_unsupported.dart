// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'base_client.dart';
import 'base_request.dart';
import 'streamed_response.dart';

/// A `dart:html`-based HTTP client that runs in the browser and is backed by
/// XMLHttpRequests.
///
/// This client inherits some of the limitations of XMLHttpRequest. It ignores
/// the [BaseRequest.contentLength], [BaseRequest.persistentConnection],
/// [BaseRequest.followRedirects], and [BaseRequest.maxRedirects] fields. It is
/// also unable to stream requests or responses; a request will only be sent and
/// a response will only be returned once all the data is available.
class BrowserClient extends BaseClient {
  /// Whether to send credentials such as cookies or authorization headers for
  /// cross-site requests.
  ///
  /// Defaults to `false`.
  var withCredentials = false;

  /// Creates a new HTTP client.
  ///
  /// Throws an [UnsupportedError] if `dart:html` isn't available.
  BrowserClient() {
    throw new UnsupportedError(
        "BrowserClient is not supported on this platform.");
  }

  Future<StreamedResponse> send(BaseRequest request) => null;
  void close() {}
}
