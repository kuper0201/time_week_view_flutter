import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DateTime now = DateTime.now();
  List<FlutterWeekViewEvent> lst = [];

  @override
  void initState() {
    lst.add(FlutterWeekViewEvent(title: "title", description: "", start: now, end: now.add(const Duration(hours: 2))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DayView(
        userZoomable: true,
        events: lst,
        date: DateTime.now(),
        dragAndDropOptions: DragAndDropOptions(
          onEventDragged:(event, newStartTime) {
            final dur = event.end.subtract(Duration(hours: event.start.hour, minutes: event.start.minute));
            setState(() {
              event.start = newStartTime;
              event.end = event.start.add(Duration(hours: dur.hour, minutes: dur.minute));
            });
          },
        ),
        resizeEventOptions: ResizeEventOptions(
          snapToGridGranularity: const Duration(minutes: 1),
          onEventResized: (event, newEndTime) {
            setState(() {
              event.end = newEndTime;
            });
          },
        ),
      )
    );
  }
}