class LoggedInUser {
//logged in users details
  static var userId = 0, systemId = 0;
  static var userEmail = "", userPassword = "", userAddress = "";

  //logged in users system details
  static var systemName = "";
  static var amountOfSolarPanels = 0,
      solarPanelProduction = 0.0,
      batteryCapacityInWatts = 0.0;

  static setUser(
      int id, int sysId, String email, String password, String address) {
    userId = id;
    systemId = sysId;
    userEmail = email;
    userPassword = password;
    userAddress = address;
  }

  static getUserId() {
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

  static setSystem(
      String name, int panels, double panelProduction, double batteryCapacity) {
    systemName = name;
    amountOfSolarPanels = panels;
    solarPanelProduction = panelProduction;
    batteryCapacityInWatts = batteryCapacity;
  }

  static getSystemName() {
    return systemName;
  }

  static getSolarPanelAmount() {
    return amountOfSolarPanels;
  }

  static getProductionOfSolarPanel() {
    return solarPanelProduction;
  }

  static getBatteryCapacityInWatts() {
    return batteryCapacityInWatts;
  }
}
