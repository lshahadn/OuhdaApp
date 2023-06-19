
import 'package:hexcolor/hexcolor.dart';

class AppConstants {
  static const String APP_NAME = 'Bus Tracker';
  static const double APP_VERSION = 1.0;


  /// Shared Key
  static const String THEME = 'theme';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_NUMBER = 'user_number';
  static const String USER_ID = 'user_id';
  static const String USER_EMAIL = 'user_email';
  static const String USER_ACCOUNT_TYPE = 'user_account_type';
  
  static const String USER_TYPE = 'user_type';
  static const String USER_NAME = 'user_NAME';
  static const String PHONE = 'user_PHONE';
  
  

  static const String USER_COUNTRY_CODE = 'user_country_code';
  static const String NOTIFICATION = 'notification';
  static const String SEARCH_HISTORY = 'search_history';
  static const String INTRO = 'intro';
  static const String NOTIFICATION_COUNT = 'notification_count';
  static const String TOPIC = 'all_zone_customer';
  static const String ZONE_ID = 'zoneId';
  static const String LOCALIZATION_KEY = 'X-localization';
  static const String LATITUDE = 'latitude';
  static const String LONGITUDE = 'longitude';

  /// Delivery Tips
  static List<int> tips = [0, 5, 10, 15, 20, 30, 50];

  /// Child Status
  static const String IN_BUS = 'in_bus';
  static const String AT_SCHOOL = 'at_school';
  static const String AT_HOME = 'at_home';

  /// Delivery Type
  static const String DELIVERY = 'delivery';
  static const String TAKE_AWAY = 'take_away';

  /// Preference Day
  static List<String> authTypes = ['Parent', 'Driver', 'Admin'];

  /// Colors
  static var mainColor = HexColor("#ffc828");

}
