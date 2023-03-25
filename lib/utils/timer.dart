import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class TimeProvider {
  static TimeProvider? _instance;

  factory TimeProvider() {
    _instance ??= TimeProvider._();
    return _instance!;
  }

  TimeProvider._() {
    _controller = StreamController<int>.broadcast(
      onListen: () {
        if (_isRunningPomo) {
          start(_duration);
        }
      },
    );
  }
  final audioPlayer = AudioPlayer();
  bool _isRunningPomo = false;
  bool _isRunningShort = false;
  bool _isRunningLong = false;
  int _duration = 0;
  late StreamController<int> _controller;

  Stream<int> get stream => _controller.stream;

  bool get isRunningPomo => _isRunningPomo;
  bool get isRunningShort => _isRunningShort;
  bool get isRunningLong => _isRunningLong;

  Future<void> playAlarm() async {
    await audioPlayer.play(AssetSource("alarm.wav"), volume: 100);
  }

  void start(int duration) {
    _duration = duration;
    switch (_duration) {
      case 0:
        _isRunningPomo = false;
        _isRunningShort = false;
        _isRunningLong = false;
        break;
      case 1500:
        _isRunningPomo = true;
        break;
      case 300:
        _isRunningShort = true;
        break;
      case 900:
        _isRunningLong = true;
        break;
      default:
        _isRunningPomo = false;
        _isRunningShort = false;
        _isRunningLong = false;
    }
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_duration == 1400) {
        timer.cancel();
        _controller.add(0);
        _duration = 0;
        _isRunningPomo = false;
        _isRunningShort = false;
        _isRunningLong = false;
        await playAlarm();
      } else {
        _duration--;
        _controller.add(_duration);
      }
    });
  }

  void reset() {
    _isRunningPomo = false;
    _isRunningShort = false;
    _isRunningLong = false;
    _duration = 0;
    _controller.add(0);
    if (_controller.isClosed) {
      _controller = StreamController<int>.broadcast(
        onListen: () {
          if (_isRunningPomo || _isRunningShort || _isRunningLong) {
            start(_duration);
          }
        },
      );
    }
  }
}
