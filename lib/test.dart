import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();
  TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);
  bool iosStyle = true;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.replay),
      //   onPressed: () {
      //     _controller.animateToSelection();
      //   },
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DatePicker(
                height: 90,
                DateTime.now(),
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.black,
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  // New date selected
                  setState(() {
                    _selectedValue = date;
                  });
                },
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Text(
              //       "Popup Picker Style",
              //       style: Theme.of(context).textTheme.headline6,
              //     ),
              //     Text(
              //       _time.format(context),
              //       textAlign: TextAlign.center,
              //       style: Theme.of(context).textTheme.headline1,
              //     ),
              //     const SizedBox(height: 10),
              //     TextButton(
              //       style: TextButton.styleFrom(
              //         backgroundColor: Theme.of(context).colorScheme.secondary,
              //       ),
              //       onPressed: () {
              //         Navigator.of(context).push(
              //           showPicker(
              //             context: context,
              //             value: _time,
              //             onChange: onTimeChanged,
              //             minuteInterval: MinuteInterval.FIVE,
              //             // Optional onChange to receive value as DateTime
              //             onChangeDateTime: (DateTime dateTime) {
              //               // print(dateTime);
              //               debugPrint("[debug datetime]:  $dateTime");
              //             },
              //           ),
              //         );
              //       },
              //       child: const Text(
              //         "Open time picker",
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     ),
              //     const SizedBox(height: 10),
              //     const Divider(),
              //     const SizedBox(height: 10),
              //     Text(
              //       "Inline Picker Style",
              //       style: Theme.of(context).textTheme.headline6,
              //     ),
              //     // Render inline widget
              //     createInlinePicker(
              //       elevation: 1,
              //       value: _time,
              //       onChange: onTimeChanged,
              //       minuteInterval: MinuteInterval.FIVE,
              //       iosStylePicker: iosStyle,
              //       minHour: 9,
              //       maxHour: 21,
              //       is24HrFormat: false,
              //     ),
              //     Text(
              //       "IOS Style",
              //       style: Theme.of(context).textTheme.bodyText1,
              //     ),
              //     Switch(
              //       value: iosStyle,
              //       onChanged: (newVal) {
              //         setState(() {
              //           iosStyle = newVal;
              //         });
              //       },
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
