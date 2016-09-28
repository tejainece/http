// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'client.dart';

/// Returns a new HTTP client for the current platform.
Client newClient() {
  throw new UnsupportedError("new Client() isn't supported on this platform.");
}
