import 'package:flutter/material.dart';

class DiscTessellation extends StatefulWidget {
  DiscTessellation({Key? key}) : super(key: key);

  @override
  State<DiscTessellation> createState() => _DiscTessellationState();
}

class _DiscTessellationState extends State<DiscTessellation> {
  List categories = [];
  String selectedCategory = "";
  @override
  void initState() {
    for (int i = 0; i < 8; i++) {
      categories.add("Grade " + (i * 0.5).toString());
    }
    selectedCategory = categories[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Image.asset("assets/images/DiscTess_A.png"),
            Image.asset("assets/images/DiscTess_B.png"),
          ],
        ),
        Container(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < categories.length; i++)
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(categories[i]),
                  value: categories[i],
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
