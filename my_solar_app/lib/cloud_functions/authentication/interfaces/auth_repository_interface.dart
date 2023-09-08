abstract class IAuthRepository {
  signInEmailAndPassword(String email, String password);
  signUpEmailAndPassword(String email, String password);
  signOut();
}
