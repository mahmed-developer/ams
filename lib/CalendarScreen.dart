import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ams/models/users.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calendarscreen extends StatefulWidget {
  const Calendarscreen({super.key});

  @override
  State<Calendarscreen> createState() => _CalendarscreenState();
}

class _CalendarscreenState extends State<Calendarscreen> {

  List<Map<String, dynamic>> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser().then((_) => _fetchData()); // Fetch data after getting the user
  }

  Future<void> getCurrentUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? email = sp.getString('emailidsp');
    if (email != null) {
      setState(() {
        Users.userName = email;
      });
    }
  }

  Future<void> _fetchData() async {
    String username = Users.userName;

    // Query Firestore to get all documents for the specified user
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection("attendance")
        .where("username", isEqualTo: username)
        .orderBy("date", descending: true) // Fetch in descending order
        .get();

    // Process and store the fetched data
    List<Map<String, dynamic>> records = snapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    setState(() {
      attendanceRecords = records;
    });
  }

  DateTime _parseDate(String dateString) {
    final DateFormat format = DateFormat('d MMMM yyyy');
    return format.parse(dateString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Records'),
      ),
      body: Users.userName == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("attendance")
            .where("username", isEqualTo: Users.userName)
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No attendance records found.'));
          }

          List<Map<String, dynamic>> attendanceRecords = snapshot.data!.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();

          return ListView.builder(
            itemCount: attendanceRecords.length,
            itemBuilder: (context, index) {
              var record = attendanceRecords[index];
              String checkInTime = record['check_in_time'] ?? "Not Checked In";
              String checkOutTime = record['check_out_time'] ?? "Not Checked Out";
              String date = record['date'] ?? "Unknown Date";

              DateTime parsedDate;
              try {
                parsedDate = _parseDate(date);
              } catch (e) {
                // Fallback in case of parsing error
                parsedDate = DateTime.now();
              }

              return Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                height: 140,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 10,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date: ${DateFormat('dd MMMM yyyy').format(parsedDate)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Nexa_reg',
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check In",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Nexa_reg',
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                checkInTime,
                                style: TextStyle(
                                  fontSize: 20,
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
                              Text(
                                "Check Out",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Nexa_reg',
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                checkOutTime,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Nexa_reg',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}