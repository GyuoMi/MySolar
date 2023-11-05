import 'package:my_solar_app/cloud_functions/database/database_api.dart';
import 'package:test/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  late DatabaseApi database;
  late SupabaseClient supabase;

  setUpAll(() {
    database = DatabaseApi();
    supabase = SupabaseClient('https://fsirbhoucrjtnkvchwuf.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzaXJiaG91Y3JqdG5rdmNod3VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIzNzYxNTAsImV4cCI6MjAwNzk1MjE1MH0.Bb3OZyxku8_7c_aIQe5GlMsup0SODK-5pPa92tzkNFM');
  });

  group("Creating functions ", () {
    test("Inserting a user into the database", () async {
      //
      //add user to database
      String name = "Sahil", password = "SomePassword", address = "SomeAddress";
      int systemType = 0;

      final user =
          await database.createUser(name, systemType, password, address);
      //check if user was added to database
      expectLater(user[0]['user_name'], name);
      expect(user[0]['system_id'], systemType);
      expect(user[0]['user_password'], password);
      expect(user[0]['user_address'], address);

      addTearDown(() async {
        await supabase
            .from('user_tbl')
            .delete()
            .match({'user_id': user[0]['user_id']});
      });
    });
  });
}
