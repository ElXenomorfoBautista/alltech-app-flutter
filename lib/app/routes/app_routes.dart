part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const AUTH_LOGIN = _Paths.AUTH_LOGIN;
  static const USERS_PROFILE = _Paths.USERS_PROFILE;
  static const USERS = _Paths.USERS;
  static const WORK_ORDER = _Paths.WORK_ORDER;
  static const WORK_ORDER_DETAIL = _Paths.WORK_ORDER + _Paths.WORK_ORDER_DETAIL;
  static const WORK_ORDER_CREATE = _Paths.WORK_ORDER + _Paths.WORK_ORDER_CREATE;
  static const SERVICE_SHEET = _Paths.SERVICE_SHEET;
  static const SERVICE_SHEET_DETAIL =
      _Paths.SERVICE_SHEET + _Paths.SERVICE_SHEET_DETAIL;
  static const SERVICE_SHEET_CREATE =
      _Paths.SERVICE_SHEET + _Paths.SERVICE_SHEET_CREATE;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const AUTH_LOGIN = '/auth/login';
  static const USERS_PROFILE = '/profile';
  static const USERS = '/users';
  static const WORK_ORDER = '/work-order';
  static const WORK_ORDER_DETAIL = '/detail';
  static const WORK_ORDER_CREATE = '/create';
  static const SERVICE_SHEET = '/service-sheet';
  static const SERVICE_SHEET_DETAIL = '/detail';
  static const SERVICE_SHEET_CREATE = '/create';
  static const SETTINGS = '/settings';
}
