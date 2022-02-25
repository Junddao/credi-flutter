import 'package:crediApp/global/models/system/system_app_version.dart';
import 'package:crediApp/global/models/system/system_config.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/service/api_service.dart';

class SystemChangeNotifier extends ParentProvider {
  SystemConfigData? systemConfigData;
  Future<String?> getAppVersion() async {
    SystemAppVersionResponseData? systemAppVersionResponseData =
        SystemAppVersionResponseData();

    try {
      setStateBusy();

      var api = ApiService();
      var response = await api.get('/system/version');
      SystemAppVersionResponse systemAppVersionResponse =
          SystemAppVersionResponse.fromMap(response);
      systemAppVersionResponseData = systemAppVersionResponse.data;

      setStateIdle();
    } catch (error) {
      setStateError();
    }

    return systemAppVersionResponseData!.clientMinimumAppVersion;
  }

  Future<void> getSystemConfig() async {
    try {
      setStateBusy();
      var api = ApiService();

      var response = await api.get('/system/config');
      SystemConfig? systemConfig = SystemConfig.fromMap(response);
      systemConfigData = systemConfig.data;

      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }
}
