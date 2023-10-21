import 'interfaces/database_functions_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunctions implements IDatabaseFunctions {
  static SupabaseClient supabase = SupabaseClient(
      'https://fsirbhoucrjtnkvchwuf.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzaXJiaG91Y3JqdG5rdmNod3VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIzNzYxNTAsImV4cCI6MjAwNzk1MjE1MH0.Bb3OZyxku8_7c_aIQe5GlMsup0SODK-5pPa92tzkNFM');

  @override
  Future updateField(String table, Map updates, Map matchesFields) async {
    final data = await supabase
        .from(table)
        .update(updates)
        .match(matchesFields)
        .select();
    return data;
  }

  @override
  Future createRecord(String table, Map insertData) async {
    final data = await supabase.from(table).insert(insertData).select();
    return data;
  }

  @override
  Future readRecordsWhere(String table, Map matchesFields) async {
    final data = await supabase.from(table).select().match(matchesFields);
    return data;
  }

  @override
  Future readRecords(String table) async {
    final data = await supabase.from(table).select();
    return data;
  }

  @override
  Future deleteRecord(String table, Map matchesFields) async {
    final data =
        await supabase.from(table).delete().match(matchesFields).select();
    return data;
  }

  @override
  Future databaseFunction(
      String functionName, Map<String, dynamic> matchesFields) async {
    final data = await supabase.rpc(functionName, params: matchesFields);
    return data;
  }
}
