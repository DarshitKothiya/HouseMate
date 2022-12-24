import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Divider(color: Colors.teal,),
            Divider(color: Colors.teal,),
            const Text('Home Service App',style: TextStyle(fontSize: 25,color: Colors.blue),),
            Divider(color: Colors.teal,),
            Divider(color: Colors.teal,),

            const SizedBox(height: 50),
            const Text("Home service app is mobile based application that is the perfect solution for us.We are in the 21st century and have tiny angels in our pockets that can help us manage all these boring home chores while we can go out and do things that need our critical consideration Our system manage from both angles, manage the worker list for admin and outsider man & show up worker to the customer at home place. Customer can view all kind of home services and workers with feedback from anywhere.",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.white),),
          ],
        ),
      ),
    );
  }
}
