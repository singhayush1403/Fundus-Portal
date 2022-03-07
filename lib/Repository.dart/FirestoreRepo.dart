import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fundus_sn_web/Models/ImageModel.dart';

class FirestoreRepository {
  static FirebaseFirestore instance = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static void createUser(User user) {
    FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      "images": []
    });
  }

  static void addMetaPMChoice(String imageId, String choice1, String choice2) {
    instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("images")
        .doc(imageId)
        .set({
      "Meta-PM": {
        "choice1": choice1,
        "Plus Legions": choice2,
      }
    });
  }

  static void addPosteriorStaphylomaChoice(String imageId, String choice) {
    instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("images")
        .doc(imageId)
        .set({
      "PosteriorStaphyloma": {
        "choice": choice,
      }
    });
  }

  static void addMacularTessellationChoice(String imageId, String choice) {
    instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("images")
        .doc(imageId)
        .set({
      "MacularTessellation": {
        "choice": choice,
      }
    });
  }

  static void addDiscTessellationChoice(String imageId, String choice) {
    instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("images")
        .doc(imageId)
        .set({
      "DiscTessellation": {
        "choice": choice,
      }
    });
  }

  static void addDiscPositionalChoice(String imageId, String choice) {
    instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("images")
        .doc(imageId)
        .set({
      "DiscPositional": {
        "choice": choice,
      }
    });
  }

  static void addPeripheralRetinaChoice(String imageId, List<String> choice) {
    instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("images")
        .doc(imageId)
        .set({
      "PeripheralRetina": {
        "choice": choice,
      }
    });
  }

  static void writeAllImages() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult files = await storage.ref().listAll();
    files.items.forEach((element) async {
      String url = await element.getDownloadURL();
      instance
          .collection("images")
          .doc(element.name)
          .set({"id": element.name, "url": url});
    });
  }

  static Future<void> saveImageDataforUser(ImageModel imageModel) async {
    await instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("images")
        .doc(imageModel.imageID)
        .set(imageModel.toJson());
    await instance.collection("users").doc(auth.currentUser!.uid).update({
      "images": FieldValue.arrayUnion([imageModel.imageID])
    });
  }
}
