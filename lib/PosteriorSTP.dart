import 'package:flutter/material.dart';

class PosteriorSTPSelectionWidget extends StatefulWidget {
  PosteriorSTPSelectionWidget({Key? key}) : super(key: key);

  @override
  State<PosteriorSTPSelectionWidget> createState() =>
      _PosteriorSTPSelectionWidgetState();
}

class _PosteriorSTPSelectionWidgetState
    extends State<PosteriorSTPSelectionWidget> {
  String selectedStaphyloma = "";
  List categories = [
    "No staphyloma",
    "Wide Macular",
    "Narrow Macular",
    "Peripapillary",
    "Nasal",
    "Inferior",
    "Other"
  ];

  @override
  void initState() {
    selectedStaphyloma = categories[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/pst.png',
        ),
        Container(
      //    height: 500,
          width: 500,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < 7; i++)
                RadioListTile<String>(
                    value: categories[i],
                    groupValue: selectedStaphyloma,
                    title: Text(categories[i]),
                    onChanged: (value) {
                      setState(() {
                        selectedStaphyloma = value!;
                      });
                    })
            ],
          ),
        )
      ],
    );
  }
}
