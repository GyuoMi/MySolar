import 'package:my_solar_app/cloud_functions/database/interfaces/system_persistence_interface.dart';

import 'interfaces/crud_functions_interface.dart';
import 'interfaces/database_functions_interface.dart';
import 'interfaces/device_persistence_interface.dart';
import 'interfaces/manual_system_persistence_interface.dart';
import 'interfaces/record_persistence_interface.dart';
import 'interfaces/user_persistence_interface.dart';
import 'supabase_functions.dart';

class DatabaseApi
    implements
        IUserPersistence,
        IDevicePersistence,
        IManualSystemPersistence,
        IRecordPersistence,
        ISystemPersistence,
        IDatabaseFunctions {
  //column names
  final ICRUDFunctions database = SupabaseFunctions();

  @override
  String userTable = 'user_tbl',
      userId = 'user_id',
      userName = 'user_name',
      userPassword = 'user_password',
      userAddress = 'user_address',
      systemId = 'system_id';

  @override
  String deviceTable = 'device_tbl',
      deviceId = 'device_id',
      deviceName = 'device_name',
      deviceUsage = 'device_usage',
      deviceWattage = 'device_wattage',
      deviceVoltage = 'device_voltage',
      deviceNormalSetting = 'device_normal',
      deviceLoadSheddingSetting = 'device_loadshedding';

  @override
  String manualTable = 'manual_user_system_tbl',
      manualId = 'manual_id',
      manualName = 'manual_name',
      manualCapacity = 'manual_capacity',
      manualMaxProduction = 'manual_max_production',
      manualCount = 'manual_count',
      manualDailyUsage = 'manual_daily_usage';

  @override
  String recordsTable = 'records_tbl',
      recordsTime = 'records_time',
      recordsMinutesUsed = 'records_minutes';

  @override
  String systemsTable = 'systems_tbl';

  final setupTable = 'setup_tbl';

  //variables for database functions
  String databaseFunctionId = 'id';

  //creating functions
  @override
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

  @override
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

  @override
  Future createManualSystem(int id, String name, int capacity,
      double maxProduction, int count, double dailyUsage) async {
    final manualData = {
      userId: id,
      manualName: name,
      manualCapacity: capacity,
      manualMaxProduction: maxProduction,
      manualCount: count,
      manualDailyUsage: dailyUsage
    };
    return database.createRecord(manualTable, manualData);
  }

  @override
  Future createRecord(int uid, int id, String time, double minutes) async {
    final recordData = {
      userId: uid,
      deviceId: id,
      recordsTime: time,
      recordsMinutesUsed: minutes
    };
    return database.createRecord(recordsTable, recordData);
  }

  //updating functions
  @override
  Future updateUserName(int id, String name) async {
    return database.updateField(userTable, {userName: name}, {userId: id});
  }

  @override
  Future updateUserPassword(int id, String password) async {
    return database
        .updateField(userTable, {userPassword: password}, {userId: id});
  }

  @override
  Future updateUserAddress(int id, String address) async {
    return database
        .updateField(userTable, {userAddress: address}, {userId: id});
  }

  @override
  Future updateDeviceName(int id, String name) async {
    return database
        .updateField(deviceTable, {deviceName: name}, {deviceId: id});
  }

  @override
  Future updateDeviceUsage(int id, bool usage) async {
    return database
        .updateField(deviceTable, {deviceUsage: usage}, {deviceId: id});
  }

  @override
  Future updateDeviceWattage(int id, double wattage) async {
    return database
        .updateField(deviceTable, {deviceWattage: wattage}, {deviceId: id});
  }

  @override
  Future updateDeviceVoltage(int id, double voltage) async {
    return database
        .updateField(deviceTable, {deviceVoltage: voltage}, {deviceId: id});
  }

  @override
  Future updateDeviceNormalSetting(int id, bool normalSetting) async {
    return database.updateField(
        deviceTable, {deviceNormalSetting: normalSetting}, {deviceId: id});
  }

  @override
  Future updateDeviceLoadSheddingSetting(
      int id, bool loadSheddingSetting) async {
    return database.updateField(deviceTable,
        {deviceLoadSheddingSetting: loadSheddingSetting}, {deviceId: id});
  }

  @override
  Future updateManualName(int id, String name) async {
    return database.updateField(manualTable, {manualName: name}, {userId: id});
  }

  @override
  Future updateManualCapacity(int id, int capacity) async {
    return database
        .updateField(manualTable, {manualCapacity: capacity}, {userId: id});
  }

  @override
  Future updateManualMaxProduction(int id, double maxProduction) async {
    return database.updateField(
        manualTable, {manualMaxProduction: maxProduction}, {userId: id});
  }

  @override
  Future updateManualCount(int id, int count) async {
    return database
        .updateField(manualTable, {manualCount: count}, {userId: id});
  }

  @override
  Future updateManualDailyUsage(int id, double dailyUsage) async {
    return database
        .updateField(manualTable, {manualDailyUsage: dailyUsage}, {userId: id});
  }

  //Reading functions
  @override
  Future getUserDetails(String name) async {
    return database.readRecordsWhere(userTable, {userName: name});
  }

  @override
  Future getSystems() async {
    return database.readRecords(systemsTable);
  }

  @override
  Future getManualSystemDetails(int id) async {
    return database.readRecordsWhere(manualTable, {userId: id});
  }

  @override
  Future getUserDeviceIds(int id) async {
    return database.readRecordsWhere(setupTable, {userId: id});
  }

  @override
  Future getDevice(int singleDeviceId) async {
    return database.readRecordsWhere(deviceTable, {deviceId: singleDeviceId});
  }

  //deleting functions
  @override
  Future deleteDevice(int singleDeviceId) async {
    await database.deleteRecord(setupTable, {deviceId: singleDeviceId});
    return database.deleteRecord(deviceTable, {deviceId: singleDeviceId});
  }

  @override
  Future deleteManualUserSystem(int id) async {
    return database.deleteRecord(manualTable, {userId: id});
  }

//database functions
  @override
  Future calculateAllTimeTotals(int id) async {
    return database.databaseFunction(
        'calculate_all_time_totals', {databaseFunctionId: id});
  }

  @override
  Future calculateDailyTotals(int id) async {
    return database
        .databaseFunction('calculate_daily_totals', {databaseFunctionId: id});
  }

  @override
  Future calculateWeeklyTotals(int id) async {
    return database
        .databaseFunction('calculate_weekly_totals', {databaseFunctionId: id});
  }

  @override
  Future calculateMonthlyTotals(int id) async {
    return database
        .databaseFunction('calculate_monthly_totals', {databaseFunctionId: id});
  }

  @override
  Future getHourlyTotals(int id) async {
    return database
        .databaseFunction('get_hourly_totals', {databaseFunctionId: id});
  }

  @override
  Future getTime() async {
    return database.databaseFunction('get_time', {});
  }
}
