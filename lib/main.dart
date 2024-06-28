import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartWatch Timer',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        hintColor: Colors.tealAccent,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode: mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  final WearMode mode;

  const TimerScreen({required this.mode, super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  int _count = 0;
  String _strCount = "00:00";
  String _status = "Start"; // Inicializamos con "Start"

  @override
  void initState() {
    _status = "Start"; // Aseguramos que inicie en "Start"
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAmbient = widget.mode == WearMode.ambient;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackground(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[900],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.timer,
                        size: 20,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _strCount,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isAmbient ? Colors.grey : Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (!isAmbient)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 65,
                          height: 20,
                          child: ElevatedButton.icon(
                            onPressed: _handleStartStop,
                            icon: Icon(
                              _status == "Start"
                                  ? Icons.play_arrow
                                  : _status == "Stop"
                                      ? Icons.pause
                                      : Icons.play_arrow,
                              size: 12,
                            ),
                            label: Text(
                              _status == "Start"
                                  ? "Start"
                                  : _status == "Stop"
                                      ? "Pause"
                                      : "Continue",
                              style: TextStyle(fontSize: 8),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.tealAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 55,
                          height: 20,
                          child: ElevatedButton.icon(
                            onPressed: _handleReset,
                            icon: Icon(Icons.refresh, size: 12),
                            label: Text(
                              "Reset",
                              style: TextStyle(fontSize: 8),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.tealAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.grey[900]!,
            Colors.black,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(height: 1, color: Colors.grey)),
                  SizedBox(width: 10),
                  Expanded(child: Container(height: 1, color: Colors.grey)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(height: 1, color: Colors.grey)),
                  SizedBox(width: 10),
                  Expanded(child: Container(height: 1, color: Colors.grey)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _handleStartStop() {
    if (_status == "Start") {
      _startTimer();
      setState(() {
        _status = "Stop"; 
      });
    } else if (_status == "Stop") {
      _timer.cancel();
      setState(() {
        _status = "Continue";
      });
    } else if (_status == "Continue") {
      _startTimer();
      setState(() {
        _status = "Stop"; 
      });
    }
  }

  void _handleReset() {
    _timer.cancel();
    setState(() {
      _count = 0;
      _strCount = "00:00";
      _status = "Start"; 
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int minute = _count ~/ 60;
        int second = _count % 60;
        _strCount =
            '${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
      });
    });
  }
}