class LoggedInUser {
  static var userId = 0, systemId = 0;
  static var userEmail = "", userPassword = "", userAddress = "";

  static setUser(
      int id, int sysId, String email, String password, String address) {
    userId = id;
    systemId = sysId;
    userEmail = email;
    userPassword = password;
    userAddress = address;
  }

  static getuserId() {
    return userId;
  }

  static getSystemId() {
    return systemId;
  }

  static getEmail() {
    return userEmail;
  }

  static getPassword() {
    return userPassword;
  }

  static getAddress() {
    return userAddress;
  }

  static setSystemId(int id) {
    systemId = id;
  }

  static setEmail(String email) {
    userEmail = email;
  }

  static setPassword(String password) {
    userPassword = password;
  }

  static setAddress(String address) {
    userAddress = address;
  }
}
