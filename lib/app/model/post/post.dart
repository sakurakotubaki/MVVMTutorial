import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:mvvm_pattern/common/timestamp_converter.dart';

part 'post.freezed.dart';
part 'post.g.dart';

// flutter pub run build_runner watch --delete-conflicting-outputs

@freezed
class Post with _$Post {
  const factory Post({
    String? id,
    @Default('') String body,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json);
}
