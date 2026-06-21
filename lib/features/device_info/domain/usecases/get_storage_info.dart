import '../../../../core/error/failures.dart';
import '../entities/storage_info.dart';
import '../repositories/device_info_repository.dart';

class GetStorageInfo {
  final DeviceInfoRepository repository;

  const GetStorageInfo(this.repository);

  Future<(Failure?, StorageInfo?)> call() => repository.getStorageInfo();
}
