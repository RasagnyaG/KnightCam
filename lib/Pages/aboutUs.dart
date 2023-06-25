import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "About Us",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 30),
              Text(
                "Lorem ipsum dolor sit amet consectetur adipisicing elit. Beatae qui harum, odio a itaque voluptatem laudantium reprehenderit ratione consectetur optio sit perferendis, laborum ex ut voluptatibus totam aperiam minima praesentium asperiores deleniti ipsam magni, pariatur saepe voluptates? Unde quo, quaerat iste quos laborum possimus qui nesciunt, modi velit, voluptate magni. Laboriosam deleniti, similique",
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
