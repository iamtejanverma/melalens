class ImageModel {
  final int id;
  final String path;

  ImageModel({required this.id, required this.path});

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'path' : path,
    };
  }
}