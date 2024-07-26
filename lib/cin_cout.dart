import 'package:flutter/material.dart';
import 'todayscreen.dart';

class CinCout extends StatefulWidget {
  const CinCout({super.key});

  @override
  State<CinCout> createState() => _CinCoutState();
}

class _CinCoutState extends State<CinCout> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar:
        AppBar(
          leading:
            IconButton(onPressed:(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>todayscreen()));
      },
          icon: Icon(Icons.navigate_before)
            ),
          actions: const <Widget>[
            SizedBox(width: 40,)
          ],

          title: Container(
            margin: const EdgeInsets.only(left: 30),
            child: const Text('Check In & Out',
            style: TextStyle(
              fontFamily: 'Nexa_bold',
            ),),
          ),
        ),
        body: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
