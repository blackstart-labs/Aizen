import 'package:flutter/material.dart';
import '../../domain/entities/battery_info.dart';

class BatteryInfoPanel extends StatelessWidget {
  final BatteryInfo info;

  const BatteryInfoPanel({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    IconData batteryIcon = Icons.battery_unknown;
    Color batteryColor = Colors.white;

    if (info.percentage >= 80) {
      batteryIcon = info.status == ChargingStatus.charging ? Icons.battery_charging_full : Icons.battery_full;
      batteryColor = const Color(0xFF00E676);
    } else if (info.percentage >= 50) {
      batteryIcon = info.status == ChargingStatus.charging ? Icons.battery_charging_full : Icons.battery_4_bar;
      batteryColor = Colors.white;
    } else if (info.percentage >= 20) {
      batteryIcon = info.status == ChargingStatus.charging ? Icons.battery_charging_full : Icons.battery_2_bar;
      batteryColor = Colors.orange;
    } else {
      batteryIcon = info.status == ChargingStatus.charging ? Icons.battery_charging_full : Icons.battery_alert;
      batteryColor = Colors.redAccent;
    }

    String statusText = 'Disconnected';
    if (info.status == ChargingStatus.charging) {
      statusText = 'Charging';
    } else if (info.status == ChargingStatus.full) {
      statusText = 'Full';
    } else if (info.status == ChargingStatus.unknown) {
      statusText = 'Unknown';
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0C),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(batteryIcon, color: batteryColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  'POWER & BATTERY',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('Battery Level', '${info.percentage}%', textColor: batteryColor),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('Status', statusText),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('Health', info.health),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow(
            'Temperature',
            info.temperature != null ? '${info.temperature!.toStringAsFixed(1)} °C' : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
