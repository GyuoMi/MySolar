import 'package:supabase_flutter/supabase_flutter.dart';

class Database {
  late SupabaseClient supabase;
  //user table variables
  final userTable = 'user_tbl';
  final userName = 'user_name';
  final userPassword = 'user_password';
  final userAddress = 'user_address';
  final systemId = 'system_id';

  Database() {
    Supabase.initialize(
      url: 'https://fsirbhoucrjtnkvchwuf.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzaXJiaG91Y3JqdG5rdmNod3VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIzNzYxNTAsImV4cCI6MjAwNzk1MjE1MH0.Bb3OZyxku8_7c_aIQe5GlMsup0SODK-5pPa92tzkNFM',
    );
    supabase = Supabase.instance.client;
  }
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
}
