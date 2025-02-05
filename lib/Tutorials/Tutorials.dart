import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_her/Core/utilities.dart';
import 'package:url_launcher/url_launcher.dart';

class Tutorials extends StatefulWidget {
  const Tutorials({super.key});

  @override
  State<Tutorials> createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {
  TextEditingController search = TextEditingController();
  List<QueryDocumentSnapshot> availableCategories = [];
  List<QueryDocumentSnapshot> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    FirebaseFirestore.instance.collection('youtube').snapshots().listen((snapshot) {
      setState(() {
        availableCategories = snapshot.docs;
        filteredCategories = availableCategories; // Initially show all
      });
    });
  }

  void filterCategory(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCategories = availableCategories;
      } else {
        filteredCategories = availableCategories.where((doc) {
          String category = doc['ProductName'].toString().toLowerCase();
          return category.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> openYoutube(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: search,
              onChanged: filterCategory,
              cursorColor: Color(0xff7b0001),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xff7b0001)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xff7b0001)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: filteredCategories.isEmpty
                  ? Center(child: Text("No results found"))
                  : GridView.builder(
                shrinkWrap: true,
                itemCount: filteredCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 200.0,
                ),
                itemBuilder: (context, index) {
                  final snap = filteredCategories[index];
      
                  return Column(
                    children: [
                      Container(
                        height: 160,
                        width: 400,
                        decoration: BoxDecoration(
                          color:pur,
                          image: DecorationImage(
                            image: NetworkImage(snap['image']),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            String youtubeUrl = snap['Url'];
                            if (youtubeUrl.isNotEmpty) {
                              await openYoutube(youtubeUrl);
                            } else {
                              print("YouTube URL not found");
                            }
                          },
                          icon: Icon(
                            Icons.play_circle_fill,
                            size: 35,
                            color:Red,
                          ),
                        ),
                      ),
                      Text(snap['ProductName']),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
