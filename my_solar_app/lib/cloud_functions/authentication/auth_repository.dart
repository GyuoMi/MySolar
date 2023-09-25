import 'package:supabase_flutter/supabase_flutter.dart';
import 'interfaces/auth_repository_interface.dart';

class AuthRepository implements IAuthRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future signInEmailAndPassword(String email, String password) async {
    final response = await supabase.auth
        .signInWithPassword(password: password, email: email);
    return response;
  }

  @override
  Future signUpEmailAndPassword(String email, String password) async {
    final response =
        await supabase.auth.signUp(password: password, email: email);
    return response;
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
    return;
  }
}
