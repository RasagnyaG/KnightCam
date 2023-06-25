// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:ami_frontend/widgets/Image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/SignIn.dart';
import '../Services/dataProvider.dart';

// ignore: non_constant_identifier_names
final Namecontroller = TextEditingController();
// ignore: non_constant_identifier_names
final Rollcontroller = TextEditingController();
// ignore: non_constant_identifier_names
final Numbercontroller = TextEditingController();

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DataProvider>();
    final user = prov.user_data;
    var friends = prov.friends;
    var rolls = friends['fRollNo'];
    var numbers = friends['fPhNo'];
    var names = friends['fName'];

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(user['name'])),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: rolls.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: const Color.fromRGBO(237, 237, 237, 1),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                          leading: CustomImageButton(onPressed: () {}),
                          title: Center(
                              child: Text(
                            names[index],
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            onPressed: () => {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        child: AlertDialog(
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          title: const Text(
                                            "Edit Contact",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                NameInputWidget(),
                                                RollInputWidget(),
                                                NumberInputWidget(),
                                              ]),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  var edited_data = friends;
                                                  var name =
                                                      Namecontroller.text;
                                                  var number =
                                                      Numbercontroller.text;
                                                  var roll =
                                                      Rollcontroller.text;

                                                  if (name != '') {
                                                    edited_data['fName']
                                                            [index] =
                                                        name.toString();
                                                  }
                                                  if (number != '') {
                                                    edited_data['fPhNo']
                                                            [index] =
                                                        number.toString();
                                                  }
                                                  if (roll != '') {
                                                    edited_data['fRollNo']
                                                            [index] =
                                                        roll.toString();
                                                  }

                                                  if (!(name == '' &&
                                                      number == '' &&
                                                      roll == '')) {
                                                    await context
                                                        .read<DataProvider>()
                                                        .editFriend({
                                                      'rollNo': user['rollNo'],
                                                      'frndData': edited_data
                                                    });

                                                    Navigator.pop(context);
                                                  } else {
                                                    const Text(
                                                        'All fields cannot be empty',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.red));
                                                  }
                                                },
                                                child: const Text("Submit")),
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Cancel"))
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                            },
                          )),
                    ),
                  );
                },
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _pressed = true;
                    });
                    if (rolls.length < 3) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Container(
                                child: AlertDialog(
                                  actionsAlignment: MainAxisAlignment.center,
                                  title: const Text(
                                    "Add Friend",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        NameInputWidget(),
                                        RollInputWidget(),
                                        NumberInputWidget(),
                                      ]),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          if (rolls.length < 3) {
                                            await context
                                                .read<DataProvider>()
                                                .addFriend({
                                              'rollNo': user['rollNo'],
                                              'fName': Namecontroller.text,
                                              'fRollNo': Rollcontroller.text,
                                              'fPhNo': Numbercontroller.text
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Submit")),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel")),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Friend')),
              if (rolls.length == 3 && _pressed)
                const Text('You can only add 3 friends',
                    style: TextStyle(fontSize: 18, color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }

  Widget NameInputWidget() => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 13),
        child: TextField(
          controller: Namecontroller,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            label: const Text("Name", style: TextStyle(fontSize: 16)),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Namecontroller.clear(),
            ),
            contentPadding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
          ),
          textInputAction: TextInputAction.done,
        ),
      );

  Widget RollInputWidget() => Padding(
        padding: const EdgeInsets.only(top: 13, bottom: 13),
        child: TextField(
          controller: Rollcontroller,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            label: const Text("Roll No.", style: TextStyle(fontSize: 16)),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Rollcontroller.clear(),
            ),
            contentPadding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
          ),
          textInputAction: TextInputAction.done,
        ),
      );

  Widget NumberInputWidget() => Padding(
        padding: const EdgeInsets.only(top: 13),
        child: Column(
          children: [
            TextField(
              controller: Numbercontroller,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                label: const Text("Number", style: TextStyle(fontSize: 16)),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Numbercontroller.clear(),
                ),
                contentPadding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      );
}
