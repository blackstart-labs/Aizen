import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/device_info_bloc.dart';
import '../bloc/device_info_event.dart';
import '../bloc/device_info_state.dart';
import '../../domain/entities/hardware_info.dart';
import '../../domain/entities/battery_info.dart';
import '../../domain/entities/storage_info.dart';
import '../widgets/battery_info_panel.dart';
import '../widgets/hardware_info_panel.dart';
import '../widgets/storage_info_panel.dart';
import '../widgets/system_status_panel.dart';
import '../../../navigation_hub/presentation/widgets/navigation_hub_drawer.dart';
import '../../../../core/theme/aizen_theme.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  late DeviceInfoBloc _deviceInfoBloc;

  @override
  void initState() {
    super.initState();
    _deviceInfoBloc = context.read<DeviceInfoBloc>();
    _deviceInfoBloc.add(LoadDeviceInfoEvent());
  }

  @override
  void dispose() {
    _deviceInfoBloc.add(PauseBatteryTrackingEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final edgePadding = AizenBreakpoints.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AizenTheme.amoledBlack,
      drawer: const NavigationHubDrawer(),
      appBar: AppBar(
        backgroundColor: AizenTheme.amoledBlack,
        elevation: 0,
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: AizenTheme.textPrimary, size: 20),
              onPressed: () {
                AizenHaptics.selection();
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          'Aizen Specifications',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AizenTheme.textPrimary, size: 20),
            onPressed: () {
              AizenHaptics.light();
              context.read<DeviceInfoBloc>().add(LoadDeviceInfoEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<DeviceInfoBloc, DeviceInfoState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == DeviceInfoStatus.loading || state.status == DeviceInfoStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(
                color: AizenTheme.primaryPurple,
                strokeWidth: 2,
              ),
            );
          } else if (state.status == DeviceInfoStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AizenTheme.accentRed, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'An error occurred while loading specifications.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AizenTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () {
                        AizenHaptics.medium();
                        context.read<DeviceInfoBloc>().add(LoadDeviceInfoEvent());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;

              final hardwarePanel = BlocSelector<DeviceInfoBloc, DeviceInfoState, HardwareInfo?>(
                selector: (state) => state.hardwareInfo,
                builder: (context, hw) {
                  return hw != null ? HardwareInfoPanel(info: hw) : const SizedBox.shrink();
                },
              );

              final batteryPanel = BlocSelector<DeviceInfoBloc, DeviceInfoState, BatteryInfo?>(
                selector: (state) => state.batteryInfo,
                builder: (context, bt) {
                  return bt != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: BatteryInfoPanel(info: bt),
                        )
                      : const SizedBox.shrink();
                },
              );

              final storagePanel = BlocSelector<DeviceInfoBloc, DeviceInfoState, StorageInfo?>(
                selector: (state) => state.storageInfo,
                builder: (context, st) {
                  return st != null ? StorageInfoPanel(info: st) : const SizedBox.shrink();
                },
              );

              final kernelPanel = BlocSelector<DeviceInfoBloc, DeviceInfoState, BatteryInfo?>(
                selector: (state) => state.batteryInfo,
                builder: (context, bt) {
                  return SystemStatusPanel(info: bt);
                },
              );

              if (isWide) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: edgePadding, vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: hardwarePanel,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              kernelPanel,
                              const SizedBox(height: 16),
                              batteryPanel,
                              storagePanel,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: edgePadding, vertical: 16.0),
                  child: Column(
                    children: [
                      hardwarePanel,
                      const SizedBox(height: 16),
                      kernelPanel,
                      const SizedBox(height: 16),
                      batteryPanel,
                      storagePanel,
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
