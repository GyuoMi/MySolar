abstract class IDatabaseFunctions {
  Future calculateAllTimeTotals(int id);
  Future calculateDailyTotals(int id);
  Future calculateWeeklyTotals(int id);
  Future calculateMonthlyTotals(int id);
  Future getHourlyTotals(int id);
  Future getTime();
}
