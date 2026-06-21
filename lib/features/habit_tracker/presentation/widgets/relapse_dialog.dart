import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/relapse_log.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';

class RelapseDialog extends StatefulWidget {
  final String habitId;

  const RelapseDialog({super.key, required this.habitId});

  @override
  State<RelapseDialog> createState() => _RelapseDialogState();
}

class _RelapseDialogState extends State<RelapseDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRootCause = 'Stress';
  final _triggerController = TextEditingController();
  final _notesController = TextEditingController();
  int _severity = 3;

  final List<String> _rootCauses = [
    'Stress',
    'Fatigue',
    'Boredom',
    'Social pressure',
    'Anxiety',
    'Loneliness',
    'Other'
  ];

  final List<String> _quickTriggers = [
    'Work/Study fatigue',
    'Late night scrolling',
    'Negative thoughts',
    'Peer pressure',
    'Unstructured time',
  ];

  @override
  void dispose() {
    _triggerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final log = RelapseLog(
        id: UniqueKey().toString(),
        habitId: widget.habitId,
        timestamp: DateTime.now(),
        rootCause: _selectedRootCause,
        trigger: _triggerController.text.trim(),
        severity: _severity,
        notes: _notesController.text.trim(),
      );

      context.read<HabitBloc>().add(ResetHabitEvent(id: widget.habitId, log: log));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF161618),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'RELAPSE JOURNAL & NOTES',
                  style: TextStyle(
                    color: Color(0xFFFF5252),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Root Cause Category',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0F10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRootCause,
                      dropdownColor: const Color(0xFF161618),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      isExpanded: true,
                      items: _rootCauses.map((cause) {
                        return DropdownMenuItem<String>(
                          value: cause,
                          child: Text(cause),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedRootCause = val;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Trigger Context',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _triggerController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'What sparked the relapse?',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 13),
                    fillColor: const Color(0xFF0F0F10),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Trigger is required' : null,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _quickTriggers.map((trig) {
                    return ActionChip(
                      label: Text(trig),
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
                      backgroundColor: const Color(0xFF0F0F10),
                      side: const BorderSide(color: Color(0xFF1E1E20)),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        setState(() {
                          _triggerController.text = trig;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Severity Level',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Level $_severity',
                      style: const TextStyle(color: Color(0xFFFF5252), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    activeTrackColor: const Color(0xFFFF5252),
                    inactiveTrackColor: const Color(0xFF1E1E20),
                    thumbColor: const Color(0xFFFF5252),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayColor: const Color(0xFFFF5252).withValues(alpha: 0.2),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  ),
                  child: Slider(
                    value: _severity.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (val) {
                      setState(() {
                        _severity = val.toInt();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Post-Relapse Reflection / Journal Note',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _notesController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Reflect on what to adjust for the next attempt...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 12),
                    fillColor: const Color(0xFF0F0F10),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('CANCEL', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5252),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: _submit,
                      child: const Text(
                        'RESET STREAK',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
