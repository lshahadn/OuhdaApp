class Utiles {
 static List<DateTime> daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var lastDayThisMonth = DateTime(date.year, date.month + 1, 0);
    var days = List.generate(
        lastDayThisMonth.day, (index) => DateTime(date.year, date.month, index + 1));
    return days;
  }
}