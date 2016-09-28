// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

export 'io_client_unsupported.dart'
    if (dart.library.io) 'io_client_impl.dart';
