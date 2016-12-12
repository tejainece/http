part of http.http_headers;

// Frequently used character codes.
class _CharCode {
  static const int HT = 9;
  static const int LF = 10;
  static const int CR = 13;
  static const int SP = 32;
  static const int AMPERSAND = 38;
  static const int COMMA = 44;
  static const int DASH = 45;
  static const int SLASH = 47;
  static const int ZERO = 48;
  static const int ONE = 49;
  static const int COLON = 58;
  static const int SEMI_COLON = 59;
  static const int EQUAL = 61;
}

/**
 * Representation of a header value in the form:
 *
 *   [:value; parameter1=value1; parameter2=value2:]
 *
 * [HeaderValue] can be used to conveniently build and parse header
 * values on this form.
 *
 * To build an [:accepts:] header with the value
 *
 *     text/plain; q=0.3, text/html
 *
 * use code like this:
 *
 *     HttpClientRequest request = ...;
 *     var v = new HeaderValue("text/plain", {"q": "0.3"});
 *     request.headers.add(HttpHeaders.ACCEPT, v);
 *     request.headers.add(HttpHeaders.ACCEPT, "text/html");
 *
 * To parse the header values use the [:parse:] static method.
 *
 *     HttpRequest request = ...;
 *     List<String> values = request.headers[HttpHeaders.ACCEPT];
 *     values.forEach((value) {
 *       HeaderValue v = HeaderValue.parse(value);
 *       // Use v.value and v.parameters
 *     });
 *
 * An instance of [HeaderValue] is immutable.
 */
abstract class HeaderValue {
  /**
   * Creates a new header value object setting the value and parameters.
   */
  factory HeaderValue([String value = "", Map<String, String> parameters]) {
    return new _HeaderValue(value, parameters);
  }

  /**
   * Creates a new header value object from parsing a header value
   * string with both value and optional parameters.
   */
  static HeaderValue parse(String value,
      {String parameterSeparator: ";",
      String valueSeparator: null,
      bool preserveBackslash: false}) {
    return _HeaderValue.parse(value,
        parameterSeparator: parameterSeparator,
        valueSeparator: valueSeparator,
        preserveBackslash: preserveBackslash);
  }

  /**
   * Gets the header value.
   */
  String get value;

  /**
   * Gets the map of parameters.
   *
   * This map cannot be modified. invoking any operation which would
   * modify the map will throw [UnsupportedError].
   */
  Map<String, String> get parameters;

  /**
   * Returns the formatted string representation in the form:
   *
   *     value; parameter1=value1; parameter2=value2
   */
  String toString();
}

/**
 * Headers for HTTP requests and responses.
 *
 * In some situations, headers are immutable:
 *
 * * HttpRequest and HttpClientResponse always have immutable headers.
 *
 * * HttpResponse and HttpClientRequest have immutable headers
 *   from the moment the body is written to.
 *
 * In these situations, the mutating methods throw exceptions.
 *
 * For all operations on HTTP headers the header name is
 * case-insensitive.
 *
 * To set the value of a header use the `set()` method:
 *
 *     request.headers.set(HttpHeaders.CACHE_CONTROL,
 *                         'max-age=3600, must-revalidate');
 *
 * To retrieve the value of a header use the `value()` method:
 *
 *     print(request.headers.value(HttpHeaders.USER_AGENT));
 *
 * An HttpHeaders object holds a list of values for each name
 * as the standard allows. In most cases a name holds only a single value,
 * The most common mode of operation is to use `set()` for setting a value,
 * and `value()` for retrieving a value.
 */
