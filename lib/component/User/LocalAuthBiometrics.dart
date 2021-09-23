import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    /// check if user device supports biometric
    final isAvailable = await  hasBiometrics();
    if (!isAvailable) return false;
    
    try {
      return await _auth.authenticateWithBiometrics(
          localizedReason: 'Authenticate Using Fingerprint',
          useErrorDialogs: true,
          stickyAuth: true
      );
    } on PlatformException catch (error) {
      return false;
    }
  }

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (error) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (error) {
      return <BiometricType>[];
    }
  }

}