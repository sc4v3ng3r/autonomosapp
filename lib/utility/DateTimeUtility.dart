
class DateTimeUtility{

  /// Método que retorna a data atual no formato dd/mm/yyyy
  static String getCurrentDateString(){
    var time = DateTime.now();
    String date = "${time.day}/${time.month}/${time.year}";
    return date;
  }
}