import '/models/hasher_model.dart';
import '/models/hash_model.dart';
import '/models/hashhasher_model.dart';

class Payments {
  late List<Payment>? payments = [];

  Payments({this.payments});
  List<Payment>? get getPayments => payments;

  Payments.fromJson(Map<String, dynamic> json) {
    late Payment p;

    if (json['message'] != null) {
      json['message'].forEach((v) {
        p = Payment.fromJson(v);
        payments?.add(p);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    final payments = this.payments;
    if (payments != null) {
      data['payments'] = payments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payment {
  int? id;
  int? hashId;
  int? hasherId;
  String? runningPaymentStatus;
  String? drinkPaymentStatus;
  String? hardDrinkPaymentStatus;
  String? createdAt;
  String? updatedAt;
  Hash? hashe;
  Hasher? hasher;

  Payment(
      {this.id,
      this.hashId,
      this.hasherId,
      this.runningPaymentStatus,
      this.drinkPaymentStatus,
      this.hardDrinkPaymentStatus,
      this.createdAt,
      this.updatedAt,
      this.hashe,
      this.hasher});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hashId = json['hash_id'];
    hasherId = json['hasher_id'];
    runningPaymentStatus = json['running_payment_status'];
    drinkPaymentStatus = json['drink_payment_status'];
    hardDrinkPaymentStatus = json['hard_drink_payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    hashe = json['hashe'];
    hasher = json['hasher'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hash_id'] = hashId;
    data['hasher_id'] = hasherId;
    data['running_payment_status'] = runningPaymentStatus;
    data['drink_payment_status'] = drinkPaymentStatus;
    data['hard_drink_payment_status'] = hardDrinkPaymentStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['hashe'] = hashe;
    data['hasher'] = hasher;
    return data;
  }

  @override
  String toString() {
    return 'Payment: {id: $id, hashId: $hashId, hasherId: $hasherId, runningPaymentStatus: $runningPaymentStatus, drinkPaymentStatus: $drinkPaymentStatus, hardDrinkPaymentStatus: $hardDrinkPaymentStatus, createdAt: $createdAt, updatedAt: $updatedAt,hashe: $hashe, hasher:$hasher}';
  }
}

class HasherPayment {
  String? runningPaymentStatus;
  String? drinkPaymentStatus;
  String? hardDrinkPaymentStatus;
  String? hasher;
  int? hasherId;

  HasherPayment({
    this.runningPaymentStatus,
    this.drinkPaymentStatus,
    this.hardDrinkPaymentStatus,
    this.hasher,
    this.hasherId,
  });
  HasherPayment.fromJson(Map<String, dynamic> json) {
    runningPaymentStatus = json['running_payment_status'];
    drinkPaymentStatus = json['drink_payment_status'];
    hardDrinkPaymentStatus = json['hard_drink_payment_status'];
    hasher = json['hasher'];
    hasherId = json['hasher_id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['running_payment_status'] = runningPaymentStatus;
    data['drink_payment_status'] = drinkPaymentStatus;
    data['hard_drink_payment_status'] = hardDrinkPaymentStatus;
    data['hasher'] = hasher;
    data['hasher_id'] = hasherId;
    return data;
  }

  @override
  String toString() {
    return 'HasherPayment: {running_payment_status: $runningPaymentStatus, drink_payment_status: $drinkPaymentStatus, hard_drink_payment_status: $hardDrinkPaymentStatus,hasher:$hasher,hasher_id: $hasherId,}';
  }
}
