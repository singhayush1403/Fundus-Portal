import 'package:flutter/material.dart';

class MacularTesselation extends StatefulWidget {
  MacularTesselation({Key? key}) : super(key: key);

  @override
  State<MacularTesselation> createState() => _MacularTesselationState();
}

class _MacularTesselationState extends State<MacularTesselation> {
  List categories = ["Grade 0", "Grade 1", "Grade 2", "Grade 3", "Grade 4"];
  String selectedCategory = "";
  @override
  void initState() {
    selectedCategory = categories[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.5,
       // height: 500,
      child: SingleChildScrollView(
        child: Row(
          children: [
            Image.asset("assets/images/mactes.jpeg"),
            Container(
              width: 200,
        //      width: 300,
            //  width: 500,
              height: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < categories.length; i++)
                    RadioListTile<String>(contentPadding: EdgeInsets.zero,
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
            )
          ],
        ),
      ),
    );
  }
}
