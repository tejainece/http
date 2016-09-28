// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:http_parser/http_parser.dart';

import 'multipart_file.dart';

/// Returns a [MultipartFile] for [filePath], if `dart:io` is available.
Future<MultipartFile> newMultipartFileFromPath(String field, String filePath,
    {String filename, MediaType contentType}) {
  throw new UnsupportedError(
      "new MultipartFile.fromPath() is not supported on this platform.");
}
