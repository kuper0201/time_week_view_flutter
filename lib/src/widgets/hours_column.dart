import 'package:flutter/material.dart';
import 'package:flutter_week_view/src/styles/hours_column.dart';
import 'package:flutter_week_view/src/utils/builders.dart';
import 'package:flutter_week_view/src/utils/hour_minute.dart';
import 'package:flutter_week_view/src/widgets/zoomable_header_widget.dart';

/// A column which is showing a day hours.
class HoursColumn extends StatefulWidget {
  /// The minimum time to display.
  final HourMinute minimumTime;

  /// The maximum time to display.
  final HourMinute maximumTime;

  /// The top offset calculator.
  final TopOffsetCalculator topOffsetCalculator;

  /// The widget style.
  final HoursColumnStyle style;

  /// Triggered when the hours column has been tapped down.
  final HoursColumnTapCallback? onHoursColumnTappedDown;

  /// The times to display on the side border.
  final List<HourMinute> _sideTimes;

  /// Building method for building the time displayed on the side border.
  final HoursColumnTimeBuilder hoursColumnTimeBuilder;

  /// Building method for building background decoration below single time displayed on the side border.
  final HoursColumnBackgroundBuilder? hoursColumnBackgroundBuilder;
  
  /// For Item Move Indicator
  final DateTime? dt;

  /// For Item Resize Indicator
  final DateTime? resizing;

  /// Creates a new hours column instance.
  HoursColumn({
    super.key,
    this.minimumTime = HourMinute.min,
    this.maximumTime = HourMinute.max,
    TopOffsetCalculator? topOffsetCalculator,
    this.style = const HoursColumnStyle(),
    this.onHoursColumnTappedDown,
    HoursColumnTimeBuilder? hoursColumnTimeBuilder,
    this.hoursColumnBackgroundBuilder,
    this.dt,
    this.resizing,
  })  : assert(minimumTime < maximumTime),
        topOffsetCalculator = topOffsetCalculator ?? DefaultBuilders.defaultTopOffsetCalculator,
        hoursColumnTimeBuilder = hoursColumnTimeBuilder ?? DefaultBuilders.defaultHoursColumnTimeBuilder,
        _sideTimes = getSideTimes(minimumTime, maximumTime, style.interval);

  /// Creates a new h, super(key: key)ours column instance from a headers widget instance.
  HoursColumn.fromHeadersWidgetState({
    Key? key,
    required ZoomableHeadersWidgetState parent,
    required DateTime? dt,
    required DateTime? resizing,
  }) : this(
          key: key,
          minimumTime: parent.widget.minimumTime,
          maximumTime: parent.widget.maximumTime,
          topOffsetCalculator: parent.calculateTopOffset,
          style: parent.widget.hoursColumnStyle,
          onHoursColumnTappedDown: parent.widget.onHoursColumnTappedDown,
          hoursColumnTimeBuilder: parent.widget.hoursColumnTimeBuilder,
          hoursColumnBackgroundBuilder: parent.widget.hoursColumnBackgroundBuilder,
          dt: dt,
          resizing: resizing
        );

  

  /// Creates the side times.
  static List<HourMinute> getSideTimes(HourMinute minimumTime, HourMinute maximumTime, Duration interval) {
    List<HourMinute> sideTimes = [];
    HourMinute currentHour = HourMinute(hour: minimumTime.hour + 1);
    while (currentHour < maximumTime) {
      sideTimes.add(currentHour);
      currentHour = currentHour.add(HourMinute.fromDuration(duration: interval));
    }
    return sideTimes;
  }
  
  @override
  State<StatefulWidget> createState() => _HoursColumnState();
}

class _HoursColumnState extends State<HoursColumn> {
  @override
  Widget build(BuildContext context) {
    final singleHourSize = widget.topOffsetCalculator(widget.maximumTime) / (widget.maximumTime.hour);
    final Widget background;
    if (widget.hoursColumnBackgroundBuilder != null) {
      background = SizedBox(
        height: widget.topOffsetCalculator(widget.maximumTime),
        width: widget.style.width,
        child: Padding(
          padding: EdgeInsets.only(top: singleHourSize),
          child: Column(
            children: widget._sideTimes
                .map(
                  (time) => Container(
                    decoration: widget.hoursColumnBackgroundBuilder!(time),
                    height: singleHourSize,
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      background = const SizedBox.shrink();
    }
    
    List<Widget> t = [];
    if(widget.dt != null) {
      t.add(Positioned(
        top: widget.topOffsetCalculator(HourMinute.fromDateTime(dateTime: widget.dt!)) - ((widget.style.textStyle.fontSize ?? 14) / 2),
        left: 0,
        right: 0,
        child: Align(
          alignment: widget.style.textAlignment,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.lightGreen),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: widget.hoursColumnTimeBuilder(widget.style, HourMinute.fromDateTime(dateTime: widget.dt!)),
            )
          )
        )
      ));
    }

    if(widget.resizing != null) {
      t.add(Positioned(
        top: widget.topOffsetCalculator(HourMinute.fromDateTime(dateTime: widget.resizing!)) - ((widget.style.textStyle.fontSize ?? 14) / 2),
        left: 0,
        right: 0,
        child: Align(
          alignment: widget.style.textAlignment,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.lightGreen),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: widget.hoursColumnTimeBuilder(widget.style, HourMinute.fromDateTime(dateTime: widget.resizing!)),
            )
          )
        )
      ));
    }

    Widget child = Container(
      height: widget.topOffsetCalculator(widget.maximumTime),
      width: widget.style.width,
      color: widget.style.decoration == null ? widget.style.color : null,
      decoration: widget.style.decoration,
      child: Stack(
        children: <Widget>[background] +
            widget._sideTimes
                .map(
                  (time) => Positioned(
                    top: widget.topOffsetCalculator(time) - ((widget.style.textStyle.fontSize ?? 14) / 2),
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: widget.style.textAlignment,
                      child: widget.hoursColumnTimeBuilder(widget.style, time),
                    ),
                  ),
                )
                .toList() + t,
      ),
    );

    if (widget.onHoursColumnTappedDown == null) {
      return child;
    }

    return GestureDetector(
      onTapDown: (details) {
        var hourRowHeight = widget.topOffsetCalculator(widget.minimumTime.add(const HourMinute(hour: 1)));
        double hourMinutesInHour = details.localPosition.dy / hourRowHeight;

        int hour = hourMinutesInHour.floor();
        int minute = ((hourMinutesInHour - hour) * 60).round();
        widget.onHoursColumnTappedDown!(widget.minimumTime.add(HourMinute(hour: hour, minute: minute)));
      },
      child: child,
    );
  }
}
