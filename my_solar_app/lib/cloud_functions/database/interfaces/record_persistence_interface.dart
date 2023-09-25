abstract class IRecordPersistence {
  covariant String? recordsTable, recordsTime, recordsMinutesUsed;
  Future createRecord(int userId, String time, double minutes);
}
