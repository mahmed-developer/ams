import 'dart:async';
import 'package:ams/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class todayscreen extends StatefulWidget {
  const todayscreen({Key? key}) : super(key: key);

  @override
  State<todayscreen> createState() => _todayscreenState();
}

class _todayscreenState extends State<todayscreen> {
  String cText = "Slide to Check In";
  String cDate = "";
  String cOutDate = "";
  bool _isCheckedIn = false;
  bool _isCheckedOut = false;
  bool _isDayDone = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<SlideActionState> _slideKey = GlobalKey();
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startClockTimer();
    _resetDailyDataIfNeeded();
    _loadSavedData();
  }

  void _startClockTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _storeAttendanceData(String action) async {
    String date = DateFormat('dd MMMM yyyy').format(DateTime.now());
    String time = DateFormat('hh:mm a').format(DateTime.now());
    String day = DateFormat('EEEE').format(DateTime.now());
    String username = Users.userName;

    String docId = '${username}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}';

    await _firestore.collection('attendance').doc(docId).set({
      'username': username,
      'date': date,
      'day': day,
      'check_in_time': action == 'Check In' ? time : cDate,
      'check_out_time': action == 'Check Out' ? time : cOutDate,
    }, SetOptions(merge: true));
  }

  Future<void> _loadSavedData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      cDate = sp.getString('check_in_time') ?? "";
      cOutDate = sp.getString('check_out_time') ?? "";
      _isDayDone = sp.getBool('is_day_done') ?? false;
      _isCheckedIn = cDate.isNotEmpty && cOutDate.isEmpty;
      _isCheckedOut = cOutDate.isNotEmpty;
      cText = _isCheckedIn ? "Slide to Check Out" : "Slide to Check In";
    });
  }

  Future<void> _saveToPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('check_in_time', cDate);
    sp.setString('check_out_time', cOutDate);
    sp.setBool('is_day_done', _isDayDone);
    sp.setString('last_check_in_date', DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  Future<void> _resetDailyDataIfNeeded() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? lastCheckInDate = sp.getString('last_check_in_date');
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastCheckInDate == null || lastCheckInDate != todayDate) {
      await sp.remove('check_in_time');
      await sp.remove('check_out_time');
      await sp.remove('is_day_done');
      await sp.setString('last_check_in_date', todayDate);
      setState(() {
        cDate = "";
        cOutDate = "";
        _isCheckedIn = false;
        _isCheckedOut = false;
        _isDayDone = false;
        cText = "Slide to Check In";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 6, right: 5),
                        child: const Text(
                          "Welcome",
                          style: TextStyle(
                            fontFamily: 'Nexa_bold',
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 6, right: 5),
                        child: Text(
                          "Employee ${Users.userName}",
                          style: const TextStyle(
                            fontFamily: 'Nexa_bold',
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: DateFormat('dd').format(DateTime.now()),
                              style: const TextStyle(
                                fontFamily: 'Nexa_reg',
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            DateFormat('MMMM yyyy').format(DateTime.now()),
                            style: const TextStyle(
                              fontFamily: 'Nexa_reg',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat('hh:mm a').format(_currentTime),
                        style: const TextStyle(
                          fontFamily: 'Nexa_bold',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: const Text(
                  "Today's Status",
                  style: TextStyle(
                    fontFamily: 'Nexa_bold',
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                height: 140,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 10,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Check In",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Nexa_reg',
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            cDate.isNotEmpty ? cDate : "Not Checked In",
                            style: TextStyle(
                              fontSize: cDate.isEmpty ? 15 : 20,
                              fontFamily: 'Nexa_reg',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Check Out",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Nexa_reg',
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            cOutDate.isNotEmpty ? cOutDate : "Not Checked Out",
                            style: TextStyle(
                              fontSize: cOutDate.isEmpty ? 15 : 20,
                              fontFamily: 'Nexa_reg',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                child: _isDayDone
                    ? const Text(
                  "Completed for the Day!",
                  style: TextStyle(
                    fontFamily: 'Nexa_reg',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                )
                    : Builder(
                  builder: (context) {
                    return SlideAction(
                      key: _slideKey,
                      text: cText,
                      textStyle: const TextStyle(
                        fontFamily: 'Nexa_reg',
                        color: Colors.black54,
                      ),
                      outerColor: Colors.white,
                      innerColor: Colors.red.shade700,
                      onSubmit: () async {
                        setState(() {
                          if (!_isCheckedIn) {
                            cDate = DateFormat('hh:mm a').format(DateTime.now());
                            _isCheckedIn = true;
                            cText = "Slide to Check Out";
                            cOutDate = "";
                            _storeAttendanceData("Check In");
                          } else {
                            cOutDate = DateFormat('hh:mm a').format(DateTime.now());
                            _isCheckedIn = false;
                            _isCheckedOut = true;
                            cText = "Slide to Check In";
                            _storeAttendanceData("Check Out");
                          }

                          if (_isCheckedOut) {
                            _isDayDone = true;
                            _saveToPreferences();
                          }
                        });

                        // Reset the SlideAction widget after submission
                        await Future.delayed(const Duration(seconds: 1));
                        _slideKey.currentState?.reset();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}