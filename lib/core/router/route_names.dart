class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String vehicles = '/vehicles';
  static const String addVehicle = '/vehicles/add';
  static const String editVehicle = '/vehicles/edit/:id';

  static String editVehiclePath(int id) => '/vehicles/edit/$id';
}
