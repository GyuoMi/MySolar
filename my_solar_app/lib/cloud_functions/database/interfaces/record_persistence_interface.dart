abstract class IRecordPersistence {
  covariant String? recordsTable, recordsTime, recordsMinutesUsed;
  Future createRecord(int deviceId, String time, double minutes);
}
