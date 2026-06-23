import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/engine/calculator_engine.dart';
import 'package:Aizen/core/theme/aizen_theme.dart';

// ---------------------------------------------------------------------------
// Scientific Calculator Page — Aizen v1.4.2
//
// Layout: portrait-only, full-grid (no horizontal scroll strip).
//   Row 0  : DEG/RAD · 2nd · mode-aware sci functions (4 per row)
//   Row 1–4: sci functions (4 × 4 = 16 keys, shift-aware)
//   Row 5  : memory  MC  MR  M+  M-  (4 keys)
//   Row 6–9: main    7 8 9 ÷ / 4 5 6 × / 1 2 3 − / . 0 % +
//   Row 10 : AC  ⌫  =
// ---------------------------------------------------------------------------

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _engine = const CalculatorEngine();

  String _expression = '';
  String _preview = '0';
  String? _error;
  double _memory = 0;
  bool _isDeg = true;
  bool _isShift = false; // 2nd mode for inverse / hyperbolic

  final List<String> _history = [];

  // ── Expression helpers ─────────────────────────────────────────────────
  void _append(String token) {
    HapticFeedback.selectionClick();
    setState(() {
      _error = null;
      _expression += token;
      _recomputePreview();
    });
  }

  void _backspace() {
    HapticFeedback.lightImpact();
    setState(() {
      _error = null;
      if (_expression.isEmpty) return;
      final lastChar = _expression[_expression.length - 1];
      if (RegExp(r'[a-zA-Z]').hasMatch(lastChar)) {
        var i = _expression.length - 1;
        while (i > 0 && RegExp(r'[a-zA-Z]').hasMatch(_expression[i - 1])) {
          i--;
        }
        _expression = _expression.substring(0, i);
      } else {
        _expression = _expression.substring(0, _expression.length - 1);
      }
      _recomputePreview();
    });
  }

  void _clear() {
    HapticFeedback.mediumImpact();
    setState(() {
      _expression = '';
      _preview = '0';
      _error = null;
    });
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      _expression = '';
      _preview = '0';
      _error = null;
      _memory = 0;
      _history.clear();
    });
  }

  void _evaluate() {
    if (_expression.trim().isEmpty) return;
    HapticFeedback.mediumImpact();
    final result = _engine.evaluate(_expression, degMode: _isDeg);
    setState(() {
      if (result.isSuccess) {
        final formatted = result.formatted;
        _history.insert(0, '$_expression = $formatted');
        if (_history.length > 20) _history.removeLast();
        _expression = formatted;
        _preview = formatted;
        _error = null;
      } else {
        _error = result.error;
        _preview = 'Error';
      }
    });
  }

  void _recomputePreview() {
    if (_expression.trim().isEmpty) {
      _preview = '0';
      _error = null;
      return;
    }
    final result = _engine.evaluate(_expression, degMode: _isDeg);
    if (result.isSuccess) {
      _preview = result.formatted;
      _error = null;
    } else {
      _preview = '…';
      _error = null;
    }
  }

  void _toggleDeg() {
    HapticFeedback.lightImpact();
    setState(() {
      _isDeg = !_isDeg;
      _recomputePreview();
    });
  }

  void _toggleShift() {
    HapticFeedback.lightImpact();
    setState(() => _isShift = !_isShift);
  }

  void _memoryOp(String op) {
    HapticFeedback.selectionClick();
    setState(() {
      switch (op) {
        case 'MC':
          _memory = 0;
          break;
        case 'MR':
          _expression += CalculatorResult.format(_memory);
          _recomputePreview();
          break;
        case 'M+':
          final r = _engine.evaluate(_expression, degMode: _isDeg);
          if (r.isSuccess) _memory += r.value;
          break;
        case 'M-':
          final r = _engine.evaluate(_expression, degMode: _isDeg);
          if (r.isSuccess) _memory -= r.value;
          break;
      }
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AizenTheme.amoledBlack,
      appBar: AppBar(
        backgroundColor: AizenTheme.amoledBlack,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Scientific Calculator'),
        actions: [
          // History button
          IconButton(
            icon: const Icon(Icons.history, size: 20),
            onPressed: _showHistory,
          ),
          // Clear-all button
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, size: 20),
            onPressed: _clearAll,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildDisplay(),
            Expanded(child: _buildKeypad()),
          ],
        ),
      ),
    );
  }

  // ── Display panel ────────────────────────────────────────────────────
  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      decoration: const BoxDecoration(
        color: AizenTheme.surfaceLow,
        border: Border(bottom: BorderSide(color: AizenTheme.hairlineBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Status badges row
          Row(
            children: [
              _badge(
                _isDeg ? 'DEG' : 'RAD',
                _isDeg ? AizenTheme.accentCyan : AizenTheme.accentGreen,
                onTap: _toggleDeg,
              ),
              const SizedBox(width: 6),
              if (_memory != 0)
                _badge(
                  'M ${CalculatorResult.format(_memory)}',
                  AizenTheme.accentAmber,
                ),
              const Spacer(),
              if (_isShift)
                _badge('2ND', AizenTheme.primaryPurple),
            ],
          ),
          const SizedBox(height: 8),
          // Expression
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 52),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                _expression.isEmpty ? ' ' : _expression,
                style: const TextStyle(
                  color: AizenTheme.textSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          // Preview / result
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 58),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                _preview,
                style: TextStyle(
                  color: _error != null
                      ? AizenTheme.accentRed
                      : AizenTheme.textPrimary,
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                ),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 2),
            Text(
              _error!,
              style: const TextStyle(
                color: AizenTheme.accentRed,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _badge(String label, Color color, {VoidCallback? onTap}) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: child);
    }
    return child;
  }

  // ── Full keypad grid ──────────────────────────────────────────────────
  Widget _buildKeypad() {
    return Container(
      color: AizenTheme.amoledBlack,
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 4),
      child: Column(
        children: [
          // ── Scientific functions row 1 ────────────────────────────
          Expanded(
            child: Row(children: [
              _sciBtn(
                label: _isShift ? 'sin⁻¹' : 'sin',
                token: _isShift ? 'asin(' : 'sin(',
                color: AizenTheme.primaryPurple,
              ),
              _sciBtn(
                label: _isShift ? 'cos⁻¹' : 'cos',
                token: _isShift ? 'acos(' : 'cos(',
                color: AizenTheme.primaryPurple,
              ),
              _sciBtn(
                label: _isShift ? 'tan⁻¹' : 'tan',
                token: _isShift ? 'atan(' : 'tan(',
                color: AizenTheme.primaryPurple,
              ),
              _sciBtn(
                label: _isShift ? 'sinh' : 'log',
                token: _isShift ? 'sinh(' : 'log(',
                color: AizenTheme.accentCyan,
              ),
            ]),
          ),
          // ── Scientific functions row 2 ────────────────────────────
          Expanded(
            child: Row(children: [
              _sciBtn(
                label: _isShift ? 'cosh' : 'ln',
                token: _isShift ? 'cosh(' : 'ln(',
                color: AizenTheme.accentCyan,
              ),
              _sciBtn(
                label: _isShift ? 'tanh' : '√',
                token: _isShift ? 'tanh(' : 'sqrt(',
                color: AizenTheme.accentCyan,
              ),
              _sciBtn(
                label: _isShift ? '∛' : 'xʸ',
                token: _isShift ? 'cbrt(' : '^',
                color: AizenTheme.accentAmber,
              ),
              _sciBtn(
                label: _isShift ? 'abs' : 'exp',
                token: _isShift ? 'abs(' : 'exp(',
                color: AizenTheme.accentCyan,
              ),
            ]),
          ),
          // ── Scientific functions row 3 ────────────────────────────
          Expanded(
            child: Row(children: [
              _sciBtn(
                label: 'π',
                token: 'pi',
                color: AizenTheme.accentGreen,
              ),
              _sciBtn(
                label: 'e',
                token: 'e',
                color: AizenTheme.accentGreen,
              ),
              _sciBtn(
                label: '(',
                token: '(',
                color: AizenTheme.accentAmber,
              ),
              _sciBtn(
                label: ')',
                token: ')',
                color: AizenTheme.accentAmber,
              ),
            ]),
          ),
          // ── Memory + 2nd row ─────────────────────────────────────
          Expanded(
            child: Row(children: [
              _memBtn('MC'),
              _memBtn('MR'),
              _memBtn('M+'),
              _memBtn('M-'),
              _shiftBtn(),
            ]),
          ),
          // ── Numeric rows ─────────────────────────────────────────
          Expanded(child: Row(children: [
            _numBtn('7'), _numBtn('8'), _numBtn('9'), _opBtn('÷', '/'),
          ])),
          Expanded(child: Row(children: [
            _numBtn('4'), _numBtn('5'), _numBtn('6'), _opBtn('×', '*'),
          ])),
          Expanded(child: Row(children: [
            _numBtn('1'), _numBtn('2'), _numBtn('3'), _opBtn('−', '-'),
          ])),
          Expanded(child: Row(children: [
            _numBtn('.'), _numBtn('0'), _opBtn('%', '%'), _opBtn('+', '+'),
          ])),
          // ── Action row ───────────────────────────────────────────
          Expanded(
            child: Row(children: [
              _actionBtn(
                label: 'AC',
                color: AizenTheme.accentRed,
                onTap: _clear,
                flex: 1,
              ),
              _actionBtn(
                label: '⌫',
                color: AizenTheme.accentAmber,
                onTap: _backspace,
                flex: 1,
              ),
              _actionBtn(
                label: '=',
                color: AizenTheme.primaryPurple,
                onTap: _evaluate,
                flex: 2,
                filled: true,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // ── Key builders ──────────────────────────────────────────────────────
  Widget _sciBtn({
    required String label,
    required String token,
    required Color color,
  }) {
    return Expanded(
      child: _key(
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        bg: AizenTheme.surfaceHigh,
        onTap: () => _append(token),
      ),
    );
  }

  Widget _memBtn(String label) {
    return Expanded(
      child: _key(
        child: Text(
          label,
          style: const TextStyle(
            color: AizenTheme.accentAmber,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        bg: AizenTheme.surfaceHigh,
        onTap: () => _memoryOp(label),
      ),
    );
  }

  Widget _shiftBtn() {
    return Expanded(
      child: _key(
        child: Text(
          '2nd',
          style: TextStyle(
            color: _isShift ? Colors.black : AizenTheme.primaryPurple,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        bg: _isShift
            ? AizenTheme.primaryPurple
            : AizenTheme.primaryPurple.withValues(alpha: 0.15),
        onTap: _toggleShift,
      ),
    );
  }

  Widget _numBtn(String label) {
    return Expanded(
      child: _key(
        child: Text(
          label,
          style: const TextStyle(
            color: AizenTheme.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        bg: AizenTheme.surfaceMid,
        onTap: () => _append(label),
      ),
    );
  }

  Widget _opBtn(String display, String token) {
    return Expanded(
      child: _key(
        child: Text(
          display,
          style: const TextStyle(
            color: AizenTheme.primaryPurple,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        bg: AizenTheme.surfaceHigh,
        onTap: () => _append(token),
      ),
    );
  }

  Widget _actionBtn({
    required String label,
    required Color color,
    required VoidCallback onTap,
    int flex = 1,
    bool filled = false,
  }) {
    return Expanded(
      flex: flex,
      child: _key(
        child: Text(
          label,
          style: TextStyle(
            color: filled ? Colors.black : color,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        bg: filled ? color : color.withValues(alpha: 0.14),
        onTap: onTap,
      ),
    );
  }

  Widget _key({
    required Widget child,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }

  // ── History sheet ─────────────────────────────────────────────────────
  void _showHistory() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.65,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
                  child: Row(
                    children: [
                      const Text(
                        'History',
                        style: TextStyle(
                          color: AizenTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (_history.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() => _history.clear());
                            Navigator.pop(ctx);
                          },
                          child: const Text('Clear'),
                        ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: _history.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              'No calculations yet',
                              style: TextStyle(
                                color: AizenTheme.textTertiary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: _history.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            color: AizenTheme.hairlineBorder,
                          ),
                          itemBuilder: (ctx, i) {
                            final entry = _history[i];
                            final eqIdx = entry.lastIndexOf(' = ');
                            final expr = eqIdx > 0
                                ? entry.substring(0, eqIdx)
                                : entry;
                            final res =
                                eqIdx > 0 ? entry.substring(eqIdx + 3) : '';
                            return ListTile(
                              dense: true,
                              title: Text(
                                expr,
                                style: const TextStyle(
                                  color: AizenTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Text(
                                res,
                                style: const TextStyle(
                                  color: AizenTheme.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _expression = res;
                                  _recomputePreview();
                                });
                                Navigator.pop(ctx);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