class HttpClientHeaders {
  static const ACCEPT = "accept";
  static const ACCEPT_CHARSET = "accept-charset";
  static const ACCEPT_ENCODING = "accept-encoding";
  static const ACCEPT_LANGUAGE = "accept-language";
  static const ACCEPT_RANGES = "accept-ranges";
  static const AGE = "age";
  static const ALLOW = "allow";
  static const AUTHORIZATION = "authorization";
  static const CACHE_CONTROL = "cache-control";
  static const CONNECTION = "connection";
  static const CONTENT_ENCODING = "content-encoding";
  static const CONTENT_LANGUAGE = "content-language";
  static const CONTENT_LENGTH = "content-length";
  static const CONTENT_LOCATION = "content-location";
  static const CONTENT_MD5 = "content-md5";
  static const CONTENT_RANGE = "content-range";
  static const CONTENT_TYPE = "content-type";
  static const DATE = "date";
  static const ETAG = "etag";
  static const EXPECT = "expect";
  static const EXPIRES = "expires";
  static const FROM = "from";
  static const HOST = "host";
  static const IF_MATCH = "if-match";
  static const IF_MODIFIED_SINCE = "if-modified-since";
  static const IF_NONE_MATCH = "if-none-match";
  static const IF_RANGE = "if-range";
  static const IF_UNMODIFIED_SINCE = "if-unmodified-since";
  static const LAST_MODIFIED = "last-modified";
  static const LOCATION = "location";
  static const MAX_FORWARDS = "max-forwards";
  static const PRAGMA = "pragma";
  static const PROXY_AUTHENTICATE = "proxy-authenticate";
  static const PROXY_AUTHORIZATION = "proxy-authorization";
  static const RANGE = "range";
  static const REFERER = "referer";
  static const RETRY_AFTER = "retry-after";
  static const SERVER = "server";
  static const TE = "te";
  static const TRAILER = "trailer";
  static const TRANSFER_ENCODING = "transfer-encoding";
  static const UPGRADE = "upgrade";
  static const USER_AGENT = "user-agent";
  static const VARY = "vary";
  static const VIA = "via";
  static const WARNING = "warning";
  static const WWW_AUTHENTICATE = "www-authenticate";

  // Cookie headers from RFC 6265.
  static const COOKIE = "cookie";
  static const SET_COOKIE = "set-cookie";

  static const GENERAL_HEADERS = const [
    CACHE_CONTROL,
    CONNECTION,
    DATE,
    PRAGMA,
    TRAILER,
    TRANSFER_ENCODING,
    UPGRADE,
    VIA,
    WARNING
  ];

  static const ENTITY_HEADERS = const [
    ALLOW,
    CONTENT_ENCODING,
    CONTENT_LANGUAGE,
    CONTENT_LENGTH,
    CONTENT_LOCATION,
    CONTENT_MD5,
    CONTENT_RANGE,
    CONTENT_TYPE,
    EXPIRES,
    LAST_MODIFIED
  ];

  static const RESPONSE_HEADERS = const [
    ACCEPT_RANGES,
    AGE,
    ETAG,
    LOCATION,
    PROXY_AUTHENTICATE,
    RETRY_AFTER,
    SERVER,
    VARY,
    WWW_AUTHENTICATE
  ];

  static const REQUEST_HEADERS = const [
    ACCEPT,
    ACCEPT_CHARSET,
    ACCEPT_ENCODING,
    ACCEPT_LANGUAGE,
    AUTHORIZATION,
    EXPECT,
    FROM,
    HOST,
    IF_MATCH,
    IF_MODIFIED_SINCE,
    IF_NONE_MATCH,
    IF_RANGE,
    IF_UNMODIFIED_SINCE,
    MAX_FORWARDS,
    PROXY_AUTHORIZATION,
    RANGE,
    REFERER,
    TE,
    USER_AGENT
  ];

  final Map<String, List<String>> _headers;
  final String protocolVersion;

  bool _mutable = true; // Are the headers currently mutable?
  List<String> _noFoldingHeaders;

  int _contentLength = -1;
  bool _persistentConnection = true;
  bool _chunkedTransferEncoding = false;
  String _host;
  int _port;

  final int _defaultPortForScheme;

  HttpClientHeaders(
      {this.protocolVersion: "1.1",
      int defaultPortForScheme: Client.DEFAULT_HTTP_PORT,
      HttpClientHeaders initialHeaders})
      : _headers = new HashMap<String, List<String>>(),
        _defaultPortForScheme = defaultPortForScheme {
    if (initialHeaders != null) {
      initialHeaders._headers.forEach((name, value) => _headers[name] = value);
      _contentLength = initialHeaders._contentLength;
      _persistentConnection = initialHeaders._persistentConnection;
      _chunkedTransferEncoding = initialHeaders._chunkedTransferEncoding;
      _host = initialHeaders._host;
      _port = initialHeaders._port;
    }
    if (protocolVersion == "1.0") {
      _persistentConnection = false;
      _chunkedTransferEncoding = false;
    }
  }

