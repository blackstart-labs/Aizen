import '../../domain/entities/hardware_info.dart';

class HardwareInfoModel extends HardwareInfo {
  const HardwareInfoModel({
    required super.model,
    required super.manufacturer,
    required super.osVersion,
    required super.kernelArchitecture,
    required super.cpuCores,
    required super.totalRamMB,
  });

  factory HardwareInfoModel.fromJson(Map<String, dynamic> json) {
    return HardwareInfoModel(
      model: json['model'] ?? 'Unknown',
      manufacturer: json['manufacturer'] ?? 'Unknown',
      osVersion: json['osVersion'] ?? 'Unknown',
      kernelArchitecture: json['kernelArchitecture'] ?? 'Unknown',
      cpuCores: json['cpuCores'] ?? 1,
      totalRamMB: json['totalRamMB'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'manufacturer': manufacturer,
      'osVersion': osVersion,
      'kernelArchitecture': kernelArchitecture,
      'cpuCores': cpuCores,
      'totalRamMB': totalRamMB,
    };
  }
}
