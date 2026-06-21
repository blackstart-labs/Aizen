import 'package:flutter/material.dart';
import '../../domain/entities/storage_info.dart';

class StorageInfoPanel extends StatelessWidget {
  final StorageInfo info;

  const StorageInfoPanel({super.key, required this.info});

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
                const Icon(Icons.storage, color: Color(0xFF00E676), size: 20),
                const SizedBox(width: 12),
                Text(
                  'SYSTEM STORAGE',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Used Space (${info.usedPercent.toStringAsFixed(1)}%)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Free Space (${info.freePercent.toStringAsFixed(1)}%)',
                      style: TextStyle(
                        color: const Color(0xFF00E676).withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 10,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: (info.usedPercent * 100).toInt().clamp(1, 1000000),
                          child: Container(color: const Color(0xFF7C4DFF)),
                        ),
                        Expanded(
                          flex: (info.freePercent * 100).toInt().clamp(1, 1000000),
                          child: Container(color: const Color(0xFF00E676)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('Total Storage', '${info.totalGB.toStringAsFixed(2)} GB'),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('Used Space', '${info.usedGB.toStringAsFixed(2)} GB', dotColor: const Color(0xFF7C4DFF)),
          const Divider(height: 1, color: Color(0x13FFFFFF)),
          _buildRow('Free Space', '${info.freeGB.toStringAsFixed(2)} GB', dotColor: const Color(0xFF00E676)),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? dotColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
