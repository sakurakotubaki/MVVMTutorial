import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:mvvm_pattern/common/timestamp_converter.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// flutter pub run build_runner watch --delete-conflicting-outputs

@freezed
class User with _$User {
  const factory User({
    @Default('') String name,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}