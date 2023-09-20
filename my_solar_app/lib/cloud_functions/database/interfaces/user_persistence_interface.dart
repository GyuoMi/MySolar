abstract class IUserPersistence {
  Future createUser(
      String name, int systemType, String password, String address);
  Future getUserDetails(int userId);
  Future updateUserAddress(int userId, String address);
  Future updateUserPassword(int userId, String password);
  Future updateUserName(int userId, String name);
}
