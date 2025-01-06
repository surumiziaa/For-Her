import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_her/AddtoCart/Cart.dart';
import 'package:for_her/CheckOut/Singlecheckout.dart';
import 'package:for_her/Wishlist/Wistlistpage.dart';
import 'package:readmore/readmore.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  bool iswish = false;
  bool iscart =false;

  late List<Widget> pages = [];
  int imglength = 3;
  int currentpage = 0;
  final PageController pageController = PageController();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  List<String> Quantity=['1','2','3','4','5','6','7','8','9','10'];
  String ?selected;



  List addresslist = [];
  List phonelist = [];
  Future fetchAddress() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('SingleAddress')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();
      List address = querySnapshot.docs.map((doc) => doc['address']).toList();
      List phone = querySnapshot.docs.map((doc) => doc['phone']).toList();
      setState(() {
        addresslist = address;
        phonelist = phone;
      });
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    fetchAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    //Wishlist

    Future addtoWishlist() async{

      try{
        await FirebaseFirestore.instance.collection('Wishlist').add({
          'ProductId':args['ProductId'],
          'ProductName': args['ProductName'],
          'image': args['image'],
          'Price': args['Price'],
          'Description': args['Description'],
          'Brand': args['Brand'],
          'Categories': args['Categories'],
          'Rating': args['Rating'],
          'Stock': args['Stock'],
          'userId': FirebaseAuth.instance.currentUser!.email,
        });
        setState(() {
          iswish = true;
        });
      }catch (e){
        log(e.toString());
      }
    }

    CheckWishlist() async{
      final wishlistitems = await FirebaseFirestore.instance.collection('Wishlist')
          .where('userId',isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .where('ProductId',isEqualTo: args['ProductId']).get();
      if(wishlistitems.docs.isNotEmpty){
        setState(() {
          iswish=true;
        });
      }
    }

    //Cart

    Future addtoCart() async{

      try{
        await FirebaseFirestore.instance.collection('Cart').add({
          'ProductId':args['ProductId'],
          'ProductName': args['ProductName'],
          'image': args['image'],
          'Price': args['Price'],
          'Description': args['Description'],
          'Brand': args['Brand'],
          'Categories': args['Categories'],
          'Rating': args['Rating'],
          'Stock': args['Stock'],
          'userId': FirebaseAuth.instance.currentUser!.email,
        });
        setState(() {
          iscart = true;
        });
      }catch (e){
        log(e.toString());
      }
    }

    CheckCart() async{
      final wishlistitems = await FirebaseFirestore.instance.collection('Cart')
          .where('userId',isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .where('ProductId',isEqualTo: args['ProductId']).get();
      if(wishlistitems.docs.isNotEmpty){
        setState(() {
          iscart=true;
        });
      }
    }

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

    CheckCart();
    CheckWishlist();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if(iswish == false){
               setState(() {
                 addtoWishlist();
                 iswish = true;
               });

              }else{
             Navigator.push(context,MaterialPageRoute(builder: (context)=>WishlistPage()));
              }

            },
            icon: Icon(
              Icons.favorite,
              color: iswish ? Color(0xff7b0001) : Colors.grey,
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
              onPressed: () {
                if(iscart == false){
                  setState(() {
                    addtoCart();
                    iscart = true;
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Cartt()));
                  });
                }else{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Cartt()));
                }
              },
              child:Text(iscart ? 'Go to cart' : 'Add to cart'),
            ),
            MaterialButton(
              minWidth: 100,
             color:args['Stock']==0?Color(0xff8a92cd):Color(0xff8a92cd),
              onPressed: (){
                Navigator.pushNamed(context,  "singlecheckout",
                     arguments: {
                      'ProductId':args['ProductId'],
                      'ProductName': args['ProductName'],
                      'image': args['image'],
                      'totalPrice': args['Price'].toString(),
                      'Description': args['Description'],
                      'Brand': args['Brand'],
                      'Categories': args['Categories'],
                      'Rating': args['Rating'],
                      'Stock': args['Stock'],
                      'address': addresslist.isEmpty
                          ? "Add+Your+Address+for delivery"
                          : addresslist[0],
                      'phone': phonelist.isEmpty ? " " : phonelist[0],
                      'userId': FirebaseAuth.instance.currentUser!.email,
                    }
                   );
              },

              child:Text(
               args['Stock']==0?"Out of Stock":
                "BUY NOW"
              ),
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
