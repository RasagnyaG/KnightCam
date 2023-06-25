// ignore_for_file: use_build_context_synchronously

import 'package:ami_frontend/Pages/aboutUs.dart';
import 'package:ami_frontend/Pages/contacts.dart';
import 'package:ami_frontend/Pages/signin.dart';
import 'package:ami_frontend/widgets/Image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../Services/SignIn.dart';
import '../Services/dataProvider.dart';

final NameEditcontroller = TextEditingController();
final NumberEditcontroller = TextEditingController();

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DataProvider>();
    final user = prov.user_data;
    final google = Provider.of<SignIn>(context, listen: false);
    return Drawer(
      child: Material(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 255,
              child: DrawerHeader(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(168, 64, 64, 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CustomImageButton(
                        url: google.user?.photoUrl,
                        onPressed: () {},
                        size: 30,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              user['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
            Card(
              color: const Color.fromRGBO(237, 237, 237, 1),
              child: ListTile(
                title: Center(
                    child: Text(
                  'Contacts',
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactsPage()),
                  );
                },
              ),
            ),
            Card(
              color: const Color.fromRGBO(237, 237, 237, 1),
              child: ListTile(
                title: Center(
                    child: Text(
                  'About Us',
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage()),
                  );
                },
              ),
            ),
            Card(
              color: const Color.fromRGBO(237, 237, 237, 1),
              child: ListTile(
                title: Center(
                    child: Text(
                  'Log Out',
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
                onTap: () async {
                  await GoogleSignIn().disconnect();
                  FirebaseAuth.instance.signOut();
                  await context.read<DataProvider>().logout();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SigninPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget NameEditInput() => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 13),
      child: TextField(
        controller: NameEditcontroller,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          label: const Text("Name", style: TextStyle(fontSize: 16)),
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => NameEditcontroller.clear(),
          ),
          contentPadding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
        ),
        textInputAction: TextInputAction.done,
      ),
    );

Widget NumberEditInput() => Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Column(
        children: [
          TextField(
            controller: NumberEditcontroller,
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              label: const Text("Number", style: TextStyle(fontSize: 16)),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => NumberEditcontroller.clear(),
              ),
              contentPadding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
