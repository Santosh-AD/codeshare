import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CalendarDialog extends StatefulWidget {
  CalendarDialog(
      {@required this.date,
      this.onDateChanged,
      this.alreadyWrittendDays = const [],
      this.dateforFuture = false});

  final bool
      dateforFuture; // Select date for Future is possible mainly only require for habit, priority call, and _todo default false
  final List<int> alreadyWrittendDays;
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  int _month;
  int _year;

  //TODO find the selected dates from SQLite
  //TODO priority Transfered this to selected date page due to same SQL call for date selection
  //Store year in different column
  //Store month in different column
  //Store day in different column
  /*
  Select day from table where year =_year And month =_month order by day
   */
  var selectedDateList = [1, 3];

  var dayMonth = [31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  var monthYear = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  int _selected;

  int getDay(int month, int year) {
    if (month == 1) {
      if (checkLeap(year)) {
        return 29;
      } else {
        return 28;
      }
    } else {
      return dayMonth[month];
    }
  }

  bool checkLeap(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    _month = widget.date.month - 1;
    _year = widget.date.year;
    _selected = widget.date.day - 1;
    print("onInit State Month: $_month and year: $_year");
    selectedDateList = widget.alreadyWrittendDays.length > 0 ? widget.alreadyWrittendDays : [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(35),
                  shadowColor: Color(0xFFffa59f),
                  elevation: 12,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFFffa59f),
                        //Color(0xFFfeb8a2),
                        Color(0xFFffc9a5),
                      ]),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (_month == 0) {
                                _month = 11;
                                _year--;
                              } else {
                                _month--;
                              }
                            });
                            print("back arrow pressed month : $_month year:$_year");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.navigate_before,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              _year.toString(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            Text(
                              monthYear[_month],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap:
                              (DateTime.now().month == _month + 1 && DateTime.now().year == _year)
                                  ? null
                                  : () {
                                      setState(() {
                                        if (_month == 11) {
                                          _month = 0;
                                          _year++;
                                        } else {
                                          _month++;
                                        }
                                      });
                                      print("front arrow pressed month : $_month year:$_year");
                                    },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.navigate_next,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Material(
                color: Colors.transparent,
                shadowColor: Color(0xFFffa59f),
                elevation: 10,
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: GridView.builder(
                      padding: EdgeInsets.all(8.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: getDay(_month, _year),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 1.2,
                        childAspectRatio: 20 / 20,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: selectedDateList.contains(index + 1)
                              ? null
                              : () {
                                  setState(() {
                                    _selected = index;
                                    var newDate = DateTime(_year, _month + 1, _selected + 1);
                                    widget.onDateChanged(newDate);
                                    Navigator.pop(context);
                                  });
                                },
                          child: (index == _selected)
                              ? Material(
                                  type: MaterialType.circle,
                                  color: Colors.transparent,
                                  elevation: 2,
                                  shadowColor: Color(0xFFffa59f),
                                  child: Container(
                                    padding: EdgeInsets.all(1.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFFffc9a5),
                                            Color(0xFFffa59f),
                                            //Color(0xFFfeb8a2),
                                          ]),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          AutoSizeText(
                                            (index + 1).toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                              fontFamily: 'Quicksand',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxFontSize: 22,
                                            minFontSize: 16,
                                          ),
                                        ].where((e) => e != null).toList(),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18.0,
                                            fontFamily: 'Quicksand',
                                          ),
                                        ),
                                        (selectedDateList.contains(index + 1))
                                            ? Icon(
                                                Icons.add_circle,
                                                color: Color(0xFFffa59f),
                                                size: 5.0,
                                              )
                                            : Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.grey,
                                                size: 5.0,
                                              ),
                                      ].where((e) => e != null).toList(),
                                    ),
                                  ),
                                ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
