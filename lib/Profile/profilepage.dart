import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  List<String> names = []; // Updated to List<String>

  Future<void> fetchName() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
      List<String> values = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        names = values;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchName();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.orangeAccent,
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              names.isNotEmpty ? names[0] : 'No Name', // Use first name or default
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'surumi@gmail.com', // You might want to change this to dynamic email fetching
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                        },
                        title: Text("About"),
                      ),
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'For Her is a user-friendly e-commerce application dedicated to offering a wide range of beauty products tailored for women. The app provides a seamless shopping experience, featuring top-quality skincare, makeup, haircare, and wellness products from trusted brands. Designed with simplicity and convenience in mind, For Her allows users to easily browse, search, and shop for their favorite beauty essentials. Whether you’re looking for the latest trends or everyday must-haves, For Her brings the world of beauty right to your fingertips.',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
