abstract class IUserPersistence {
  covariant String? userTable,
      userId,
      userName,
      userPassword,
      userAddress,
      systemId;
  Future createUser(
      String name, int systemType, String password, String address);
  Future getUserDetails(int userId);
  Future updateUserAddress(int userId, String address);
  Future updateUserPassword(int userId, String password);
  Future updateUserName(int userId, String name);
}
