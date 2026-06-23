import 'package:flutter/material.dart';
import '../../domain/entities/habit.dart';

class FailureLedger extends StatelessWidget {
  final Habit habit;

  const FailureLedger({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final attempts = habit.pastAttempts;

    // Calculate aggregated statistics
    final Map<String, int> causeFrequency = {};
    for (var att in attempts) {
      causeFrequency[att.rootCause] = (causeFrequency[att.rootCause] ?? 0) + 1;
    }

    final sortedCauses = causeFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'FAILURE LEDGER: ${habit.title.toUpperCase()}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 20),
        centerTitle: false,
      ),
      body: attempts.isEmpty
          ? const Center(
              child: Text(
                'NO RELAPSE RECORDS DETECTED.\nSTREAK UNBROKEN.',
                style: TextStyle(
                  color: Color(0xFF00E676),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aggregated trigger insights card
                  if (sortedCauses.isNotEmpty) ...[
                    const Text(
                      'TRIGGER ANOMALY ANALYSIS',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF141414)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Most Frequent Root Causes:',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...sortedCauses.take(3).map((entry) {
                            final double pct = attempts.isEmpty ? 0 : entry.value / attempts.length;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: const TextStyle(color: Color(0xFFFF5252), fontSize: 11),
                                      ),
                                      Text(
                                        '${entry.value} times (${(pct * 100).toInt()}%)',
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: pct,
                                    backgroundColor: const Color(0xFF1E1E1E),
                                    color: const Color(0xFFFF5252),
                                    minHeight: 3,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Relapse Timeline Ledger
                  const Text(
                    'HISTORICAL TIMELINE',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: attempts.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      // Reverse order to show latest failures first
                      final att = attempts[attempts.length - 1 - index];
                      final startStr = '${att.startDate.month}/${att.startDate.day}';
                      final endStr = '${att.endDate.month}/${att.endDate.day}/${att.endDate.year}';

                      // Find matching notes if present
                      final matchLog = habit.relapseLogs.firstWhere(
                        (l) => l.timestamp.millisecondsSinceEpoch == att.endDate.millisecondsSinceEpoch,
                        orElse: () => habit.relapseLogs.last,
                      );

                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF080808),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF1E1E1E)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0x1AFF5252),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color(0xFFFF5252)),
                                      ),
                                      child: Text(
                                        '${att.durationDays} DAYS',
                                        style: const TextStyle(
                                          color: Color(0xFFFF5252),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$startStr ➔ $endStr',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.5),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF141414),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    att.rootCause.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Trigger: ',
                                    style: TextStyle(
                                      color: Color(0xFFFF5252),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: att.trigger,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (matchLog.notes.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Note: "${matchLog.notes}"',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
