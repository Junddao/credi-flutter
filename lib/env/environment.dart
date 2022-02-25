import '../main.dart';

enum BuildType {
  dev,
  stage,
  prod,
}

class Environment {
  static Environment? instance;

  final BuildType _buildType;

  static BuildType get buildType => instance!._buildType;

  const Environment.internal(this._buildType);

  factory Environment.newInstance(BuildType buildType) {
    assert(buildType != null);

    if (instance == null) {
      instance = Environment.internal(buildType);
    }
    return instance!;
  }

  static bool get isDebuggable => instance!._buildType == BuildType.dev;

  void run() async {
    runServer();
  }
}
