abstract class IDatabaseFunctions {
  Future createRecord(String table, Map insert);
  Future readRecords(String table, Map matchesFields);
  Future updateField(String table, Map updatesColumn, Map matchesFields);
  Future deleteRecord(String table, Map matchesFields);
}
