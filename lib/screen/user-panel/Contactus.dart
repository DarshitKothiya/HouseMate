import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact US",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () async {
                    Uri uri = Uri.parse("tel:+918154992498");
                    try {
                      await launchUrl(uri);
                    } catch (e) {
                      print("==========================");
                      print(e);
                      print("==========================");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Can't possible due to $e"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(width: 10,),
                Text("+91 8154992498",style: TextStyle(fontSize: 18),),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.email),
                  onPressed: () async {
                    String email = "kajavadrameet@gmail.com";
                    Uri uri = Uri.parse("mailto:${email}?subject=Heading&body=Test");
                    try {
                      await launchUrl(uri);
                    } catch (e) {
                      print("==========================");
                      print(e);
                      print("==========================");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Can't possible due to $e"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(width: 10,),
                Text("kajavadrameet@gmail.com",style: TextStyle(fontSize: 18),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
