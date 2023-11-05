abstract class IUserPersistence {
  covariant String? userTable,
      userId,
      userName,
      userPassword,
      userAddress,
      systemId;
  Future createUser(
      String email, int systemType, String password, String address);
  Future getUserDetails(String userName);
  Future updateUserAddress(int userId, String address);
  Future updateUserPassword(int userId, String password);
  Future updateUserName(int userId, String name);
}
