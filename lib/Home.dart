import 'package:ams/CalendarScreen.dart';
import 'package:ams/ProfileScreen.dart';
import 'package:ams/todayscreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
List<IconData> navicons = [
  FontAwesomeIcons.calendar,
  FontAwesomeIcons.check,
  FontAwesomeIcons.user
];
int currentindex = 0;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentindex,
        children: const [
          Calendarscreen(),
          todayscreen(),
          Profilescreen()
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 10,
              )
            ],
            color: Colors.white),
        child: Row(
          children: [
            for (int i = 0; i < navicons.length; i++) ...<Expanded>{
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      currentindex=i;
                    });
                  },
                  child: Icon(navicons[i],
                  color: i == currentindex ? Colors.red.shade700 : Colors.black,
                    size: i==currentindex ? 30:26,
                  ),
                ),
              )
            }
          ],
        ),
      ),
    );
  }
}
