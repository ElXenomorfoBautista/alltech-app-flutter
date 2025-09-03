import 'package:get/get.dart';

import '../middleware/auth_middleware.dart';
import '../modules/auth/login/bindings/auth_login_binding.dart';
import '../modules/auth/login/views/auth_login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/serviceSheet/bindings/service_sheet_binding.dart';
import '../modules/serviceSheet/create/bindings/service_sheet_create_binding.dart';
import '../modules/serviceSheet/create/views/service_sheet_create_view.dart';
import '../modules/serviceSheet/detail/bindings/service_sheet_detail_binding.dart';
import '../modules/serviceSheet/detail/views/service_sheet_detail_view.dart';
import '../modules/serviceSheet/views/service_sheet_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/users/bindings/users_binding.dart';
import '../modules/users/profile/bindings/users_profile_binding.dart';
import '../modules/users/profile/views/users_profile_view.dart';
import '../modules/users/views/users_view.dart';
import '../modules/workOrder/bindings/work_order_binding.dart';
import '../modules/workOrder/create/bindings/work_order_create_binding.dart';
import '../modules/workOrder/create/views/work_order_create_view.dart';
import '../modules/workOrder/detail/bindings/work_order_detail_binding.dart';
import '../modules/workOrder/detail/views/work_order_detail_view.dart';
import '../modules/workOrder/views/work_order_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH_LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      middlewares: [AuthMiddleware()],
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH_LOGIN,
      page: () => const AuthLoginView(),
      binding: AuthLoginBinding(),
    ),
    GetPage(
      name: _Paths.USERS_PROFILE,
      page: () => const UsersProfileView(),
      binding: UsersProfileBinding(),
    ),
    GetPage(
      name: _Paths.USERS,
      page: () => const UsersView(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: _Paths.WORK_ORDER,
      page: () => const WorkOrderView(),
      binding: WorkOrderBinding(),
      children: [
        GetPage(
          name: _Paths.WORK_ORDER_DETAIL,
          page: () => const WorkOrderDetailView(),
          binding: WorkOrderDetailBinding(),
        ),
        GetPage(
          name: _Paths.WORK_ORDER_CREATE,
          page: () => const WorkOrderCreateView(),
          binding: WorkOrderCreateBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SERVICE_SHEET,
      page: () => ServiceSheetView(),
      binding: ServiceSheetBinding(),
      children: [
        GetPage(
          name: _Paths.SERVICE_SHEET_DETAIL,
          page: () => ServiceSheetDetailView(),
          binding: ServiceSheetDetailBinding(),
        ),
        GetPage(
          name: _Paths.SERVICE_SHEET_CREATE,
          page: () => ServiceSheetCreateView(),
          binding: ServiceSheetCreateBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
