import '../../cloud_functions/database/database_api.dart';
import 'package:test/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  /*
  late Database database = Database();
  late SupabaseClient supabase;

  setUpAll(() {
    database = Database();
    supabase = SupabaseClient(
      'https://fsirbhoucrjtnkvchwuf.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzaXJiaG91Y3JqdG5rdmNod3VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIzNzYxNTAsImV4cCI6MjAwNzk1MjE1MH0.Bb3OZyxku8_7c_aIQe5GlMsup0SODK-5pPa92tzkNFM',
    );
  });

  group("Creating functions ", () {
    test("Inserting a user into table", () async {
      //add user to database
      String name = "SomeonSomeone",
          password = "SomePassword",
          address = "SomeAddress";
      int systemType = 0;

      //inserts user into database
      final user =
          await database.createUser(name, systemType, password, address);

      //check if user was added to database
      expect(user[0]['user_name'], name);
      expect(user[0]['system_id'], systemType);
      expect(user[0]['user_password'], password);
      expect(user[0]['user_address'], address);

      //removes test user from database
      addTearDown(() async {
        await supabase
            .from('user_tbl')
            .delete()
            .match({'user_id': user[0]['user_id']});
      });
    });

    test("Inserting device into table", () async {
      String name = "someDevice";
      bool usage = true, normalSetting = false, loadSheddingSetting = false;
      double wattage = 500, voltage = 16.4;

      final device = await database.createDevice(
          name, usage, wattage, voltage, normalSetting, loadSheddingSetting);

      expect(device[0]['device_name'], name);
      expect(device[0]['device_usage'], usage);
      expect(device[0]['device_normal'], normalSetting);
      expect(device[0]['device_loading'], loadSheddingSetting);
      expect(device[0]['device_voltage'], voltage);
      expect(device[0]['device_wattage'], wattage);

      addTearDown(() async {
        await supabase
            .from('device_tbl')
            .delete()
            .match({'device_id': device[0]['device_id']});
      });
    });
  });*/
}
