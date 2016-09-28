// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:stack_trace/stack_trace.dart';

import 'base_client.dart';
import 'base_request.dart';
import 'byte_stream.dart';
import 'exception.dart';
import 'streamed_response.dart';

class BrowserClient extends BaseClient {
  /// The currently active XHRs.
  ///
  /// These are aborted if the client is closed.
  final _xhrs = new Set<HttpRequest>();

  BrowserClient();

  bool withCredentials = false;

  Future<StreamedResponse> send(BaseRequest request) async {
    var bytes = await request.finalize().toBytes();
    var xhr = new HttpRequest();
    _xhrs.add(xhr);
    _openHttpRequest(xhr, request.method, request.url.toString(), asynch: true);
    xhr.responseType = 'blob';
    xhr.withCredentials = withCredentials;
    request.headers.forEach(xhr.setRequestHeader);

    var completer = new Completer<StreamedResponse>();
    xhr.onLoad.first.then((_) {
      // TODO(nweiz): Set the response type to "arraybuffer" when issue 18542
      // is fixed.
      var blob = xhr.response == null ? new Blob([]) : xhr.response;
      var reader = new FileReader();

      reader.onLoad.first.then((_) {
        var body = reader.result as Uint8List;
        completer.complete(new StreamedResponse(
            new ByteStream.fromBytes(body),
            xhr.status,
            contentLength: body.length,
            request: request,
            headers: xhr.responseHeaders,
            reasonPhrase: xhr.statusText));
      });

      reader.onError.first.then((error) {
        completer.completeError(
            new ClientException(error.toString(), request.url),
            new Chain.current());
      });

      reader.readAsArrayBuffer(blob);
    });

    xhr.onError.first.then((_) {
      // Unfortunately, the underlying XMLHttpRequest API doesn't expose any
      // specific information about the error itself.
      completer.completeError(
          new ClientException("XMLHttpRequest error.", request.url),
          new Chain.current());
    });

    xhr.send(bytes);

    try {
      return await completer.future;
    } finally {
      _xhrs.remove(xhr);
    }
  }

  // TODO(nweiz): Remove this when sdk#24637 is fixed.
  void _openHttpRequest(HttpRequest request, String method, String url,
      {bool asynch, String user, String password}) {
    request.open(method, url, async: asynch, user: user, password: password);
  }

  void close() {
    for (var xhr in _xhrs) {
      xhr.abort();
    }
  }
}
