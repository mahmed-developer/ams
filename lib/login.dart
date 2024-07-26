import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ams/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  bool _isContainerVisible= true;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(_handleFocusChange);
    passwordFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_isContainerVisible && (emailFocusNode.hasFocus || passwordFocusNode.hasFocus)) {
      setState(() {
        _isContainerVisible = false;
      });
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        title: const Text(
          "Attendance Management System",
          style:
              TextStyle(fontFamily: 'Nexa', color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        // Added for scrollable content
        child: Column(
          children: [
            if(_isContainerVisible)
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
                color: Colors.red.shade700,
              ),
              height: screenHeight / 3,
              width: screenWidth,
              margin: const EdgeInsets.only(bottom: 20),
              child: const Center(
                // Center the icon vertically and horizontally
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            // Login Text
            const Text(
              "Login",
              style: TextStyle(
                fontFamily: 'Nexa',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 30),
            // Stack with Email-ID Text and TextFormField
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  // Positioned Email-ID Text (corrected positioning)
                  const Positioned(
                    top: -5, // Adjusted for better alignment
                    left: 40, // Adjusted for better spacing
                    child: Text(
                      "Email-ID:",
                      style: TextStyle(
                        fontFamily: 'Nexa',
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  // TextFormField with Icon
                  Align(
                    // Improved alignment for better responsiveness
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 20.0), // Adjusted top margin
                      child: Row(
                        children: [
                          Icon(Icons.email,
                              size: 35, color: Colors.red.shade700),
                          const SizedBox(
                              width:
                                  5), // Add some space between the icon and text field
                          Expanded(
                            child: TextFormField(
                              controller: emailcontroller,
                              focusNode: emailFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                disabledBorder: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  // Positioned Password Text (improved positioning)
                  const Positioned(
                    top: -5, // Adjusted for better alignment
                    left: 40, // Adjusted for better spacing
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontFamily: 'Nexa',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Align(
                    // Improved alignment for better responsiveness
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 20.0), // Adjusted top margin
                      child: Row(
                        children: [
                          Icon(Icons.lock,
                              size: 35,
                              color: Colors.red
                                  .shade700), // Use Icons.lock for password field
                          const SizedBox(
                              width:
                                  5), // Add some space between the icon and text field
                          Expanded(
                            child: TextFormField(
                              obscureText: true, // Make password field hidden
                              controller: passcontroller,
                              focusNode: passwordFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Enter your password',
                                disabledBorder: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 7),
              child: GestureDetector(
                onTap: () async {
                  String emailid = emailcontroller.text.trim();
                  String pass = passcontroller.text.trim();
                  if (emailid.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email is Empty')));
                  } else if (pass.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password is Empty")));
                  } else {
                    QuerySnapshot snap = await FirebaseFirestore.instance
                        .collection("Students")
                        .where('email', isEqualTo: emailid)
                        .get();
                    try {
                      if (pass == snap.docs[0]['password']) {
                        SharedPreferences sp= await SharedPreferences.getInstance();
                        sp.setString('emailidsp', emailid).then((_){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Password is incorrect!")));
                      }
                    } catch (e) {
                      print(e.toString());
                      if(e.toString()=="RangeError (index): Invalid value: Valid value range is empty: 0"){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text("Invalid ID!")));
                      }
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: Container(
                  width: screenWidth / 2,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red.shade700,
                  ),
                  child: const Center(
                    child: Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Nexa_bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Add login button or other form elements here
          ],
        ),
      ),
    );

    //   Scaffold(
    //   body: Column(
    //     children: [
    //       Container(
    //         decoration: const BoxDecoration(
    //           borderRadius: BorderRadius.only(
    //             bottomRight: Radius.circular(50),
    //           ),
    //           color: Colors.red,
    //         ),
    //         height: screenHeight / 3,
    //         width: screenWidth,
    //         margin: const EdgeInsets.only(bottom: 20),
    //         child: const Icon(
    //           Icons.person,
    //           size: 50,
    //           color: Colors.white,
    //         ),
    //       ),
    //       // Login Text
    //       const Text(
    //         "Login",
    //         style: TextStyle(
    //           fontFamily: 'Roboto',
    //           fontWeight: FontWeight.bold,
    //           fontSize: 25,
    //         ),
    //       ),
    //       // Email-ID Text
    //       Container(
    //         padding: const EdgeInsets.only(top: 30, bottom: 10),
    //         margin: EdgeInsets.only(right: screenWidth / 1.2),
    //         child: const Text(
    //           "Email-ID:",
    //           textAlign: TextAlign.left,
    //           style: TextStyle(
    //             fontFamily: 'Roboto',
    //             fontWeight: FontWeight.w400,
    //             fontSize: 17,
    //           ),
    //         ),
    //       ),
    //       // Row with Icon and TextFormField
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //         child: Row(
    //           children: [
    //             const Icon(Icons.email),
    //             const SizedBox(width: 10), // Add some space between the icon and text field
    //             Expanded(
    //               child: TextFormField(
    //                 decoration: const InputDecoration(
    //                   hintText: 'Enter your email',
    //                   disabledBorder: InputBorder.none,
    //                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10),)),
    //                   border: InputBorder.none,
    //                 ),
    //
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Container(
    //         padding: const EdgeInsets.only(top: 30, bottom: 10),
    //         margin: EdgeInsets.only(right: screenWidth / 1.25),
    //         child: const Text(
    //           "Password:",
    //           textAlign: TextAlign.left,
    //           style: TextStyle(
    //             fontFamily: 'Roboto',
    //             fontWeight: FontWeight.w400,
    //             fontSize: 17,
    //           ),
    //         ),
    //       ),
    //       // Row with Icon and TextFormField
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //         child: Row(
    //           children: [
    //             const Icon(Icons.password),
    //             const SizedBox(width: 10), // Add some space between the icon and text field
    //             Expanded(
    //               child: TextFormField(
    //                 decoration: const InputDecoration(
    //                   hintText: 'Enter your Password',
    //                   disabledBorder: InputBorder.none,
    //                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10),)),
    //                   border: InputBorder.none,
    //                 ),
    //
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //         Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //         child:Column(
    //           children: [
    //             TextButton(onPressed: , child: child)
    //           ],
    //         ),
    //         ),
    //     ],
    //   ),
    // );
  }
}
// Scaffold(
// body: Column(
// children: [
// Container(
// decoration: const BoxDecoration(
// borderRadius: BorderRadius.only(
// bottomRight: Radius.circular(50),
// ),
// color: Colors.red,
// ),
// height: screenHeight / 3,
// width: screenWidth,
// margin: const EdgeInsets.only(bottom: 20),
// child: const Icon(
// Icons.person,
// size: 50,
// color: Colors.white,
// ),
// ),
// // Login Text
// const Text(
// "Login",
// style: TextStyle(
// fontFamily: 'Roboto',
// fontWeight: FontWeight.bold,
// fontSize: 25,
// ),
// ),
// const SizedBox(height: 30),
// // Stack with Email-ID Text and TextFormField
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Stack(
// children: [
// // Positioned Email-ID Text
// const Positioned(
// top:-5,
// left: 42,
// child: Text(
// "Email-ID:",
// style: TextStyle(
// fontFamily: 'Roboto',
// fontWeight: FontWeight.w400,
// fontSize: 18,
// ),
// ),
// ),
// // TextFormField with Icon
// Container(
// margin: const EdgeInsets.only(top: 20),
// child: Row(
// children: [
// const Icon(Icons.email,size: 35,color: Colors.red,),
// const SizedBox(width: 5), // Add some space between the icon and text field
// Expanded(
// child: TextFormField(
// decoration: const InputDecoration(
// hintText: 'Enter your email',
// disabledBorder: InputBorder.none,
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(10)),
// ),
// border: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(10)),
// ),
// ),
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// ),
// const SizedBox(height: 20,),
// Padding
// (padding:const EdgeInsets.all(8.0),
// child: Stack(
// children: [ const Positioned(
// top:0,
// bottom:0,
// child: Text("Password",style: TextStyle(
// fontFamily: 'Roboto',
// fontWeight: FontWeight.w400,
// fontSize: 18,
// ),
// ),
// ),
// Container(
// margin: const EdgeInsets.only(top: 20),
// child: Row(
// children: [
// const Icon(Icons.email,size: 35,color: Colors.red),
// const SizedBox(width: 5),
// Expanded(
// child: TextFormField(
// decoration: const InputDecoration(
// hintText: 'Enter your email',
// disabledBorder: InputBorder.none,
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(10)),
// ),
// border: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(10)),
// ),
// ),
// ),
// ),
// ),
// ),
// ],
// ),
// ),
