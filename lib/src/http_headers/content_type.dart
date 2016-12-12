part of http.http_headers;

/**
 * Representation of a content type. An instance of [ContentType] is
 * immutable.
 */
abstract class ContentType implements HeaderValue {
  /**
   * Content type for plain text using UTF-8 encoding.
   *
   *     text/plain; charset=utf-8
   */
  static final TEXT = new ContentType("text", "plain", charset: "utf-8");

  /**
   *  Content type for HTML using UTF-8 encoding.
   *
   *     text/html; charset=utf-8
   */
  static final HTML = new ContentType("text", "html", charset: "utf-8");

  /**
   *  Content type for JSON using UTF-8 encoding.
   *
   *     application/json; charset=utf-8
   */
  static final JSON = new ContentType("application", "json", charset: "utf-8");

  /**
   *  Content type for binary data.
   *
   *     application/octet-stream
   */
  static final BINARY = new ContentType("application", "octet-stream");

  /**
   * Creates a new content type object setting the primary type and
   * sub type. The charset and additional parameters can also be set
   * using [charset] and [parameters]. If charset is passed and
   * [parameters] contains charset as well the passed [charset] will
   * override the value in parameters. Keys passed in parameters will be
   * converted to lower case. The `charset` entry, whether passed as `charset`
   * or in `parameters`, will have its value converted to lower-case.
   */
  factory ContentType(String primaryType, String subType,
      {String charset, Map<String, String> parameters}) {
    return new _ContentType(primaryType, subType, charset, parameters);
  }

  /**
   * Creates a new content type object from parsing a Content-Type
   * header value. As primary type, sub type and parameter names and
   * values are not case sensitive all these values will be converted
   * to lower case. Parsing this string
   *
   *     text/html; charset=utf-8
   *
   * will create a content type object with primary type [:text:], sub
   * type [:html:] and parameter [:charset:] with value [:utf-8:].
   */
  static ContentType parse(String value) {
    return _ContentType.parse(value);
  }

  /**
   * Gets the mime-type, without any parameters.
   */
  String get mimeType;

  /**
   * Gets the primary type.
   */
  String get primaryType;

  /**
   * Gets the sub type.
   */
  String get subType;

  /**
   * Gets the character set.
   */
  String get charset;
}

class _ContentType extends _HeaderValue implements ContentType {
  String _primaryType = "";
  String _subType = "";

  _ContentType(String primaryType, String subType, String charset,
      Map<String, String> parameters)
      : _primaryType = primaryType,
        _subType = subType,
        super("") {
    if (_primaryType == null) _primaryType = "";
    if (_subType == null) _subType = "";
    _value = "$_primaryType/$_subType";
    if (parameters != null) {
      _ensureParameters();
      parameters.forEach((String key, String value) {
        String lowerCaseKey = key.toLowerCase();
        if (lowerCaseKey == "charset") {
          value = value.toLowerCase();
        }
        this._parameters[lowerCaseKey] = value;
      });
    }
    if (charset != null) {
      _ensureParameters();
      this._parameters["charset"] = charset.toLowerCase();
    }
  }

  _ContentType._();

  static _ContentType parse(String value) {
    var result = new _ContentType._();
    result._parse(value, ";", null, false);
    int index = result._value.indexOf("/");
    if (index == -1 || index == (result._value.length - 1)) {
      result._primaryType = result._value.trim().toLowerCase();
      result._subType = "";
    } else {
      result._primaryType =
          result._value.substring(0, index).trim().toLowerCase();
      result._subType = result._value.substring(index + 1).trim().toLowerCase();
    }
    return result;
  }

  String get mimeType => '$primaryType/$subType';

  String get primaryType => _primaryType;

  String get subType => _subType;

  String get charset => parameters["charset"];
}
