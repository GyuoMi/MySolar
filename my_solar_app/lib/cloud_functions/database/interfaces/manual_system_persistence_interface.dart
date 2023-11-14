abstract class IManualSystemPersistence {
  covariant String? manualTable,
      manualId,
      manualName,
      manualCapacity,
      manualMaxProduction,
      manualCount,
      manualDailyUsage;

  Future createManualSystem(int userId, String name, int capacity,
      double maxProduction, int count, double dailyUsage);
  Future deleteManualUserSystem(int userId);
  Future getManualSystemDetails(int userId);
  Future updateManualDailyUsage(int userId, double dailyUsage);
  Future updateManualCount(int userId, int count);
  Future updateManualMaxProduction(int userId, double maxProduction);
  Future updateManualCapacity(int userId, int capacity);
  Future updateManualName(int userId, String name);
}
