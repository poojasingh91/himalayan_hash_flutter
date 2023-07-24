import '../../models/hash_model.dart';
import '../../models/hasher_model.dart';

class HashHashers {
  late List<HashHasher>? hashhashers = [];

  HashHashers({this.hashhashers});
  List<HashHasher>? get getHashHashers => hashhashers;

  HashHashers.fromJson(Map<String, dynamic> json) {
    late HashHasher h;

    if (json['message'] != null) {
      json['message'].forEach((v) {
        h = HashHasher.fromJson(v);
        hashhashers?.add(h);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    final hashhashers = this.hashhashers;
    if (hashhashers != null) {
      data['hashhashers'] = hashhashers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HashHasher {
  int? id;
  int? hashId;
  int? hasherId;
  int? isHare;
  String? createdAt;
  String? updatedAt;
  Hash? hashe;
  Hasher? hasher;

  // List<HashHasher>? get getHashHashers => hashhashers;
  // List<Hashe>? get getHash => hashe;
  // List<Hasher>? get getHashers => hashers;

  HashHasher(
      {this.id,
      this.hashId,
      this.hasherId,
      this.isHare,
      this.createdAt,
      this.updatedAt,
      this.hashe,
      this.hasher});

  HashHasher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hashId = json['hash_id'];
    hasherId = json['hasher_id'];
    isHare = json['is_hare'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    hashe = json['hashe'] != null ? new Hash.fromJson(json['hashe']) : null;
    hasher =
        json['hasher'] != null ? new Hasher.fromJson(json['hasher']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hash_id'] = this.hashId;
    data['hasher_id'] = this.hasherId;
    data['is_hare'] = this.isHare;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.hashe != null) {
      data['hashe'] = this.hashe!.toJson();
    }
    if (this.hasher != null) {
      data['hasher'] = this.hasher!.toJson();
    }
    return data;
  }
}

class Hashe {
  int? id;
  String? title;
  String? hashNumber;
  String? hashDate;
  String? time;
  String? hashLocation;
  String? startingPoint;
  String? endingPoint;
  String? specialOccasion;
  String? description;
  String? bannerImage;
  Null? createdAt;
  Null? updatedAt;

  Hashe(
      {this.id,
      this.title,
      this.hashNumber,
      this.hashDate,
      this.time,
      this.hashLocation,
      this.startingPoint,
      this.endingPoint,
      this.specialOccasion,
      this.description,
      this.bannerImage,
      this.createdAt,
      this.updatedAt});

  Hashe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    hashNumber = json['hash_number'];
    hashDate = json['hash_date'];
    time = json['time'];
    hashLocation = json['hash_location'];
    startingPoint = json['starting_point'];
    endingPoint = json['ending_point'];
    specialOccasion = json['special_occasion'];
    description = json['description'];
    bannerImage = json['banner_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['hash_number'] = this.hashNumber;
    data['hash_date'] = this.hashDate;
    data['time'] = this.time;
    data['hash_location'] = this.hashLocation;
    data['starting_point'] = this.startingPoint;
    data['ending_point'] = this.endingPoint;
    data['special_occasion'] = this.specialOccasion;
    data['description'] = this.description;
    data['banner_image'] = this.bannerImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class HashersByHashId {
  List<HasherByHash>? hasherByHash;

  HashersByHashId({this.hasherByHash});
  List<HasherByHash>? get getHasherByHash => hasherByHash;

  HashersByHashId.fromJson(Map<String, dynamic> json) {
    if (json['HasherByHash'] != null) {
      hasherByHash = <HasherByHash>[];
      json['HasherByHash'].forEach((v) {
        hasherByHash!.add(new HasherByHash.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hasherByHash != null) {
      data['HasherByHash'] = this.hasherByHash!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HasherByHash {
  int? id;
  int? hashId;
  String? title;
  int? hasherId;
  String? hasher;
  int? isHare;

  HasherByHash(
      {this.hashId, this.title, this.hasherId, this.hasher, this.isHare});

  HasherByHash.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hashId = json['hash_id'];
    title = json['title'];
    hasherId = json['hasher_id'];
    hasher = json['hasher'];
    isHare = json['is_hare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hash_id'] = this.hashId;
    data['title'] = this.title;
    data['hasher_id'] = this.hasherId;
    data['hasher'] = this.hasher;
    data['is_hare'] = this.isHare;
    return data;
  }
}
