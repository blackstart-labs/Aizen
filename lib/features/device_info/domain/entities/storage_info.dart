import 'package:equatable/equatable.dart';

class StorageInfo extends Equatable {
  final int totalBytes;
  final int freeBytes;
  final int usedBytes;

  const StorageInfo({
    required this.totalBytes,
    required this.freeBytes,
    required this.usedBytes,
  });

  double get totalGB => totalBytes / (1024 * 1024 * 1024);
  double get freeGB => freeBytes / (1024 * 1024 * 1024);
  double get usedGB => usedBytes / (1024 * 1024 * 1024);

  double get freePercent => totalBytes > 0 ? (freeBytes / totalBytes) * 100 : 0.0;
  double get usedPercent => totalBytes > 0 ? (usedBytes / totalBytes) * 100 : 0.0;

  @override
  List<Object?> get props => [totalBytes, freeBytes, usedBytes];
}