  /**
   * Returns the list of values for the header named [name]. If there
   * is no header with the provided name, [:null:] will be returned.
   */
  List<String> operator [](String name) => _headers[name.toLowerCase()];

  /**
   * Convenience method for the value for a single valued header. If
   * there is no header with the provided name, [:null:] will be
   * returned. If the header has more than one value an exception is
   * thrown.
   */
  String value(String name) {
    name = name.toLowerCase();
    List<String> values = _headers[name];
    if (values == null) return null;
    if (values.length > 1) {
      throw new Exception("More than one value for header $name");
    }
    return values[0];
  }

  /**
   * Adds a header value. The header named [name] will have the value
   * [value] added to its list of values. Some headers are single
   * valued, and for these adding a value will replace the previous
   * value. If the value is of type DateTime a HTTP date format will be
   * applied. If the value is a [:List:] each element of the list will
   * be added separately. For all other types the default [:toString:]
   * method will be used.
   */
  void add(String name, value) {
    _checkMutable();
    _addAll(_validateField(name), value);
  }

  void _addAll(String name, value) {
    assert(name == _validateField(name));
    if (value is Iterable) {
      for (var v in value) {
        _add(name, _validateValue(v));
      }
    } else {
      _add(name, _validateValue(value));
    }
  }

  /**
   * Sets a header. The header named [name] will have all its values
   * cleared before the value [value] is added as its value.
   */
  void set(String name, Object value) {
    _checkMutable();
    name = _validateField(name);
    _headers.remove(name);
    if (name == HttpClientHeaders.TRANSFER_ENCODING) {
      _chunkedTransferEncoding = false;
    }
    _addAll(name, value);
  }

  /**
   * Removes a specific value for a header name. Some headers have
   * system supplied values and for these the system supplied values
   * will still be added to the collection of values for the header.
   */
  void remove(String name, Object value) {
    _checkMutable();
    name = _validateField(name);
    value = _validateValue(value);
    List<String> values = _headers[name];
    if (values != null) {
      int index = values.indexOf(value);
      if (index != -1) {
        values.removeRange(index, index + 1);
      }
      if (values.length == 0) _headers.remove(name);
    }
    if (name == HttpClientHeaders.TRANSFER_ENCODING && value == "chunked") {
      _chunkedTransferEncoding = false;
    }
  }

  /**
   * Removes all values for the specified header name. Some headers
   * have system supplied values and for these the system supplied
   * values will still be added to the collection of values for the
   * header.
   */
  void removeAll(String name) {
    _checkMutable();
    name = _validateField(name);
    _headers.remove(name);
  }

  /**
   * Enumerates the headers, applying the function [f] to each
   * header. The header name passed in [:name:] will be all lower
   * case.
   */
  void forEach(void f(String name, List<String> values)) {
    _headers.forEach(f);
  }

  /**
   * Disables folding for the header named [name] when sending the HTTP
   * header. By default, multiple header values are folded into a
   * single header line by separating the values with commas. The
   * 'set-cookie' header has folding disabled by default.
   */
  void noFolding(String name) {
    if (_noFoldingHeaders == null) _noFoldingHeaders = new List<String>();
    _noFoldingHeaders.add(name);
  }

  /**
   * Gets and sets the persistent connection header value.
   */
  bool get persistentConnection => _persistentConnection;

  void set persistentConnection(bool persistentConnection) {
    _checkMutable();
    if (persistentConnection == _persistentConnection) return;
    if (persistentConnection) {
      if (protocolVersion == "1.1") {
        remove(HttpClientHeaders.CONNECTION, "close");
      } else {
        if (_contentLength == -1) {
          throw new Exception(
              "Trying to set 'Connection: Keep-Alive' on HTTP 1.0 headers with "
              "no ContentLength");
        }
        add(HttpClientHeaders.CONNECTION, "keep-alive");
      }
    } else {
      if (protocolVersion == "1.1") {
        add(HttpClientHeaders.CONNECTION, "close");
      } else {
        remove(HttpClientHeaders.CONNECTION, "keep-alive");
      }
    }
    _persistentConnection = persistentConnection;
  }

