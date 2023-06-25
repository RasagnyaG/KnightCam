// ignore_for_file: use_build_context_synchronously

import 'package:ami_frontend/Pages/contacts.dart';
import 'package:ami_frontend/widgets/Image.dart';
import 'package:ami_frontend/widgets/drawer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:torch_light/torch_light.dart';
import 'dart:async';

import '../Services/SignIn.dart';
import '../Services/dataProvider.dart';

final messageController = TextEditingController();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _clicks = 0;
  String err = '';

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<DataProvider>(context, listen: false);
    final user = prov.user_data;
    final google = Provider.of<SignIn>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: (_clicks >= 3)
          ? const Color.fromRGBO(168, 64, 64, 1)
          : const Color.fromRGBO(224, 224, 224, 1),
      appBar: AppBar(
        title: Text(
          user?['name'],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomImageButton(
                url: google.user?.photoUrl, onPressed: () {}, size: 30),
          )
        ],
      ),
      drawer: const DrawerMenu(),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (_clicks < 3)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: Text("EMERGENCY HELP NEEDED?",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                      const SizedBox(height: 10),
                      Text("Tap the button thrice",
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 80),
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(187, 0, 0, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(181, 175, 175, 0.5),
                                blurRadius: 10,
                                spreadRadius: 13,
                              ),
                            ]),
                        child: IconButton(
                          padding: const EdgeInsets.all(20),
                          color: const Color.fromRGBO(187, 0, 0, 1),
                          iconSize: 100,
                          icon: Text(
                              (_clicks == 0) ? "SOS" : (3 - _clicks).toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white)),
                          onPressed: () async {
                            setState(() {
                              _clicks = _clicks + 1;
                            });
                            if (_clicks >= 3) {
                              final position = await _GetPosition();
                              if (position['success']) {
                                context.read<DataProvider>().log({
                                  'rollNo': user['rollNo'],
                                  'lat': position['pos'].latitude.toString(),
                                  'long': position['pos'].longitude.toString()
                                });
                              } else {
                                setState(() {
                                  err = position['msg'];
                                  _clicks = 0;
                                });
                              }

                              final Uri url = Uri.parse(
                                  'tel:${user['frndData']['fPhNo'][0]}');
                              if (!await launchUrl(url)) {
                                throw 'Could not launch $url';
                              }
                            }
                          },
                        ),
                      ),
                      if (err != '')
                        Text(
                          err,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.red),
                        )
                    ],
                  ),
                if (_clicks >= 3 && err == '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Text("HELP ON ITS WAY",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.white)),
                      const SizedBox(height: 30),
                      TextField(
                        controller: messageController,
                        cursorColor: Colors.black,
                        style: const TextStyle(fontSize: 25),
                        maxLines: 4,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _clicks = 0;
                              });
                            },
                            icon: const Icon(Icons.send),
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Send A Message",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(10)),
                              textStyle: MaterialStateProperty.all(
                                  Theme.of(context).textTheme.bodyMedium),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(224, 224, 224, 1))),
                          onPressed: () {
                            setState(() {
                              _clicks = 0;
                            });
                          },
                          child: const Text(
                            'Go Back',
                            style: TextStyle(color: Colors.black),
                          )),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              iconSize: 70,
                              onPressed: () {
                                _sosSound();
                              },
                              icon:
                                  const Icon(Icons.notifications_active_sharp)),
                          IconButton(
                              iconSize: 70,
                              onPressed: () {
                                _sosTorch();
                              },
                              icon: const Icon(Icons.highlight_sharp))
                        ],
                      )
                    ],
                  ),
                const Spacer(),
                if (_clicks < 3)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomImageButton(onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ContactsPage()),
                            );
                          }),
                          CustomImageButton(onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ContactsPage()),
                            );
                          }),
                          CustomImageButton(onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ContactsPage()),
                            );
                          })
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

// ignore: non_constant_identifier_names
Future<Map<String, dynamic>> _GetPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    if (!(await Geolocator.isLocationServiceEnabled())) {
      return {
        'success': false,
        'msg': 'Locations services are disabled. Could not get the coordinates'
      };
    }
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return {
        'success': false,
        'msg':
            'Locations permissions are disabled. Could not get the coordinates'
      };
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return {
      'success': false,
      'msg':
          'Location permissions are permanently denied, we cannot request permissions.'
    };
  }

  final coords = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  return {
    'success': true,
    'msg': 'Successfully got coordinates',
    'pos': coords
  };
}

Future<void> _sosTorch() async {
  try {
    final isTorchAvailable = await TorchLight.isTorchAvailable();
  } on Exception catch (_) {
    return;
  }
  try {
    await TorchLight.enableTorch();
    await TorchLight.disableTorch();
    await TorchLight.enableTorch();
    await TorchLight.disableTorch();
    await TorchLight.enableTorch();
    await TorchLight.disableTorch();

    await TorchLight.enableTorch();
    await TorchLight.disableTorch();
    Future.delayed(const Duration(seconds: 2), () async {
      await TorchLight.enableTorch();
      await TorchLight.disableTorch();
    });
    Future.delayed(const Duration(seconds: 2), () async {
      await TorchLight.enableTorch();
      await TorchLight.disableTorch();
    });
    Future.delayed(const Duration(seconds: 2), () async {
      await TorchLight.enableTorch();
      await TorchLight.disableTorch();
    });

    Timer mytimer =
        Timer.periodic(const Duration(milliseconds: 25), (timer) async {
      await TorchLight.enableTorch();
      await TorchLight.disableTorch();
    });

    Timer(Duration(seconds: 3), () {
      mytimer.cancel();
    });
  } on Exception catch (_) {
    print(_);
  }
}

Future<void> _sosSound() async {
  AudioPlayer player = AudioPlayer();
  const alarmAudioPath = "sos.mp3";
  await player.play(AssetSource(alarmAudioPath));
}
