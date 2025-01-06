import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String name = 'No Name';
  String email = 'No Email';

  Future<void> fetchUserData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there is at least one user document with the matching email
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          name = userData['name'] ?? 'No Name';
          email = userData['email'] ?? 'No Email';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List images=[];
  Future fetchimages()async{
    try{
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Users')
          .where('email',isEqualTo: FirebaseAuth.instance.currentUser!.email).get();
      List values = querySnapshot.docs.map((doc)=> doc['image']).toList();
      setState(() {
        images = values;
      });
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchimages();
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
                            backgroundImage:NetworkImage(images[0]),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              email,
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
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 10),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                            },
                            title: Text("About"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 10),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Privacy(mdFilename: 'privacy&policy.md',)));
                            },
                            title: Text("Privacy Policy"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 10),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Terms(mdFilename: 'terms.md',)));
                            },
                            title: Text("Terms and Conditions"),
                          ),
                        ),
                      ),
                    ],
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
        body:Dialog(
          elevation:20,
          shadowColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'For Her is a user-friendly e-commerce application dedicated to offering a wide range of beauty products tailored for women. The app provides a seamless shopping experience, featuring top-quality skincare, makeup, haircare, and wellness products from trusted brands. Designed with simplicity and convenience in mind, For Her allows users to easily browse, search, and shop for their favorite beauty essentials. Whether you’re looking for the latest trends or everyday must-haves, For Her brings the world of beauty right to your fingertips.',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

class Privacy extends StatefulWidget {
  final String mdFilename;
  const Privacy({super.key, required this.mdFilename});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                future: Future.delayed(const Duration(microseconds: 150))
                    .then((value) => rootBundle.loadString('lib/Profile/privacy&policy.md')),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                        styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                            textTheme: const TextTheme(
                                bodyMedium: TextStyle(
                                    fontSize: 15.0, color: Colors.black)))),
                        data: snapshot.data.toString());
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Terms extends StatelessWidget {
  Terms({super.key, this.radius = 8, required this.mdFilename})
      : assert(
  mdFilename.contains('.md'), 'The file must contain .md extension');
  final double radius;
  final String mdFilename;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                future: Future.delayed(const Duration(microseconds: 150))
                    .then((value) => rootBundle.loadString('lib/Profile/terms&condition.md')),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                        styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                            textTheme: const TextTheme(
                                bodyMedium: TextStyle(
                                    fontSize: 15.0, color: Colors.black)))),
                        data: snapshot.data.toString());
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