  /**
   * Gets and sets the content length header value.
   */
  int get contentLength => _contentLength;

  void set contentLength(int contentLength) {
    _checkMutable();
    if (protocolVersion == "1.0" &&
        persistentConnection &&
        contentLength == -1) {
      throw new Exception(
          "Trying to clear ContentLength on HTTP 1.0 headers with "
          "'Connection: Keep-Alive' set");
    }
    if (_contentLength == contentLength) return;
    _contentLength = contentLength;
    if (_contentLength >= 0) {
      if (chunkedTransferEncoding) chunkedTransferEncoding = false;
      _set(HttpClientHeaders.CONTENT_LENGTH, contentLength.toString());
    } else {
      removeAll(HttpClientHeaders.CONTENT_LENGTH);
      if (protocolVersion == "1.1") {
        chunkedTransferEncoding = true;
      }
    }
  }

  /**
   * Gets and sets the chunked transfer encoding header value.
   */
  bool get chunkedTransferEncoding => _chunkedTransferEncoding;

  void set chunkedTransferEncoding(bool chunkedTransferEncoding) {
    _checkMutable();
    if (chunkedTransferEncoding && protocolVersion == "1.0") {
      throw new Exception(
          "Trying to set 'Transfer-Encoding: Chunked' on HTTP 1.0 headers");
    }
    if (chunkedTransferEncoding == _chunkedTransferEncoding) return;
    if (chunkedTransferEncoding) {
      List<String> values = _headers[HttpClientHeaders.TRANSFER_ENCODING];
      if ((values == null || values.last != "chunked")) {
        // Headers does not specify chunked encoding - add it if set.
        _addValue(HttpClientHeaders.TRANSFER_ENCODING, "chunked");
      }
      contentLength = -1;
    } else {
      // Headers does specify chunked encoding - remove it if not set.
      remove(HttpClientHeaders.TRANSFER_ENCODING, "chunked");
    }
    _chunkedTransferEncoding = chunkedTransferEncoding;
  }

  /**
   * Gets and sets the host part of the 'host' header for the
   * connection.
   */
  String get host => _host;

  void set host(String host) {
    _checkMutable();
    _host = host;
    _updateHostHeader();
  }

  /**
   * Gets and sets the port part of the 'host' header for the
   * connection.
   */
  int get port => _port;

  void set port(int port) {
    _checkMutable();
    _port = port;
    _updateHostHeader();
  }

  /**
   * Gets and sets the "if-modified-since" date. The value of this property will
   * reflect the "if-modified-since" header.
   */
  DateTime get ifModifiedSince {
    List<String> values = _headers[HttpClientHeaders.IF_MODIFIED_SINCE];
    if (values != null) {
      try {
        return HttpDate.parse(values[0]);
      } on Exception catch (_) {
        return null;
      }
    }
    return null;
  }

  void set ifModifiedSince(DateTime ifModifiedSince) {
    _checkMutable();
    // Format "ifModifiedSince" header with date in Greenwich Mean Time (GMT).
    String formatted = HttpDate.format(ifModifiedSince.toUtc());
    _set(HttpClientHeaders.IF_MODIFIED_SINCE, formatted);
  }

  /**
   * Gets and sets the date. The value of this property will
   * reflect the 'date' header.
   */
  DateTime get date {
    List<String> values = _headers[HttpClientHeaders.DATE];
    if (values != null) {
      try {
        return HttpDate.parse(values[0]);
      } on Exception catch (_) {
        return null;
      }
    }
    return null;
  }

  void set date(DateTime date) {
    _checkMutable();
    // Format "DateTime" header with date in Greenwich Mean Time (GMT).
    String formatted = HttpDate.format(date.toUtc());
    _set("date", formatted);
  }

