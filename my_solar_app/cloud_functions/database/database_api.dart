import 'database_functions_interface.dart';
import 'supabase_functions.dart';

class DatabaseApi {
  //column names
  final IDatabaseFunctions database = SupabaseFunctions();

  final userTable = 'user_tbl',
      userId = 'user_id',
      userName = 'user_name',
      userPassword = 'user_password',
      userAddress = 'user_address',
      systemId = 'system_id';

  final deviceTable = 'device_tbl',
      deviceId = 'device_id',
      deviceName = 'device_name',
      deviceUsage = 'device_usage',
      deviceWattage = 'device_wattage',
      deviceVoltage = 'device_voltage',
      deviceNormalSetting = 'device_normal',
      deviceLoadSheddingSetting = 'device_loadshedding';

  final manualTable = 'manual_tbl',
      manualId = 'manual_id',
      manualName = 'manual_name',
      manualCapacity = 'manual_capacity',
      manualMaxProduction = 'manual_max_production',
      manualCount = 'manual_count',
      manualDailyUsage = 'manual_daily_usage';

  final recordsTable = 'records_tbl',
      recordsTime = 'records_time',
      recordsMinutesUsed = 'records_minutes';

  final systemsTable = 'systems_tbl';

  final setupTable = 'setup_tbl';

  //creating functions
  Future createUser(
      String name, int systemType, String password, String address) async {
    final userData = {
      userName: name,
      systemId: systemType,
      userPassword: password,
      userAddress: address
    };
    return database.createRecord(userTable, userData);
  }

  Future createDevice(int id, String name, bool usage, double wattage,
      double voltage, bool normalSetting, bool loadSheddingSetting) async {
    final deviceData = {
      deviceName: name,
      deviceUsage: usage,
      deviceWattage: wattage,
      deviceVoltage: voltage,
      deviceNormalSetting: normalSetting,
      deviceLoadSheddingSetting: loadSheddingSetting
    };
    final returnedDeviceData =
        await database.createRecord(deviceTable, deviceData);

    final setupData = {userId: id, deviceId: returnedDeviceData[0][deviceId]};

    database.createRecord(setupTable, setupData);
    return returnedDeviceData;
  }

  Future createManualSystem(String name, double capacity, double maxProduction,
      int count, double dailyUsage) async {
    final manualData = {
      manualName: name,
      manualCapacity: capacity,
      manualMaxProduction: maxProduction,
      manualCount: count,
      manualDailyUsage: dailyUsage
    };
    return database.createRecord(manualTable, manualData);
  }

  Future createRecord(int id, String time, double minutes) async {
    final recordData = {
      deviceId: id,
      recordsTime: time,
      recordsMinutesUsed: minutes
    };
    return database.createRecord(recordsTable, recordData);
  }

  //updating functions
  Future updateUserName(int id, String name) async {
    return database.updateField(userTable, {userName: name}, {userId: id});
  }

  Future updateUserPassword(int id, String password) async {
    return database
        .updateField(userTable, {userPassword: password}, {userId: id});
  }

  Future updateUserAddress(int id, String address) async {
    return database
        .updateField(userTable, {userAddress: address}, {userId: id});
  }

  Future updateDeviceName(int id, String name) async {
    return database
        .updateField(deviceTable, {deviceName: name}, {deviceId: id});
  }

  Future updateDeviceUsage(int id, bool usage) async {
    return database
        .updateField(deviceTable, {deviceUsage: usage}, {deviceId: id});
  }

  Future updateDeviceWattage(int id, double wattage) async {
    return database
        .updateField(deviceTable, {deviceWattage: wattage}, {deviceId: id});
  }

  Future updateDeviceVoltage(int id, double voltage) async {
    return database
        .updateField(deviceTable, {deviceVoltage: voltage}, {deviceId: id});
  }

  Future updateDeviceNormalSetting(int id, bool normalSetting) async {
    return database.updateField(
        deviceTable, {deviceNormalSetting: normalSetting}, {deviceId: id});
  }

  Future updateDeviceLoadSheddingSetting(
      int id, bool loadSheddingSetting) async {
    return database.updateField(deviceTable,
        {deviceLoadSheddingSetting: loadSheddingSetting}, {deviceId: id});
  }

  Future updateManualName(int id, String name) async {
    return database
        .updateField(manualTable, {manualName: name}, {manualId: id});
  }

  Future updateManualCapacity(int id, double capacity) async {
    return database
        .updateField(manualTable, {manualCapacity: capacity}, {manualId: id});
  }

  Future updateManualMaxProduction(int id, String maxProduction) async {
    return database.updateField(
        manualTable, {manualMaxProduction: maxProduction}, {manualId: id});
  }

  Future updateManualCount(int id, int count) async {
    return database
        .updateField(manualTable, {manualCount: count}, {manualId: id});
  }

  Future updateManualDailyUsage(int id, double dailyUsage) async {
    return database.updateField(
        manualTable, {manualDailyUsage: dailyUsage}, {manualId: id});
  }

  //Reading functions
  Future getUserDetails(int id) async {
    return database.readRecords(userTable, {userId: id});
  }

  Future getSystems() async {
    return database.readRecords(systemsTable, {});
  }

  Future getManualSystemDetails(int id) async {
    return database.readRecords(manualTable, {userId: id});
  }

  Future getUserDevices(int id) async {
    return database.readRecords(setupTable, {userId: id});
  }

  Future getDevice(int id, int singleDeviceId) async {
    return database
        .readRecords(setupTable, {userId: id, deviceId: singleDeviceId});
  }

  //deleting functions
  Future deleteDevice(int id, int singleDeviceId) async {
    database.deleteRecord(setupTable, {userId: id, deviceId: singleDeviceId});
    return database.deleteRecord(deviceTable, {deviceId: singleDeviceId});
  }

  Future deleteManualUserSystem(int id) async {
    return database.deleteRecord(manualTable, {userId: id});
  }
}
