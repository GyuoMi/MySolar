abstract class IDevicePersistence {
  Future createDevice(int id, String name, bool usage, double wattage,
      double voltage, bool normalSetting, bool loadSheddingSetting);
  Future updateDeviceName(int id, String name);
  Future deleteDevice(int id, int singleDeviceId);
  Future getUserDevices(int id);
  Future getDevice(int id, int singleDeviceId);
  Future updateDeviceLoadSheddingSetting(int id, bool loadSheddingSetting);
  Future updateDeviceNormalSetting(int id, bool normalSetting);
  Future updateDeviceVoltage(int id, double voltage);
  Future updateDeviceWattage(int id, double wattage);
  Future updateDeviceUsage(int id, bool usage);
}