  /**
   * Gets and sets the expiry date. The value of this property will
   * reflect the 'expires' header.
   */
  DateTime get expires {
    List<String> values = _headers[HttpClientHeaders.EXPIRES];
    if (values != null) {
      try {
        return HttpDate.parse(values[0]);
      } on Exception catch (_) {
        return null;
      }
    }
    return null;
  }

  void set expires(DateTime expires) {
    _checkMutable();
    // Format "Expires" header with date in Greenwich Mean Time (GMT).
    String formatted = HttpDate.format(expires.toUtc());
    _set(HttpClientHeaders.EXPIRES, formatted);
  }

  /**
   * Gets and sets the content type. Note that the content type in the
   * header will only be updated if this field is set
   * directly. Mutating the returned current value will have no
   * effect.
   */
  ContentType get contentType {
    var values = _headers["content-type"];
    if (values != null) {
      return ContentType.parse(values[0]);
    } else {
      return null;
    }
  }

  void set contentType(ContentType contentType) {
    _checkMutable();
    _set(HttpClientHeaders.CONTENT_TYPE, contentType.toString());
  }

  /**
   * Remove all headers. Some headers have system supplied values and
   * for these the system supplied values will still be added to the
   * collection of values for the header.
   */
  void clear() {
    _checkMutable();
    _headers.clear();
    _contentLength = -1;
    _persistentConnection = true;
    _chunkedTransferEncoding = false;
    _host = null;
    _port = null;
  }

  // [name] must be a lower-case version of the name.
  void _add(String name, value) {
    assert(name == _validateField(name));
    // Use the length as index on what method to call. This is notable
    // faster than computing hash and looking up in a hash-map.
    switch (name.length) {
      case 4:
        if (HttpClientHeaders.DATE == name) {
          _addDate(name, value);
          return;
        }
        if (HttpClientHeaders.HOST == name) {
          _addHost(name, value);
          return;
        }
        break;
      case 7:
        if (HttpClientHeaders.EXPIRES == name) {
          _addExpires(name, value);
          return;
        }
        break;
      case 10:
        if (HttpClientHeaders.CONNECTION == name) {
          _addConnection(name, value);
          return;
        }
        break;
      case 12:
        if (HttpClientHeaders.CONTENT_TYPE == name) {
          _addContentType(name, value);
          return;
        }
        break;
      case 14:
        if (HttpClientHeaders.CONTENT_LENGTH == name) {
          _addContentLength(name, value);
          return;
        }
        break;
      case 17:
        if (HttpClientHeaders.TRANSFER_ENCODING == name) {
          _addTransferEncoding(name, value);
          return;
        }
        if (HttpClientHeaders.IF_MODIFIED_SINCE == name) {
          _addIfModifiedSince(name, value);
          return;
        }
    }
    _addValue(name, value);
  }

  void _addContentLength(String name, value) {
    if (value is int) {
      contentLength = value;
    } else if (value is String) {
      contentLength = int.parse(value);
    } else {
      throw new Exception("Unexpected type for header named $name");
    }
  }

  void _addTransferEncoding(String name, value) {
    if (value == "chunked") {
      chunkedTransferEncoding = true;
    } else {
      _addValue(HttpClientHeaders.TRANSFER_ENCODING, value);
    }
  }

  void _addDate(String name, value) {
    if (value is DateTime) {
      date = value;
    } else if (value is String) {
      _set(HttpClientHeaders.DATE, value);
    } else {
      throw new Exception("Unexpected type for header named $name");
    }
  }

  void _addExpires(String name, value) {
    if (value is DateTime) {
      expires = value;
    } else if (value is String) {
      _set(HttpClientHeaders.EXPIRES, value);
    } else {
      throw new Exception("Unexpected type for header named $name");
    }
  }

  void _addIfModifiedSince(String name, value) {
    if (value is DateTime) {
      ifModifiedSince = value;
    } else if (value is String) {
      _set(HttpClientHeaders.IF_MODIFIED_SINCE, value);
    } else {
      throw new Exception("Unexpected type for header named $name");
    }
  }

