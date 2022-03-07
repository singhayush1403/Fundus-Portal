import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fundus_sn_web/Models/ImageModel.dart';
import 'package:fundus_sn_web/Repository.dart/FirestoreRepo.dart';

class LocalNotifier extends ChangeNotifier {
  ImageModel? selectedModel;
  Queue<ImageModel> imageQueue = Queue<ImageModel>();
  int totalImages = 0;
  LocalNotifier() {
    init();
  }
  getnextImage() {
    if (imageQueue.isNotEmpty) {
      selectedModel = imageQueue.removeFirst();
    } else {
      selectedModel = null;
    }
    notifyListeners();
  }

  void init() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = user.data();
    var images = data!["images"] != null ? data["images"] : [];

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("images").get();
    totalImages = snapshot.docs.length;
    snapshot.docs.forEach((element) {
      var imgData = element.get("id");

      if (!images.contains(imgData)) {
        imageQueue
            .add(ImageModel.fromJson(element.data() as Map<String, dynamic>));
      }
    });
    getnextImage();
  }

  void setMetaPm(String metaPmChoice1) {
    selectedModel!.metaPMChoice1 = metaPmChoice1;

    notifyListeners();
  }

  void setMetaPmLesion(String metaPmLesionChoice) {
    selectedModel!.metaPMLesionChoice = metaPmLesionChoice;
    notifyListeners();
  }

  void setPostStaphChoice(String postStaphChoice) {
    selectedModel!.postStaphChoice = postStaphChoice;
    notifyListeners();
  }

  void setDiscTes(String discTes) {
    selectedModel!.discTesChoice = discTes;
    notifyListeners();
  }

  void setMacTes(String macTes) {
    selectedModel!.macTesChoice = macTes;
    notifyListeners();
  }

  void setDiscPos(String discPos) {
    selectedModel!.discPosChoice = discPos;
    notifyListeners();
  }

  get isCompletedImage =>
      selectedModel != null &&
      selectedModel!.metaPMChoice1 != null &&
      selectedModel!.metaPMLesionChoice != null &&
      selectedModel!.postStaphChoice != null &&
      selectedModel!.discTesChoice != null &&
      selectedModel!.macTesChoice != null &&
      selectedModel!.discPosChoice != null &&
      selectedModel!.peripheralChoice.isNotEmpty;

  void setPeripheralChoice(List<String> peripheralChoice) {
    selectedModel!.peripheralChoice = peripheralChoice;
    notifyListeners();
  }

  String verifyInputsAndSendFeedback() {
    bool notSelectedMetaPm = selectedModel!.metaPMChoice1 == null ||
        selectedModel!.metaPMChoice1!.isEmpty ||
        selectedModel!.metaPMLesionChoice == null ||
        selectedModel!.metaPMLesionChoice!.isEmpty;
    bool notSelectedPostStaph = selectedModel!.postStaphChoice == null ||
        selectedModel!.postStaphChoice!.isEmpty;
    bool notSelectedDiscTes = selectedModel!.discTesChoice == null ||
        selectedModel!.discTesChoice!.isEmpty;
    bool notSelectedMacTes = selectedModel!.macTesChoice == null ||
        selectedModel!.macTesChoice!.isEmpty;
    bool notSelectedDiscPos = selectedModel!.discPosChoice == null ||
        selectedModel!.discPosChoice!.isEmpty;
    bool notSelectedPeripheral = selectedModel!.peripheralChoice.isEmpty;
    if (notSelectedMetaPm) {
      // Fluttertoast.showToast(
      //     webShowClose: false,
      //     toastLength: Toast.LENGTH_LONG,
      //     msg: "Please select Meta Pm Choices",
      //     webPosition: "center");
      return "Please select Meta Pm Choices";
    }
    if (notSelectedPostStaph) {
      // Fluttertoast.showToast(
      //     msg: "Please select Posterior Staphyloma Choices",
      //     webPosition: "top");
      return "Please select Posterior Staphyloma Choices";
    }
    if (notSelectedDiscTes) {
      // Fluttertoast.showToast(
      //     msg: "Please select Disc Tessellation Choices", webPosition: "top");
      return "Please select Disc Tessellation Choices";
    }
    if (notSelectedMacTes) {
      // Fluttertoast.showToast(
      //     msg: "Please select Macular Tessellation Choices",
      //     webPosition: "top");
      // return;
      return "Please select Macular Tessellation Choices";
    }
    if (notSelectedDiscPos) {
      // Fluttertoast.showToast(
      //     msg: "Please select Disc Pos Choices", webPosition: "top");
      return "Please select Disc Positional Choices";
    }
    if (notSelectedPeripheral) {
      // Fluttertoast.showToast(
      //     msg: "Please select Peripheral Choices", webPosition: "top-center");
      return "Please select Peripheral Choices";
    }
    return "";
  }

  Future setImageData() async {
    if (selectedModel == null) return;
    await FirestoreRepository.saveImageDataforUser(selectedModel!);
    getnextImage();
  }
}
