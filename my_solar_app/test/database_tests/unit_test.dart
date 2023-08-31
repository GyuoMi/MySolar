import '../../cloud_functions/database/database_api.dart';
import 'package:test/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  late Database database = Database();
  late SupabaseClient supabase = Supabase.instance.client;

  setUpAll(() {
    database = Database();
    supabase = Supabase.instance.client;
  });

  group("Creating functions ", () {
    test("Inserting a user into the database", () async {
      //
      //add user to database
      String name = "Sahil";
      int systemType = 0;
      String password = "SomePassword";
      String address = "SomeAddress";

      final user = await database.createUser(name, systemType, password, address);
      //check if user was added to database
      expectLater(user[0]['user_name'], name);
      expect(user[0]['system_id'], systemType);
      expect(user[0]['user_password'], password);
      expect(user[0]['user_address'], address);

      addTearDown(() async{
        supabase = Supabase.instance.client;
        await supabase
            .from('user_tbl')
            .delete()
            .match({'user_id': user[0]['user_id']});
      });
    });
  });
}
