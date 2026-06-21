import 'package:flutter/material.dart';
import '../../domain/entities/hardware_info.dart';

class HardwareInfoPanel extends StatelessWidget {
  final HardwareInfo info;

  const HardwareInfoPanel({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
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
                const Icon(Icons.developer_board, color: Color(0xFF7C4DFF), size: 20),
                const SizedBox(width: 12),
                Text(
                  'SYSTEM HARDWARE',
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
          _buildRow('Device Model', info.model),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('Manufacturer', info.manufacturer),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('OS Version', info.osVersion),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('Kernel Architecture', info.kernelArchitecture),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('Processor Cores', '${info.cpuCores} Cores'),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('System Memory', '${(info.totalRamMB / 1024).toStringAsFixed(2)} GB (${info.totalRamMB} MB)'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
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
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
