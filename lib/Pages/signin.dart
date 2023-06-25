// ignore_for_file: use_build_context_synchronously

import 'package:ami_frontend/Pages/home.dart';

import 'package:ami_frontend/Services/SignIn.dart';
import 'package:ami_frontend/Services/dataProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  String msg = '';
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white, padding: const EdgeInsets.all(10)),
              icon: const Image(
                image: AssetImage('assets/google_icon.png'),
                height: 30,
              ),
              label: const Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              onPressed: () async {
                final provider = Provider.of<SignIn>(context, listen: false);

                await provider.googleLogin();

                var user = provider.user;
                var roll = user?.email.substring(0, 8);

                var res = await data.signin({'rollNo': roll});

                if (data.signedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  ).then((val) => locPermissions());
                } else {
                  msg = res;
                }
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Do not have an account?",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 15)),
              TextButton(
                  onPressed: () async {
                    String? token = await FirebaseMessaging.instance.getToken();
                    final provider =
                        Provider.of<SignIn>(context, listen: false);

                    await provider.googleLogin();

                    var user = provider.user;
                    var roll = user?.email.substring(0, 8);
                    final res = await data.signup({
                      'rollNo': roll,
                      'name': user?.displayName,
                      'id': token
                    });

                    if (data.signedUp) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      ).then((val) => locPermissions());
                    } else {
                      msg = res;
                    }
                  },
                  child: const Text('SignUp'))
            ]),
            if (msg != '')
              Text(
                msg,
                style: const TextStyle(color: Colors.red, fontSize: 20),
              )
          ],
        ),
      ),
    );
  }
}

locPermissions() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    if (!(await Geolocator.isLocationServiceEnabled())) {
      return Future.error('Location services are disabled.');
    }
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
}
