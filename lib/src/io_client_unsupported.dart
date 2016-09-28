// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'base_client.dart';
import 'base_request.dart';
import 'streamed_response.dart';

/// A `dart:io`-based HTTP client.
///
/// This is the default client when running on the command line.
class IOClient extends BaseClient {
  /// Creates a new HTTP client.
  ///
  /// Throws an [UnsupportedError] if `dart:io` isn't available. If `dart:io` is
  /// available and [innerClient] is passed, must be an `HttpClient`.
  IOClient([innerClient]) {
    throw new UnsupportedError("IOClient is not supported on this platform.");
  }

  Future<StreamedResponse> send(BaseRequest request) => null;
  void close() {}
}
