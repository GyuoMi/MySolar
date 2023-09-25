abstract class IManualSystemPersistence {
  covariant String? manualTable,
      manualId,
      manualName,
      manualCapacity,
      manualMaxProduction,
      manualCount,
      manualDailyUsage;

  Future createManualSystem(String name, double capacity, double maxProduction,
      int count, double dailyUsage);
  Future deleteManualUserSystem(int userId);
  Future getManualSystemDetails(int userId);
  Future updateManualDailyUsage(int userId, double dailyUsage);
  Future updateManualCount(int userId, int count);
  Future updateManualMaxProduction(int userId, String maxProduction);
  Future updateManualCapacity(int userId, double capacity);
  Future updateManualName(int userId, String name);
}
