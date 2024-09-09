class CustomTexts {
  //1
  static const String _stText = 'OM';
  //2
  static const String _ndText = 'Video Downloader';
  //3
  static const String _rdText = 'Very Fast, secure and Private';
  //4
  static const String _rthText = 'Supports';
  //5
  static const String _ethText =
      'OM Video Downloader enables you from download videos from multiple source.';
  //6
  static const String _appBarTittle = 'OM Video Downloader';
  // //7
  // String _nthText = 'OM';
  // //8
  // String _tthText = 'OM';

  CustomTexts({
    String? stText,
    String? ndText,
    String? rdText,
    String? rthText,
    String? ethText,
    String? appBarTittle,
  }) {
    stText = _stText;
    ndText = _ndText;
    rdText = _rdText;
    rthText = _rthText;
    ethText = _ethText;
    appBarTittle = _appBarTittle;
  }

  static String get appBarTittle => _appBarTittle;

  static String get ethText => _ethText;

  static String get rthText => _rthText;

  static String get rdText => _rdText;

  static String get ndText => _ndText;

  static String get stText => _stText;
}
