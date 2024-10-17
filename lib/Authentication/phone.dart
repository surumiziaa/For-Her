import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
class Phone extends StatefulWidget {
  const Phone({super.key});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController phonenumber = TextEditingController();
  Country country = Country(
    phoneCode: "91",
    countryCode:'IN',
    e164Sc: 0,
    geographic: true,
    level:1,
    name: 'India',
    example: 'India',
    displayName: 'India',
    displayNameNoCountryCode:'IN',
    e164Key: '',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10,),
          ClipRRect(
            child: Image(
              image: AssetImage('lib/Assets/phone.jpeg'),
              fit:BoxFit.fill,
              height: 150,
              width: 150,
            ),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              maxLength: 10,
              controller: phonenumber,
              decoration: InputDecoration(
                prefixIcon: InkWell(
                  onTap: (){
                    showCountryPicker(
                        countryListTheme: CountryListThemeData(
                            bottomSheetHeight: 400
                        ),
                        context: context, onSelect: (value){
                      setState(() {
                        country = value;
                      });
                    });
                  },
                  child: Text('${country.flagEmoji} + ${country.phoneCode}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black
                    ),),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
                hintText: 'Enter your phone number',
              ),
            ),
          ),
          MaterialButton(
            color: Colors.teal[300],
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Verifyph()));
            },
            child: Text('Login'),)
        ],
      ),
    );
  }
}


class Verifyph extends StatefulWidget {
  const Verifyph({super.key});

  @override
  State<Verifyph> createState() => _VerifyphState();
}

class _VerifyphState extends State<Verifyph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
