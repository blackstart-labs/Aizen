# Device Info System Module (Version 1.2.0)

The Device Info System module provides a local-first technical dashboard displaying deep hardware specifications, real-time battery status, and segmented storage usage metrics.

## Features
- **System Hardware**: Renders model, manufacturer, OS version, kernel architecture, processor cores (`Platform.numberOfProcessors`), and system memory.
- **Power & Battery**: Streams battery levels, status (charging, discharging, full, unknown), health state, and temperature.
- **System Storage**: Queries and renders a custom visual segmented space progress bar indicating free vs used bytes.

## Architecture
This module follows the **Feature-First Layered Architecture** pattern:

### 1. Domain Layer
- **Entities**: 
  - `HardwareInfo`: Standard specs model.
  - `BatteryInfo`: Real-time power statistics.
  - `StorageInfo`: Storage space allocation.
- **Repository Contract**: `DeviceInfoRepository`
- **Use Cases**:
  - `GetHardwareInfo`
  - `GetStorageInfo`
  - `StreamBatteryInfo`

### 2. Data Layer
- **Models**:
  - `HardwareInfoModel`: Extends domain entity with JSON mapping.
  - `BatteryInfoModel`: Extends domain entity with JSON mapping.
  - `StorageInfoModel`: Extends domain entity with JSON mapping.
- **Data Source**: `DeviceInfoLocalDataSource` (uses `device_info_plus`, `battery_plus`, and `storage_space` with custom platform guards for Web and Desktop cross-platform targets).
- **Repository Implementation**: `DeviceInfoRepositoryImpl`

### 3. Presentation Layer
- **BLoC**: `DeviceInfoBloc` (manages loading hardware and storage profiles, and reactive battery stream subscriptions).
- **Widgets**:
  - `HardwareInfoPanel`: Dense row list for hardware specs.
  - `BatteryInfoPanel`: Adaptive icons and telemetry.
  - `StorageInfoPanel`: Segmented progress bar.
- **Pages**:
  - `DeviceInfoPage`: Scaffold layout that adapts responsively to desktop and mobile constraints.
