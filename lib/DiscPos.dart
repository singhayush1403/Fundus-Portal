import 'package:flutter/material.dart';

class DiscPositional extends StatefulWidget {
  const DiscPositional({Key? key}) : super(key: key);

  @override
  _DiscPositionalState createState() => _DiscPositionalState();
}

class _DiscPositionalState extends State<DiscPositional> {
  String selectedCategory = "";
  List categories = ["A: Horizontal", "B: Nasal", "C: Vertical", "D: Oblique"];
  @override
  void initState() {
    selectedCategory = categories[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Column(
            children: [
              Image.asset("assets/images/A.png"),
              Text("A"),
              Image.asset("assets/images/B.png"),
              Text("B"),
              Image.asset("assets/images/C.png"),
              Text("C"),
              Image.asset("assets/images/D.png"),
              Text("D"),
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red)),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                for (int i = 0; i < categories.length; i++)
                  Container(
                    width: 200,
                    child: RadioListTile<String>(
                        title: Text(categories[i]),
                        value: categories[i],
                        groupValue: selectedCategory,
                        onChanged: (e) {
                          setState(() {
                            selectedCategory = e!;
                          });
                        }),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
