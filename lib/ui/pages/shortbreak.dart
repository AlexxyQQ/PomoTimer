import 'package:flutter/material.dart';
import 'package:pomotimer/utils/timer.dart';

class ShortBreak extends StatefulWidget {
  final bool isRunningPomo;
  final bool isRunningShort;
  final bool isRunningLong;
  final TimeProvider timeProvider;

  const ShortBreak(
      {super.key,
      required this.isRunningShort,
      required this.timeProvider,
      required this.isRunningPomo,
      required this.isRunningLong});

  @override
  State<ShortBreak> createState() => _ShortBreakState();
}

class _ShortBreakState extends State<ShortBreak> {
  String timer = "05:00";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.timeProvider.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && widget.isRunningShort) {
            final int time = snapshot.data!;
            final int minutes = (time / 60).floor();
            final int seconds = time % 60;
            if (snapshot.data == 0) {
              timer = "05:00";
            } else {
              timer = "$minutes:${seconds.toString().padLeft(2, '0')}";
            }
          }
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (widget.isRunningLong || widget.isRunningPomo)
                          ? Text(
                              widget.isRunningPomo
                                  ? "Pomodoro Already Started"
                                  : "Long Break Already Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              "Short Break",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const SizedBox(height: 10),
                      Text(
                        timer,
                        style: TextStyle(
                          color: (widget.isRunningLong || widget.isRunningPomo)
                              ? Colors.grey
                              : Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
