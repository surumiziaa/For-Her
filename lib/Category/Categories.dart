import 'package:flutter/material.dart';

import '../Core/utilities.dart';
import 'CategoryDropdown.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text('Skin Care',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          SkinCare(),
          height,
          Text('MakeUp',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          Makeup(),
          height,
          Text('Hair Care',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          Haircare(),
          height,
          Text('Fragrance',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          Fragrance(),
          height,
          Text('Bath & Body',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          Bath()
        ],
      ),
    );
  }
}

class SkinCare extends StatefulWidget {
  const SkinCare({super.key});

  @override
  State<SkinCare> createState() => _SkinCareState();
}

class _SkinCareState extends State<SkinCare> {
  List<String> products = [
    'Lip Care',
    'Eye Care',
    'Cleanser',
    'Moisturizer',
    'Sunscreen',
  ];

  // Local selected variable for SkinCare
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/Category/skincare.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 18, right: 200),
          child: DropdownButtonFormField<String>(
            value: selected,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              hintText: 'Select a product',
            ),
            items: products.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selected = value; // Update selected value
              });

              if (value != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CDrop(brandcategory: value),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class Makeup extends StatefulWidget {
  Makeup({super.key});

  @override
  State<Makeup> createState() => _MakeupState();
}

class _MakeupState extends State<Makeup> {
  List<String> products = [
    'Eyeliner',
    'Mascara',
    'Kajal',
  ];

  // Local selected variable for Makeup
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/Category/makeup.webp'),
                fit: BoxFit.cover
            )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 18, right: 200),
          child: DropdownButtonFormField<String>(
            value: selected,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                hintText: 'Select a product'
            ),
            items: products.map((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selected = value;
              });
              if (value != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CDrop(brandcategory: value),
                  ),
                );
              }
            },

          ),
        ),
      ),
    );
  }
}

class Haircare extends StatefulWidget {
  const Haircare({super.key});

  @override
  State<Haircare> createState() => _HaircareState();
}

class _HaircareState extends State<Haircare> {
  List<String> products = [
    'Conditioner',
    'Shampoo',
    'Hair Oil',
    'Hair Serum',
    'Hair Spray',
    'Aloe Vera Gel',
  ];

  // Local selected variable for Haircare
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/Category/hair.webp'),
                fit: BoxFit.cover
            )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 18, right: 200),
          child: DropdownButtonFormField<String>(
            value: selected,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                hintText: 'Select a product'
            ),
            items: products.map((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selected = value;
              });
              if (value != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CDrop(brandcategory: value),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class Fragrance extends StatefulWidget {
  const Fragrance({super.key});

  @override
  State<Fragrance> createState() => _FragranceState();
}

class _FragranceState extends State<Fragrance> {
  List<String> products = [
    'Unisex',
    'perfume for Men',
    'Perfume for Women',
  ];

  // Local selected variable for Fragrance
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/Category/fragrance.jpg'),
                fit: BoxFit.cover
            )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, top: 12, right: 170),
          child: DropdownButtonFormField<String>(
            value: selected,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                hintText: 'Select a product'
            ),
            items: products.map((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selected = value;
              });
              if (value != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CDrop(brandcategory: value),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class Bath extends StatefulWidget {
  const Bath({super.key});

  @override
  State<Bath> createState() => _BathState();
}

class _BathState extends State<Bath> {
  List<String> products = [
    'Body Scrub',
    'Body Wipes',
    'Soaps',
    'Body Serums',
  ];

  // Local selected variable for Bath
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/Category/bath and body1.webp'),
                fit: BoxFit.cover
            )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 18, right: 200),
          child: DropdownButtonFormField<String>(
            value: selected,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                hintText: 'Select a product'
            ),
            items: products.map((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selected = value;
              });
              if (value != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CDrop(brandcategory: value),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
