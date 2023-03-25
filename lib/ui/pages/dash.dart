import 'package:flutter/material.dart';
import 'package:pomotimer/ui/pages/longbreak.dart';
import 'package:pomotimer/ui/pages/pomodoro.dart';
import 'package:pomotimer/ui/pages/shortbreak.dart';
import 'package:pomotimer/utils/timer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int ind = 0;
  TimeProvider timeProvider = TimeProvider();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: timeProvider.stream,
        builder: (context, snapshot) {
          final isRunningPomo = timeProvider.isRunningPomo;
          final isRunningShort = timeProvider.isRunningShort;
          final isRunningLong = timeProvider.isRunningLong;
          return Scaffold(
            // Horizaontally scrollable pages
            body: PageView.builder(
              allowImplicitScrolling: true,
              pageSnapping: true,
              physics: const RangeMaintainingScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  ind = value;
                });
              },
              scrollBehavior: const MaterialScrollBehavior(),
              itemCount: 3, // Number of pages
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Pomodoro(
                      isRunningPomo: isRunningPomo,
                      isRunningShort: isRunningShort,
                      isRunningLong: isRunningLong,
                      timeProvider: timeProvider,
                    );
                  case 1:
                    return ShortBreak(
                      timeProvider: timeProvider,
                      isRunningShort: isRunningShort,
                      isRunningLong: isRunningLong,
                      isRunningPomo: isRunningPomo,
                    );
                  case 2:
                    return LongBreak(
                      timeProvider: timeProvider,
                      isRunningLong: isRunningLong,
                      isRunningPomo: isRunningPomo,
                      isRunningShort: isRunningShort,
                    );
                  default:
                    return Pomodoro(
                      isRunningPomo: isRunningPomo,
                      isRunningShort: isRunningShort,
                      isRunningLong: isRunningLong,
                      timeProvider: timeProvider,
                    );
                }
              },
            ),

            floatingActionButton: !isRunningPomo
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        if (isRunningPomo || isRunningShort || isRunningLong) {
                          timeProvider.reset();
                        } else {
                          switch (ind) {
                            case 0:
                              timeProvider.start(1500);
                              break;
                            case 1:
                              timeProvider.start(300);
                              break;
                            case 2:
                              timeProvider.start(900);
                              break;
                          }
                        }
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: (isRunningPomo ||
                                    isRunningLong ||
                                    isRunningShort)
                                ? Colors.red
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              (isRunningPomo || isRunningLong || isRunningShort)
                                  ? "Reset"
                                  : "Start",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        });
  }
}
