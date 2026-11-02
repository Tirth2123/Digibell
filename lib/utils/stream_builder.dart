import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StreamUtil {
  static BehaviorSubject<String> countrycode = BehaviorSubject<String>.seeded('91');
  static BehaviorSubject<int> bottomNavigationIndex = BehaviorSubject<int>.seeded(0);
  static BehaviorSubject<String> verificationIDSubject = BehaviorSubject<String>.seeded('');
  static BehaviorSubject<IO.Socket> socket = BehaviorSubject<IO.Socket>();
  static BehaviorSubject<String> userType = BehaviorSubject<String>.seeded('');
  static BehaviorSubject<String> userId = BehaviorSubject<String>.seeded('');
  static BehaviorSubject<String> userPhoto = BehaviorSubject<String>.seeded('');
  static BehaviorSubject<bool> isAppInBackground = BehaviorSubject<bool>.seeded(false);
}
