import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {

  PaymentModel({
    required this.id,
    required this.amount,
    this.currency = 'USD',
    required this.status,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
  final String id;
  final double amount;
  final String currency;
  final String status;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
