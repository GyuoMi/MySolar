abstract class IDatabaseFunctions {
  Future createRecord(String table, Map insert);
  Future readRecordsWhere(String table, Map matchesFields);
  Future readRecords(String table);
  Future updateField(String table, Map updatesColumn, Map matchesFields);
  Future deleteRecord(String table, Map matchesFields);
}
