import 'package:noise_meter/noise_meter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(new AudioRecord());
}

class AudioRecord extends StatefulWidget {
  @override
  _AudioRecordState createState() => new _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? _noiseMeter;
  double n = 0;

  @override
  void initState() {
    super.initState();
    _noiseMeter = new NoiseMeter(onError);
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    print(noiseReading.toString());
    n = noiseReading.meanDecibel - 40;
  }

  void onError(Object error) {
    print(error.toString());
    _isRecording = false;
  }

  void start() async {
    try {
      if (_noiseMeter != null) {
        _noiseSubscription = _noiseMeter?.noiseStream.listen(onData);
      }
    } catch (err) {
      print(err);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  List<Widget> getContent() => <Widget>[
        Container(
            margin: EdgeInsets.all(25),
            child: Column(children: [
              Container(
                child: Text(_isRecording ? "Mic: ON" : "Mic: OFF",
                    style: TextStyle(fontSize: 25, color: Colors.blue)),
                margin: EdgeInsets.only(top: 20),
              )
            ])),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n * 3,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n * 3.7,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n * 3.8,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n * 4.2,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n * 4,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: n,
                ),
              ],
            ),
          ],
        )
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getContent(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: _isRecording ? Colors.red : Colors.green,
            onPressed: _isRecording ? stop : start,
            child: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic)),
      ),
    );
  }
}
