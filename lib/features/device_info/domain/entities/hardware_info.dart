import 'package:equatable/equatable.dart';

class HardwareInfo extends Equatable {
  final String model;
  final String manufacturer;
  final String osVersion;
  final String kernelArchitecture;
  final int cpuCores;
  final int totalRamMB;

  const HardwareInfo({
    required this.model,
    required this.manufacturer,
    required this.osVersion,
    required this.kernelArchitecture,
    required this.cpuCores,
    required this.totalRamMB,
  });

  @override
  List<Object?> get props => [
        model,
        manufacturer,
        osVersion,
        kernelArchitecture,
        cpuCores,
        totalRamMB,
      ];
}
