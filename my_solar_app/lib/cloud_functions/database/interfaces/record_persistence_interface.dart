abstract class IRecordPersistence {
  covariant String? recordsTable, recordsTime, recordsMinutesUsed;
  Future createRecord(int userId, int deviceId, String time, double minutes);
}
