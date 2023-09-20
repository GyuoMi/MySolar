abstract class IDevicePersistence {
  covariant String? deviceTable,
      deviceId,
      deviceName,
      deviceUsage,
      deviceWattage,
      deviceVoltage,
      deviceNormalSetting,
      deviceLoadSheddingSetting;

  Future createDevice(int userId, String name, bool usage, double wattage,
      double voltage, bool normalSetting, bool loadSheddingSetting);
  Future updateDeviceName(int deviceId, String name);
  Future deleteDevice(int deviceId);
  Future getUserDeviceIds(int userId);
  Future getDevice(int deviceId);
  Future updateDeviceLoadSheddingSetting(
      int deviceId, bool loadSheddingSetting);
  Future updateDeviceNormalSetting(int deviceId, bool normalSetting);
  Future updateDeviceVoltage(int deviceId, double voltage);
  Future updateDeviceWattage(int deviceId, double wattage);
  Future updateDeviceUsage(int deviceId, bool usage);
}
