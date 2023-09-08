abstract class IUserPersistence {
  Future createUser(
      String name, int systemType, String password, String address);
  Future getUserDetails(int id);
  Future updateUserAddress(int id, String address);
  Future updateUserPassword(int id, String password);
  Future updateUserName(int id, String name);
}
