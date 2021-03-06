import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Repository.dart/LocalNotifier.dart';

class PeripheralRetina extends StatefulWidget {
  PeripheralRetina({Key? key}) : super(key: key);

  @override
  State<PeripheralRetina> createState() => _PeripheralRetinaState();
}

class _PeripheralRetinaState extends State<PeripheralRetina> {
  final Map _peripheral = {
    "White Areas": false,
    "Lattice Degeneration": false,
    "Retinal Hole": false,
    "Horse Shoe Tear": false,
    "Paving Stone degeneration": false,
    "Peripheral avascular area": false,
  };
  final Map _map = {
    "Retinal detachment": false,
    "LASER Scar": false,
    "Pigments": false,
    "Weiss ring": false,
    "Vitreous condensation": false,
    "Chorioretinal atrophy": false,
    "Snow flake degeneration": false,
  };
  List<String> selectedPeripheral = [];
  @override
  void initState() {
    checkSelectedCategory();
    super.initState();
  }

  void checkSelectedCategory() {
    LocalNotifier localNotifier =
        Provider.of<LocalNotifier>(context, listen: false);
    if (localNotifier.selectedModel == null) return;
    if (localNotifier.selectedModel!.peripheralChoice != null) {
      setState(() {
        localNotifier.selectedModel!.peripheralChoice.forEach((key) {
          selectedPeripheral.add(key);
          if (_map[key] != null) {
            _map[key] = true;
          }
          if (_peripheral[key] != null) {
            _peripheral[key] = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red)),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              for (int i = 0; i < _peripheral.length; i++)
                Container(
                  width: 200,
                  child: CheckboxListTile(
                      title: Text(_peripheral.keys.elementAt(i)),
                      value: _peripheral[_peripheral.keys.elementAt(i)],
                      onChanged: (e) {
                        setState(() {
                          _peripheral[_peripheral.keys.elementAt(i)] = e;
                        });
                        if (e!) {
                          selectedPeripheral.add(_peripheral.keys.elementAt(i));
                          Provider.of<LocalNotifier>(context, listen: false)
                              .setPeripheralChoice(selectedPeripheral);
                        } else {
                          selectedPeripheral
                              .remove(_peripheral.keys.elementAt(i));
                        }
                      }),
                )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red)),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              for (int i = 0; i < _map.length; i++)
                Container(
                  width: 200,
                  child: CheckboxListTile(
                      title: Text(_map.keys.elementAt(i)),
                      value: _map[_map.keys.elementAt(i)],
                      onChanged: (e) {
                        setState(() {
                          _map[_map.keys.elementAt(i)] = e;
                        });
                        if (e!) {
                          selectedPeripheral.add(_map.keys.elementAt(i));
                          Provider.of<LocalNotifier>(context, listen: false)
                              .setPeripheralChoice(selectedPeripheral);
                        } else {
                          selectedPeripheral.remove(_map.keys.elementAt(i));
                        }
                      }),
                )
            ],
          ),
        ),
      ],
    );
  }
}
