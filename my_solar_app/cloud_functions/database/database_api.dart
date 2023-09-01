import 'package:supabase_flutter/supabase_flutter.dart';

class Database {
  static SupabaseClient supabase = SupabaseClient(
    'https://fsirbhoucrjtnkvchwuf.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzaXJiaG91Y3JqdG5rdmNod3VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIzNzYxNTAsImV4cCI6MjAwNzk1MjE1MH0.Bb3OZyxku8_7c_aIQe5GlMsup0SODK-5pPa92tzkNFM',
  );

  //column names
  //user table
  final userTable = 'user_tbl',
      userName = 'user_name',
      userPassword = 'user_password',
      userAddress = 'user_address',
      systemId = 'system_id';

  //device table
  final deviceTable = 'device_tbl',
      deviceId = 'device_id',
      deviceName = 'device_name',
      deviceUsage = 'device_usage',
      deviceWattage = 'device_wattage',
      deviceVoltage = 'device_voltage',
      deviceNormalSetting = 'device_normal',
      deviceLoadSheddingSetting = 'device_loadshedding';

  final manualTable = 'manual_tbl',
      manualName = 'manual_name',
      manualCapacity = 'manual_capacity',
      manualMaxProduction = 'manual_max_production',
      manualCount = 'manual_count',
      manualDailyUsage = 'manual_daily_usage';

  final recordsTable = 'records_tbl',
      recordsTime = 'records_time',
      recordsMinutesUsed = 'records_minutes';
  //manual table
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

  Future createDevice(String name, bool usage, double wattage, double voltage,
      bool normalSetting, bool loadSheddingSetting) async {
    final data = await supabase.from(deviceTable).insert({
      deviceName: name,
      deviceUsage: usage,
      deviceWattage: wattage,
      deviceVoltage: voltage,
      deviceNormalSetting: normalSetting,
      deviceLoadSheddingSetting: loadSheddingSetting
    }).select();
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
}
