
class RegExpPatterns {

  static const Pattern EMAIL_PATTERN =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))'
      r'@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
      r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
}