class Plantdata {
  String? plantType;
  int? moistureLevel;
  int? nutrientLevel;
  int? pesticideVolume;
  String? userId;
  int? plantdataId;
  String? datetime;

  Plantdata(
      {required this.plantType, required this.moistureLevel, required this.nutrientLevel, required this.pesticideVolume});

  Map<String, dynamic> toJson() {
    return {
      "plantType": plantType,
      "moistureLevel": moistureLevel,
      "nutrientLevel": nutrientLevel,
      "pesticideVolume": pesticideVolume,
    };
  }
  Plantdata.fromJson(dynamic data){
    plantType = data["plantType"];
    moistureLevel = data["moistureLevel"];
    nutrientLevel = data["nutrientLevel"];
    pesticideVolume = data["pesticideVolume"];
  }

  @override
  String toString() {
    return 'plantType: $plantType,\n moistureLevel: $moistureLevel,\n nutrientLevel: $nutrientLevel,\n pesticideVolume: $pesticideVolume\n';
  }
}