// ignore_for_file: constant_identifier_names

abstract class Connection {
  Connection._(); // to disable creating object of this data.

  static const BASE = 'www.felsport.com';
  static const BASE_URL = 'https://$BASE/';
  static const API_URL = '${BASE_URL}api/';
}

abstract class UniVars {
  UniVars._();

  static const GROUP = 'group';

  static List<String> get values => [GROUP];
}
