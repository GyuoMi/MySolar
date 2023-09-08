abstract class IManualSystemPersistence {
  Future createManualSystem(String name, double capacity, double maxProduction,
      int count, double dailyUsage);
  Future deleteManualUserSystem(int id);
  Future getManualSystemDetails(int id);
  Future updateManualDailyUsage(int id, double dailyUsage);
  Future updateManualCount(int id, int count);
  Future updateManualMaxProduction(int id, String maxProduction);
  Future updateManualCapacity(int id, double capacity);
  Future updateManualName(int id, String name);
}
