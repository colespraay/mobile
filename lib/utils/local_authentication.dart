import 'package:local_auth/local_auth.dart';

class Authentication {
  static Future<bool> authenticateWithBiometrics() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    print("isBiometricSupported=$isBiometricSupported , canCheckBiometrics=$canCheckBiometrics");

    bool isAuthenticated = false;

    if (isBiometricSupported && canCheckBiometrics) {
      isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Please complete the biometrics to proceed.',
          options: AuthenticationOptions(biometricOnly: true, useErrorDialogs: true)
      );
    }

    return isAuthenticated;
  }
}