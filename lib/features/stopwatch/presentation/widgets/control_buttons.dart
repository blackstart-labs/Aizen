import 'package:flutter/material.dart';
import '../bloc/stopwatch_state.dart';
import '../../../../core/theme/aizen_theme.dart';

class ControlButtons extends StatelessWidget {
  final StopwatchStatus status;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onLap;

  const ControlButtons({
    super.key,
    required this.status,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onLap,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = status == StopwatchStatus.running;
    final isPaused = status == StopwatchStatus.paused;
    final isInitial = status == StopwatchStatus.initial;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isInitial) ...[
            _buildButton(
              context: context,
              label: 'START',
              onPressed: onStart,
              color: AizenTheme.primaryPurple,
              textColor: Colors.black,
              icon: Icons.play_arrow_rounded,
            ),
          ],
          if (isRunning) ...[
            _buildButton(
              context: context,
              label: 'LAP',
              onPressed: onLap,
              color: AizenTheme.surfaceHigh,
              textColor: AizenTheme.textPrimary,
              icon: Icons.flag_outlined,
              isOutlined: true,
            ),
            const SizedBox(width: 16),
            _buildButton(
              context: context,
              label: 'PAUSE',
              onPressed: onPause,
              color: AizenTheme.accentRed,
              textColor: Colors.black,
              icon: Icons.pause_rounded,
            ),
          ],
          if (isPaused) ...[
            _buildButton(
              context: context,
              label: 'RESET',
              onPressed: onReset,
              color: AizenTheme.surfaceHigh,
              textColor: AizenTheme.accentRed,
              icon: Icons.refresh_rounded,
              isOutlined: true,
            ),
            const SizedBox(width: 16),
            _buildButton(
              context: context,
              label: 'RESUME',
              onPressed: onStart,
              color: AizenTheme.accentGreen,
              textColor: Colors.black,
              icon: Icons.play_arrow_rounded,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
    required IconData icon,
    bool isOutlined = false,
  }) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 160),
        child: AizenPressable(
          onTap: () {
            AizenHaptics.light();
            onPressed();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isOutlined ? Colors.transparent : color,
              borderRadius: BorderRadius.circular(AizenTheme.shapeSm),
              border: isOutlined
                  ? Border.all(color: textColor.withValues(alpha: 0.2), width: 1.5)
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: textColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
