import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

import 'hasher_model.dart';

class Hashes {
  late List<Hash>? hashes = [];

  Hashes({this.hashes});

  List<Hash>? get getHashes => hashes;

  Hashes.fromJson(Map<String, dynamic> json) {
    late Hash h;

    if (json['hash'] != null) {
      json['hash'].forEach((v) {
        h = Hash.fromJson(v);
        hashes?.add(h);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    final hashes = this.hashes;
    if (hashes != null) {
      data['hashes'] = hashes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hash {
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
  List<int>? hareList;
  String? createdAt;
  String? updatedAt;

  Hash(
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
      this.hareList,
      this.createdAt,
      this.updatedAt});

  Hash.fromJson(Map<String, dynamic> json) {
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
    hareList = json['hare_list'];
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['hash_number'] = hashNumber;
    data['hash_date'] = hashDate;
    data['time'] = time;
    data['hash_location'] = hashLocation;
    data['starting_point'] = startingPoint;
    data['ending_point'] = endingPoint;
    data['special_occasion'] = specialOccasion;
    data['description'] = description;
    data['banner_image'] = bannerImage;
    data['hare_list'] = hareList;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'Hash: {id: $id, title: $title, hashNumber: $hashNumber, hashDate: $hashDate, time: $time, hashLocation: $hashLocation, startingPoint: $startingPoint, endingPoint: $endingPoint, specialOccasion: $specialOccasion, description: $description, hareList: $hareList, bannerImage: $bannerImage, createdAt: $createdAt, updatedAt: $updatedAt }';
  }
}

class HashDetail {
  Hash? hash;
  int noOfHashers = 0;
  List<Hasher>? haresList = [];
  List<Hasher>? hasherList = [];
  String day = '';

  List<Hasher>? get getHares => haresList;
  List<Hasher>? get getHasher => hasherList;
  Hash? get getHash => hash;

  HashDetail({this.hash, this.noOfHashers = 0, this.haresList, this.day = ''});

  HashDetail.fromJson(Map<String, dynamic> json) {
    hash = Hash.fromJson(json['hash']);
    noOfHashers = json['no_of_hashers'];
    day = json['day'];

    if (json['hares_list'] == null || json['hares_list'].length == 0) {
      debugPrint('Hares not assigned yet');
    } else {
      json['hares_list'].forEach((v) {
        var h = jsonEncode(v);
        haresList?.add(Hasher.fromJson(v));
      });

      // debugPrint('hare List');
      // debugPrint(haresList.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    final hash = this.hash;
    if (hash != null) {
      data['hash'] = hash.toJson();
    }
    data['no_of_hashers'] = noOfHashers;
    final haresList = this.haresList;
    if (haresList != null) {
      data['hares_list'] = haresList.map((v) => v).toList();
    }
    data['day'] = day;
    return data;
  }
}