  void _addHost(String name, value) {
    if (value is String) {
      int pos = value.indexOf(":");
      if (pos == -1) {
        _host = value;
        _port = Client.DEFAULT_HTTP_PORT;
      } else {
        if (pos > 0) {
          _host = value.substring(0, pos);
        } else {
          _host = null;
        }
        if (pos + 1 == value.length) {
          _port = Client.DEFAULT_HTTP_PORT;
        } else {
          try {
            _port = int.parse(value.substring(pos + 1));
          } on FormatException catch (_) {
            _port = null;
          }
        }
      }
      _set(HttpClientHeaders.HOST, value);
    } else {
      throw new Exception("Unexpected type for header named $name");
    }
  }

  void _addConnection(String name, value) {
    var lowerCaseValue = value.toLowerCase();
    if (lowerCaseValue == 'close') {
      _persistentConnection = false;
    } else if (lowerCaseValue == 'keep-alive') {
      _persistentConnection = true;
    }
    _addValue(name, value);
  }

  void _addContentType(String name, value) {
    _set(HttpClientHeaders.CONTENT_TYPE, value);
  }

  void _addValue(String name, Object value) {
    List<String> values = _headers[name];
    if (values == null) {
      values = new List<String>();
      _headers[name] = values;
    }
    if (value is DateTime) {
      values.add(HttpDate.format(value));
    } else if (value is String) {
      values.add(value);
    } else {
      values.add(_validateValue(value.toString()));
    }
  }

  void _set(String name, String value) {
    assert(name == _validateField(name));
    List<String> values = new List<String>();
    _headers[name] = values;
    values.add(value);
  }

  _checkMutable() {
    if (!_mutable) throw new Exception("HTTP headers are not mutable");
  }

  _updateHostHeader() {
    bool defaultPort = _port == null || _port == _defaultPortForScheme;
    _set("host", defaultPort ? host : "$host:$_port");
  }

  _foldHeader(String name) {
    if (name == HttpClientHeaders.SET_COOKIE ||
        (_noFoldingHeaders != null && _noFoldingHeaders.indexOf(name) != -1)) {
      return false;
    }
    return true;
  }

  void finalize() {
    _mutable = false;
  }

  int _write(Uint8List buffer, int offset) {
    void write(List<int> bytes) {
      int len = bytes.length;
      for (int i = 0; i < len; i++) {
        buffer[offset + i] = bytes[i];
      }
      offset += len;
    }

    // Format headers.
    for (String name in _headers.keys) {
      List<String> values = _headers[name];
      bool fold = _foldHeader(name);
      var nameData = name.codeUnits;
      write(nameData);
      buffer[offset++] = _CharCode.COLON;
      buffer[offset++] = _CharCode.SP;
      for (int i = 0; i < values.length; i++) {
        if (i > 0) {
          if (fold) {
            buffer[offset++] = _CharCode.COMMA;
            buffer[offset++] = _CharCode.SP;
          } else {
            buffer[offset++] = _CharCode.CR;
            buffer[offset++] = _CharCode.LF;
            write(nameData);
            buffer[offset++] = _CharCode.COLON;
            buffer[offset++] = _CharCode.SP;
          }
        }
        write(values[i].codeUnits);
      }
      buffer[offset++] = _CharCode.CR;
      buffer[offset++] = _CharCode.LF;
    }
    return offset;
  }

  String toString() {
    StringBuffer sb = new StringBuffer();
    _headers.forEach((String name, List<String> values) {
      sb..write(name)..write(": ");
      bool fold = _foldHeader(name);
      for (int i = 0; i < values.length; i++) {
        if (i > 0) {
          if (fold) {
            sb.write(", ");
          } else {
            sb..write("\n")..write(name)..write(": ");
          }
        }
        sb.write(values[i]);
      }
      sb.write("\n");
    });
    return sb.toString();
  }

