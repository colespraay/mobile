// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'locks.env')
abstract class Env {
  @EnviedField(varName: 'apiKey',obfuscate: true)
  static final String apiKey = _Env.apiKey;
}