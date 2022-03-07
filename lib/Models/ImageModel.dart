class ImageModel {
  late String imageID;
  String? imageURL;
  String? metaPMChoice1;
  String? metaPMLesionChoice;
  String? postStaphChoice;
  String? macTesChoice;
  String? discTesChoice;
  String? discPosChoice;

  List<String> peripheralChoice = [];

  ImageModel(String id, {String? imageUrl}) {
    imageID = id;
    if (imageUrl != null) imageURL = imageUrl;
  }
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(json["id"], imageUrl: json["url"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": imageID,
      "url": imageURL,
      "metaPMChoice": metaPMChoice1,
      "metaPMLesionChoice": metaPMLesionChoice,
      "postStaphChoice": postStaphChoice,
      "macTesChoice": macTesChoice,
      "discTesChoice": discTesChoice,
      "discPosChoice": discPosChoice,
      "peripheralChoice": peripheralChoice,
    };
  }
}
