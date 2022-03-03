import 'package:flutter/material.dart';

class MetaPMSelectionWidget extends StatefulWidget {
  const MetaPMSelectionWidget({Key? key}) : super(key: key);

  @override
  _MetaPMSelectionWidgetState createState() => _MetaPMSelectionWidgetState();
}

class _MetaPMSelectionWidgetState extends State<MetaPMSelectionWidget> {
  TextStyle style = const TextStyle(color: Colors.black, fontSize: 16.0);
  List categories = [
    "Category 0 - No myopic retinal degenerative lesion",
    "Category 1 - Tessellated fundus",
    "Category 2 - Diffuse chorioretinal atrophy",
    "Category 3 - Patchy chorioretinal atrophy",
    "Category 4 - Macular atrophy"
  ];
  List lesionCategories = [
    "Lacquer Cracks",
    "Myopic choroidal neovascularization",
    "Fuchs spot"
  ];
  String selectedCategory = "";
  String selectedLesionCategory = "";
  @override
  void initState() {
    selectedCategory = categories[0];
    selectedLesionCategory = lesionCategories[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        //     height: 200,
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/images/META-PM.png"),
            Container(
              //  height: 40,
              //       width: 500,
              child: ListTile(
                leading: Radio(
                    value: categories[0],
                    groupValue: selectedCategory,
                    onChanged: onChanged),
                title: Text(
                  categories[0],
                  style: style,
                ),
              ),
            ),
            Container(
              //  height: 40,
              //       width: 500,
              child: ListTile(
                leading: Radio(
                    value: categories[1],
                    groupValue: selectedCategory,
                    onChanged: onChanged),
                title: Text(
                  categories[1],
                  style: style,
                ),
              ),
            ),
            Container(
              //  height: 40,
              //       width: 500,
              child: ListTile(
                leading: Radio(
                    value: categories[2],
                    groupValue: selectedCategory,
                    onChanged: onChanged),
                title: Text(
                  categories[2],
                  style: style,
                ),
              ),
            ),
            Container(
              //  height: 40,
              //       width: 500,
              child: ListTile(
                leading: Radio(
                    value: categories[3],
                    groupValue: selectedCategory,
                    onChanged: onChanged),
                title: Text(
                  categories[3],
                  style: style,
                ),
              ),
            ),
            Container(
              //  height: 40,
              //       width: 500,
              child: ListTile(
                leading: Radio(
                    value: categories[4],
                    groupValue: selectedCategory,
                    onChanged: onChanged),
                title: Text(
                  categories[4],
                  style: style,
                ),
              ),
            ),
            Container(
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black)),
              child: Column(
                children: [
                  const Text("Plus Lesions"),
                  Container(
                    //  height: 40,
                    //       width: 500,
                    child: ListTile(
                      leading: Radio(
                          value: lesionCategories[0],
                          groupValue: selectedLesionCategory,
                          onChanged: onLesionChanged),
                      title: Text(
                        categories[0],
                        style: style,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Radio(
                        value: lesionCategories[1],
                        groupValue: selectedLesionCategory,
                        onChanged: onLesionChanged),
                    title: Text(
                      categories[1],
                      style: style,
                    ),
                  ),
                  ListTile(
                    leading: Radio(
                        value: lesionCategories[2],
                        groupValue: selectedLesionCategory,
                        onChanged: onLesionChanged),
                    title: Text(
                      categories[2],
                      style: style,
                    ),
                  ),
                ],
              ),
            ),
            // ListTile(
            //   leading: Radio(
            //       value: categories[1],
            //       groupValue: selectedCategory,
            //       onChanged: onChanged),
            //   title: Text(categories[1]),
            // ),
            // ListTile(
            //   leading: Radio(
            //       value: categories[2],
            //       groupValue: selectedCategory,
            //       onChanged: onChanged),
            //   title: Text(categories[2]),
            // ),
            // ListTile(
            //   leading: Radio(
            //       value: categories[3],
            //       groupValue: selectedCategory,
            //       onChanged: onChanged),
            //   title: Text(categories[3]),
            // ),
            // ListTile(
            //   leading: Radio(
            //       value: categories[4],
            //       groupValue: selectedCategory,
            //       onChanged: onChanged),
            //   title: Text(categories[4]),
            // ),
          ],
        ),
      ),
    );
  }

  void onChanged(value) {
    setState(() {
      selectedCategory = value;
    });
  }

  void onLesionChanged(value) {
    setState(() {
      selectedLesionCategory = value;
    });
  }
}
