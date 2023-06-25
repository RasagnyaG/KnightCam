import 'package:ami_frontend/Pages/home.dart';

import 'package:ami_frontend/Pages/signin.dart';
import 'package:ami_frontend/Services/SignIn.dart';

import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SigninPage()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(168, 169, 172, 1),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(130),
          child: Image(image: AssetImage('assets/appLogo.jpg')),
        ),
      ),
    );
  }
}
