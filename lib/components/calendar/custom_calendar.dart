import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CustomCalendar({super.key, required this.onDateSelected});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  List<Widget> _buildDayLabels() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days
        .map(
          (day) => Center(
            child: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final daysInMonth = DateUtils.getDaysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    final weekdayOffset =
        firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;

    final totalCells = weekdayOffset + daysInMonth;
    return List.generate(totalCells, (index) {
      if (index < weekdayOffset) {
        return const SizedBox();
      } else {
        final day = index - weekdayOffset + 1;
        final currentDay = DateTime(
          _currentMonth.year,
          _currentMonth.month,
          day,
        );

        final isSelected = DateUtils.isSameDay(currentDay, _selectedDate);
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = currentDay;
              widget.onDateSelected(currentDay);
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF00D09E) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final month = DateFormat.MMMM().format(_currentMonth);
    final year = _currentMonth.year.toString();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _goToPreviousMonth,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Row(
                children: [
                  Text(
                    '$month ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(year, style: const TextStyle(fontSize: 18)),
                ],
              ),
              IconButton(
                onPressed: _goToNextMonth,
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: _buildDayLabels(),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: _buildCalendarDays(),
        ),
      ],
    );
  }
}
