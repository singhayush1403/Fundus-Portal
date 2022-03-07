import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Repository.dart/LocalNotifier.dart';

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
    //  selectedCategory = categories[0];
    checkSelectedCategory();
    super.initState();
  }

  void checkSelectedCategory() {
    LocalNotifier localNotifier =
        Provider.of<LocalNotifier>(context, listen: false);
    if (localNotifier.selectedModel == null) return;
    if (localNotifier.selectedModel!.discTesChoice != null) {
      setState(() {
        selectedCategory = localNotifier.selectedModel!.discTesChoice!;
      });
    }
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
                    Provider.of<LocalNotifier>(context, listen: false)
                        .setDiscTes(selectedCategory);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
