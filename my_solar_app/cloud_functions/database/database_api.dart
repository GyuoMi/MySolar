import 'package:supabase_flutter/supabase_flutter.dart';

class Database {
  static SupabaseClient supabase = Supabase.instance.client;

  //column names
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
    final data = await supabase.from(userTable).insert({
      userName: name,
      systemId: systemType,
      userPassword: password,
      userAddress: address
    }).select();

    return data;
  }

  Future createDevice(int id, String name, bool usage, double wattage,
      double voltage, bool normalSetting, bool loadSheddingSetting) async {
    final data = await supabase.from(deviceTable).insert({
      deviceName: name,
      deviceUsage: usage,
      deviceWattage: wattage,
      deviceVoltage: voltage,
      deviceNormalSetting: normalSetting,
      deviceLoadSheddingSetting: loadSheddingSetting
    }).select();
    await supabase
        .from(setupTable)
        .insert({userId: id, deviceId: data[0][deviceId]});
    return data;
  }

  Future createManualSystem(String name, double capacity, double maxProduction,
      int count, double dailyUsage) async {
    final data = await supabase.from(manualTable).insert({
      manualName: name,
      manualCapacity: capacity,
      manualMaxProduction: maxProduction,
      manualCount: count,
      manualDailyUsage: dailyUsage
    });
    return data;
  }

  Future createRecord(int id, String time, double minutes) async {
    final data = await supabase
        .from(recordsTable)
        .insert({deviceId: id, recordsTime: time, recordsMinutesUsed: minutes});
    return data;
  }

  //updating functions
  Future updateUserName(int id, String name) async {
    final data = await supabase
        .from(userTable)
        .update({userName: name}).match({userId: id}).select();
    return data;
  }

  Future updateUserPassword(int id, String password) async {
    final data = await supabase
        .from(userTable)
        .update({userPassword: password}).match({userId: id}).select();
    return data;
  }

  Future updateUserAddress(int id, String address) async {
    final data = await supabase
        .from(userTable)
        .update({userAddress: address}).match({userId: id}).select();
    return data;
  }

  Future updateDeviceName(int id, String name) async {
    final data = await supabase
        .from(deviceTable)
        .update({deviceName: name}).match({deviceId: id}).select();
    return data;
  }

  Future updateDeviceUsage(int id, bool usage) async {
    final data = await supabase
        .from(deviceTable)
        .update({deviceUsage: usage}).match({deviceId: id}).select();
    return data;
  }

  Future updateDeviceWattage(int id, double wattage) async {
    final data = await supabase
        .from(deviceTable)
        .update({deviceWattage: wattage}).match({deviceId: id}).select();
    return data;
  }

  Future updateDeviceVoltage(int id, double voltage) async {
    final data = await supabase
        .from(deviceTable)
        .update({deviceVoltage: voltage}).match({deviceId: id}).select();
    return data;
  }

  Future updateDeviceNormalSetting(int id, bool normalSetting) async {
    final data = await supabase.from(deviceTable).update(
        {deviceNormalSetting: normalSetting}).match({deviceId: id}).select();
    return data;
  }

  Future updateDeviceLoadSheddingSetting(
      int id, bool loadSheddingSetting) async {
    final data = await supabase
        .from(deviceTable)
        .update({deviceLoadSheddingSetting: loadSheddingSetting}).match(
            {deviceId: id}).select();
    return data;
  }

  Future updateManualName(int id, String name) async {
    final data = await supabase
        .from(manualTable)
        .update({manualName: name}).match({manualId: id}).select();
    return data;
  }

  Future updateManualCapacity(int id, double capacity) async {
    final data = await supabase
        .from(manualTable)
        .update({manualCapacity: capacity}).match({manualId: id}).select();
    return data;
  }

  Future updateManualMaxProduction(int id, String maxProduction) async {
    final data = await supabase.from(manualTable).update(
        {manualMaxProduction: maxProduction}).match({manualId: id}).select();
    return data;
  }

  Future updateManualCount(int id, int count) async {
    final data = await supabase
        .from(manualTable)
        .update({manualCount: count}).match({manualId: id}).select();
    return data;
  }

  Future updateManualDailyUsage(int id, double dailyUsage) async {
    final data = await supabase
        .from(manualTable)
        .update({manualDailyUsage: dailyUsage}).match({manualId: id}).select();
    return data;
  }

  //Reading functions
  Future getUserDetails(int id) async {
    final data = await supabase.from(userTable).select().match({userId: id});
    return data;
  }

  Future getSystems() async {
    final data = await supabase.from(systemsTable).select();
    return data;
  }

  Future getManualSystemDetails(int id) async {
    final data = await supabase.from(manualTable).select().match({userId: id});
    return data;
  }

  Future getUserDevices(int id) async {
    final data = await supabase.from(setupTable).select().match({userId: id});
    return data;
  }

  Future getDevice(int id, int singleDeviceId) async {
    final data = await supabase
        .from(setupTable)
        .select()
        .match({userId: id, deviceId: singleDeviceId});
    return data;
  }

  //deleting functions
  Future deleteDevice(int id, int singleDeviceId) async {
    await supabase
        .from(setupTable)
        .delete()
        .match({userId: id, deviceId: singleDeviceId});
    final data = await supabase
        .from(deviceTable)
        .delete()
        .match({deviceId: singleDeviceId}).select();
    return data;
  }

  Future deleteManualUserSystem(int id) async {
    final data =
        await supabase.from(manualTable).delete().match({userId: id}).select();
    return data;
  }
}
