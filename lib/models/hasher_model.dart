class Hashers {
  late List<Hasher>? hashers = [];

  Hashers({this.hashers});
  List<Hasher>? get getHashers => hashers;

  Hashers.fromJson(Map<String, dynamic> json) {
    late Hasher h;

    if (json['message'] != null) {
      json['message'].forEach((v) {
        h = Hasher.fromJson(v);
        hashers?.add(h);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    final hashers = this.hashers;
    if (hashers != null) {
      data['hashers'] = hashers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hasher {
  int? id;
  String? firstName;
  String? lastName;
  String? countryId;
  String? dateOfFirstNepalHash;
  int? noOfHashesToDate;
  int? noOfHashesHared;
  String? createdAt;
  String? updatedAt;

  Hasher(
      {this.id,
      this.firstName,
      this.lastName,
      this.countryId,
      this.dateOfFirstNepalHash,
      this.noOfHashesToDate,
      this.noOfHashesHared,
      this.createdAt,
      this.updatedAt});

  Hasher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    countryId = json['country_id'];
    dateOfFirstNepalHash = json['date_of_first_nepal_hash'];
    noOfHashesToDate = json['no_of_hashes_to_date'];
    noOfHashesHared = json['no_of_hashes_hared'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['country_id'] = countryId;
    data['date_of_first_nepal_hash'] = dateOfFirstNepalHash;
    data['no_of_hashes_to_date'] = noOfHashesToDate;
    data['no_of_hashes_hared'] = noOfHashesHared;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'Hasher: {id: $id, firstName: $firstName, lastName: $lastName, countryId: $countryId, dateOfFirstNepalHash: $dateOfFirstNepalHash, noOfHashesToDate: $noOfHashesToDate, noOfHashesHared: $noOfHashesHared, createdAt: $createdAt, updatedAt: $updatedAt,}';
  }
}

class HasherDetail {
  Hasher? hasher;
  int noOfHashes = 0;
  int hashesHared = 0;
  String day = '';

  HasherDetail(
      {this.hasher, this.noOfHashes = 0, this.hashesHared = 0, this.day = ''});

  HasherDetail.fromJson(Map<String, dynamic> json) {
    // hasher = json['hasher'] != null ? new Hasher.fromJson(json['hasher']) : null;
    hasher = Hasher.fromJson(json['hasher']);
    noOfHashes = json['no_of_hashes'];
    hashesHared = json['no_of_hashes_hared'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final hasher = this.hasher;
    if (hasher != null) {
      data['hasher'] = hasher.toJson();
    }
    data['no_of_hashes'] = this.noOfHashes;
    data['no_of_hashes_hared'] = this.hashesHared;
    return data;
  }
}
