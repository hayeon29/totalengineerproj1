import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smart_alarm/data/calendar_data.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDay = currentDate;
  DateTime focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: TableCalendar(
          firstDay: DateTime(2021, 10),
          lastDay: DateTime(DateTime.now().year, DateTime.now().month + 1),
          focusedDay: focusedDay,
          weekendDays: [7],
          daysOfWeekVisible: true,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          onDaySelected: (DateTime selectDay, DateTime focusDay){
            setState((){
              currentDate = selectDay;
              focusedDay = focusDay;
            });
          },
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.black26.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            weekendTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            defaultTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          selectedDayPredicate: (DateTime date){
            return isSameDay(currentDate, date);
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
          ),
        ),
      )
    );
  }
}