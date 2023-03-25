import 'package:flutter/material.dart';
import 'package:pomotimer/utils/timer.dart';

class LongBreak extends StatefulWidget {
  final TimeProvider timeProvider;
  final bool isRunningPomo;
  final bool isRunningShort;
  final bool isRunningLong;
  const LongBreak(
      {super.key,
      required this.isRunningLong,
      required this.timeProvider,
      required this.isRunningPomo,
      required this.isRunningShort});

  @override
  State<LongBreak> createState() => _LongBreakState();
}

class _LongBreakState extends State<LongBreak> {
  String timer = "15:00";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.timeProvider.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && widget.isRunningLong) {
            final int time = snapshot.data!;
            final int minutes = (time / 60).floor();
            final int seconds = time % 60;
            if (snapshot.data == 0) {
              timer = "15:00";
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
                      (widget.isRunningShort || widget.isRunningPomo)
                          ? Text(
                              widget.isRunningPomo
                                  ? "Pomodoro Already Started"
                                  : "Short Break Already Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              "Long Break",
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
                          color: (widget.isRunningShort || widget.isRunningPomo)
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
