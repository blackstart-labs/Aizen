import '../../domain/entities/storage_info.dart';

class StorageInfoModel extends StorageInfo {
  const StorageInfoModel({
    required super.totalBytes,
    required super.freeBytes,
    required super.usedBytes,
  });

  factory StorageInfoModel.fromJson(Map<String, dynamic> json) {
    return StorageInfoModel(
      totalBytes: json['totalBytes'] ?? 0,
      freeBytes: json['freeBytes'] ?? 0,
      usedBytes: json['usedBytes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBytes': totalBytes,
      'freeBytes': freeBytes,
      'usedBytes': usedBytes,
    };
  }
}
