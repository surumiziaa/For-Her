import 'package:flutter/material.dart';
import 'package:for_her/CheckOut/Checkoutpage.dart';



class NYbaeDetail extends StatefulWidget {
  const NYbaeDetail({super.key});

  @override
  State<NYbaeDetail> createState() => _NYbaeDetailState();
}

String Pname =
    "NY Bae The Big Apple of My Eye" + "Kajal | Twin Pack | Waterproof.";
class _NYbaeDetailState extends State<NYbaeDetail> {
  int counter = 0;

  void decrement() {
    setState(() {
      counter--;
    });
  }

  void increment() {
    setState(() {
      counter++;
    });
  }

  String ?selected;
 List<String> Quantity=['1','2','3','4','5','6','7','8','9','10'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag),
            Text('My Cart',
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 700,
              height: 330,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(25)
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ClipRRect(
                      child: Image(
                        image: AssetImage('lib/NYBae/NBBigApple.jpg'),
                        fit: BoxFit.fill,
                        height: 150,
                        width: 500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                    child: Text(
                      Pname.split("+").join('\n'),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '₹500',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: DropdownButtonFormField(
                            value: selected,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                hintText: 'Quantity'
                            ),
                            items:Quantity.map((String value){
                              return DropdownMenuItem(child: Text(value),value: value,);
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selected=value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (BuildContext context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Total Price\n₹500',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>const Checkoutdetails()));
                  },
                  child: const Text('CheckOut',
                    style: TextStyle(
                      color:Color(0xff7b0001),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
