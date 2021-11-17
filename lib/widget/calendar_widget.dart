import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.transparent,
        child: TableCalendar(
          firstDay: DateTime(2021, 10),
          lastDay: DateTime(DateTime.now().year, DateTime.now().month + 1),
          focusedDay: focusedDay,
          weekendDays: [7],
          daysOfWeekVisible: true,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          onDaySelected: (DateTime selectDay, DateTime focusDay){
            setState((){
              selectedDay = selectDay;
              focusedDay = focusDay;
            });
          },
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.black26.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            weekendTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            defaultTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          selectedDayPredicate: (DateTime date){
            return isSameDay(selectedDay, date);
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          ),
        ),
      )
    );
  }
}