  List<Cookie> parseCookies() {
    // Parse a Cookie header value according to the rules in RFC 6265.
    var cookies = new List<Cookie>();
    void parseCookieString(String s) {
      int index = 0;

      bool done() => index == -1 || index == s.length;

      void skipWS() {
        while (!done()) {
          if (s[index] != " " && s[index] != "\t") return;
          index++;
        }
      }

      String parseName() {
        int start = index;
        while (!done()) {
          if (s[index] == " " || s[index] == "\t" || s[index] == "=") break;
          index++;
        }
        return s.substring(start, index);
      }

      String parseValue() {
        int start = index;
        while (!done()) {
          if (s[index] == " " || s[index] == "\t" || s[index] == ";") break;
          index++;
        }
        return s.substring(start, index);
      }

      bool expect(String expected) {
        if (done()) return false;
        if (s[index] != expected) return false;
        index++;
        return true;
      }

      while (!done()) {
        skipWS();
        if (done()) return;
        String name = parseName();
        skipWS();
        if (!expect("=")) {
          index = s.indexOf(';', index);
          continue;
        }
        skipWS();
        String value = parseValue();
        try {
          cookies.add(new Cookie(name, value));
        } catch (_) {
          // Skip it, invalid cookie data.
        }
        skipWS();
        if (done()) return;
        if (!expect(";")) {
          index = s.indexOf(';', index);
          continue;
        }
      }
    }

    List<String> values = _headers[HttpClientHeaders.COOKIE];
    if (values != null) {
      values.forEach((headerValue) => parseCookieString(headerValue));
    }
    return cookies;
  }

  static String _validateField(String field) {
    for (var i = 0; i < field.length; i++) {
      if (!_isTokenChar(field.codeUnitAt(i))) {
        throw new FormatException(
            "Invalid HTTP header field name: ${JSON.encode(field)}");
      }
    }
    return field.toLowerCase();
  }

  static _validateValue(value) {
    if (value is! String) return value;
    for (var i = 0; i < value.length; i++) {
      if (!_isValueChar(value.codeUnitAt(i))) {
        throw new FormatException(
            "Invalid HTTP header field value: ${JSON.encode(value)}");
      }
    }
    return value;
  }

  static bool _isTokenChar(int byte) {
    return byte > 31 && byte < 128 && !_Const.SEPARATOR_MAP[byte];
  }

  static bool _isValueChar(int byte) {
    return (byte > 31 && byte < 128) ||
        (byte == _CharCode.SP) ||
        (byte == _CharCode.HT);
  }

  void addAllInHeader(HttpClientHeaders headers) {
    if (headers != null) {
      headers._headers.forEach((name, value) => _headers[name] = value);
      _contentLength = headers._contentLength;
      _persistentConnection = headers._persistentConnection;
      _chunkedTransferEncoding = headers._chunkedTransferEncoding;
      _host = headers._host;
      _port = headers._port;
    }
    if (protocolVersion == "1.0") {
      _persistentConnection = false;
      _chunkedTransferEncoding = false;
    }
  }

  void addAllInMap(Map<String, String> map) {
    map.forEach((String key, String value) {
      add(key, value);
    });
  }

  void setAllInMap(Map<String, String> map) {
    map.forEach((String key, String value) {
      set(key, value);
    });
  }

  Map<String, String> getFlattenedMap() {
    Map<String, String> ret = {};

    forEach((String key, List<String> values) {
      if (values == null || values.length == 0) {
        return;
      }

      ret[key] = values.first;
    });

    return ret;
  }
}

class _HeaderValue implements HeaderValue {
  String _value;
  Map<String, String> _parameters;
  Map<String, String> _unmodifiableParameters;

  _HeaderValue([String this._value = "", Map<String, String> parameters]) {
    if (parameters != null) {
      _parameters = new HashMap<String, String>.from(parameters);
    }
  }

  static _HeaderValue parse(String value,
      {parameterSeparator: ";",
      valueSeparator: null,
      preserveBackslash: false}) {
    // Parse the string.
    var result = new _HeaderValue();
    result._parse(value, parameterSeparator, valueSeparator, preserveBackslash);
    return result;
  }

  String get value => _value;

  void _ensureParameters() {
    if (_parameters == null) {
      _parameters = new HashMap<String, String>();
    }
  }

