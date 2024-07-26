
import 'dart:async';

import 'package:ams/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {


  var cText = "";
  bool _isCheckedIn=false;
  void _toggleCheckIn(){
    setState(() {
      _isCheckedIn = !_isCheckedIn;
      cText = _isCheckedIn ? "Check In" : "Check out";
    });
  }


  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    _startClockTimer();
  }
  void _startClockTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (DateTime.now().second == 0) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: screenHeight/3,
                width: screenWidth,
                padding: EdgeInsets.only(top: screenHeight/20,),
                child:  Column(
                  children: [
                    Text("Welcome ${Users.userName} ",textAlign: TextAlign.right
                      ,style: const TextStyle(
                        fontFamily: 'Nexa_bold',
                        fontSize: 15,
                        color: Colors.black,),
                    ),
                    Text("Mark Your Attandence",
                      style: const TextStyle(
                        fontFamily: 'Nexa_bold',
                        fontSize: 18,
                        color: Colors.black,),),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.red.shade700
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  height: screenHeight/3,
                  width: screenWidth/1.1,
                  child: Center(
                    child: Column(
                      children: [
                        Text(DateFormat('hh:mm a').format(_currentTime),
                          style: const TextStyle(
                            fontFamily: 'Nexa_bold',
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('MMMM d, y -E').format(DateTime.now()),
                          style: const TextStyle(
                            fontFamily: 'Nexa_reg',
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight/4.5,
                right: screenWidth/3.3,
                child: Center(
                  child: GestureDetector(
                    onTap: _toggleCheckIn,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.touch_app),
                            Text(cText),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
