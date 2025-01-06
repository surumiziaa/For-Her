import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:for_her/CheckOut/Singlecheckout.dart';
import 'package:readmore/readmore.dart';

class Cartview extends StatefulWidget {
  const Cartview({super.key});

  @override
  State<Cartview> createState() => _CartviewState();
}

class _CartviewState extends State<Cartview> {

  late List<Widget> pages = [];
  int imglength = 3;
  int currentpage = 0;
  final PageController pageController = PageController();
  Timer? _timer;
  bool iscart = false;



  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    void StartTimer() {
      _timer = Timer.periodic(Duration(seconds: 3), (timer) {
        if (pageController.page == args['image'].length - 1) {
          pageController.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        } else {
          pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        }
      });
    }
    StartTimer();

    pages = List.generate(
      args['image'].length,
          (index) => ClipRRect(
        child: Image(
          image: NetworkImage(args['image'][index],),
          fit: BoxFit.cover,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async{
              },
            icon: Icon(
              Icons.favorite,
              color:Color(0xff7b0001) ,
                  //: Colors.grey,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width:double.infinity,
                  height:MediaQuery.of(context).size.height/2.1,
                  child: PageView.builder(
                    allowImplicitScrolling: false,
                    physics: NeverScrollableScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        currentpage = value;
                      });
                    },
                    itemCount: args['image'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return pages[index];
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                            (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () {
                              pageController.animateToPage(index,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            },
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: currentpage == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹ ${args['Price'].toString()} /-',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        args['ProductName'],
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${args['Rating']}/5',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      Row(
                        children: List.generate(
                          5,
                              (index) => Icon(Icons.star, color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ReadMoreText(
                    args['Description'],
                    style: TextStyle(
                        color: Colors.black26, fontSize: 16, height: 1.5),
                    trimMode: TrimMode.Line,
                    trimLines: 4,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BottomSheet(
        dragHandleSize: Size(400, 200),
        elevation: 100,
        backgroundColor: Colors.white10,
        builder: (context) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              minWidth: 100,
              color: Color(0xff8a92cd),
              onPressed: ()async{
                await FirebaseFirestore.instance.collection('Cart').doc(args['cartId']).delete();
                Navigator.pop(context);
              },
              child: Text('Remove'),
            ),
            MaterialButton(
              minWidth: 100,
              color: Color(0xff8a92cd),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Buynow()));
              },
              child: Text('Buy Now'),
            ),
          ],
        ),
        onClosing: () {},
      ),
    );
  }

  buildIndicator() {
    return Row(
      children: [
        for (int i = 0; i < imglength; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: i == currentpage ? 7 : 5,
              width: i == currentpage ? 7 : 5,
              decoration: BoxDecoration(
                  color: i == currentpage ? Colors.black : Colors.grey,
                  shape: BoxShape.circle),
            ),
          )
      ],
    );
  }
}