  Map<String, String> get parameters {
    _ensureParameters();
    if (_unmodifiableParameters == null) {
      _unmodifiableParameters = new UnmodifiableMapView(_parameters);
    }
    return _unmodifiableParameters;
  }

  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write(_value);
    if (parameters != null && parameters.length > 0) {
      _parameters.forEach((String name, String value) {
        sb..write("; ")..write(name)..write("=")..write(value);
      });
    }
    return sb.toString();
  }

  void _parse(String s, String parameterSeparator, String valueSeparator,
      bool preserveBackslash) {
    int index = 0;

    bool done() => index == s.length;

    void skipWS() {
      while (!done()) {
        if (s[index] != " " && s[index] != "\t") return;
        index++;
      }
    }

    String parseValue() {
      int start = index;
      while (!done()) {
        if (s[index] == " " ||
            s[index] == "\t" ||
            s[index] == valueSeparator ||
            s[index] == parameterSeparator) break;
        index++;
      }
      return s.substring(start, index);
    }

    void expect(String expected) {
      if (done() || s[index] != expected) {
        throw new Exception("Failed to parse header value");
      }
      index++;
    }

    void maybeExpect(String expected) {
      if (s[index] == expected) index++;
    }

    void parseParameters() {
      var parameters = new HashMap<String, String>();
      _parameters = new UnmodifiableMapView(parameters);

      String parseParameterName() {
        int start = index;
        while (!done()) {
          if (s[index] == " " ||
              s[index] == "\t" ||
              s[index] == "=" ||
              s[index] == parameterSeparator ||
              s[index] == valueSeparator) break;
          index++;
        }
        return s.substring(start, index).toLowerCase();
      }

      String parseParameterValue() {
        if (!done() && s[index] == "\"") {
          // Parse quoted value.
          StringBuffer sb = new StringBuffer();
          index++;
          while (!done()) {
            if (s[index] == "\\") {
              if (index + 1 == s.length) {
                throw new Exception("Failed to parse header value");
              }
              if (preserveBackslash && s[index + 1] != "\"") {
                sb.write(s[index]);
              }
              index++;
            } else if (s[index] == "\"") {
              index++;
              break;
            }
            sb.write(s[index]);
            index++;
          }
          return sb.toString();
        } else {
          // Parse non-quoted value.
          var val = parseValue();
          return val == "" ? null : val;
        }
      }

      while (!done()) {
        skipWS();
        if (done()) return;
        String name = parseParameterName();
        skipWS();
        if (done()) {
          parameters[name] = null;
          return;
        }
        maybeExpect("=");
        skipWS();
        if (done()) {
          parameters[name] = null;
          return;
        }
        String value = parseParameterValue();
        if (name == 'charset' && this is _ContentType && value != null) {
          // Charset parameter of ContentTypes are always lower-case.
          value = value.toLowerCase();
        }
        parameters[name] = value;
        skipWS();
        if (done()) return;
        // TODO: Implement support for multi-valued parameters.
        if (s[index] == valueSeparator) return;
        expect(parameterSeparator);
      }
    }

    skipWS();
    _value = parseValue();
    skipWS();
    if (done()) return;
    maybeExpect(parameterSeparator);
    parseParameters();
  }
}

// Global constants.
class _Const {
  // Bytes for "HTTP".
  static const HTTP = const [72, 84, 84, 80];
  // Bytes for "HTTP/1.".
  static const HTTP1DOT = const [72, 84, 84, 80, 47, 49, 46];
  // Bytes for "HTTP/1.0".
  static const HTTP10 = const [72, 84, 84, 80, 47, 49, 46, 48];
  // Bytes for "HTTP/1.1".
  static const HTTP11 = const [72, 84, 84, 80, 47, 49, 46, 49];

  static const bool T = true;
  static const bool F = false;
  // Loopup-map for the following characters: '()<>@,;:\\"/[]?={} \t'.
  static const SEPARATOR_MAP = const [
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    T,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    T,
    F,
    T,
    F,
    F,
    F,
    F,
    F,
    T,
    T,
    F,
    F,
    T,
    F,
    F,
    T,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    T,
    T,
    T,
    T,
    T,
    T,
    T,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    T,
    T,
    T,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    T,
    F,
    T,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F,
    F
  ];
}
