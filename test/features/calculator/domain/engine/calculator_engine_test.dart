import 'package:flutter_test/flutter_test.dart';
import 'package:Aizen/features/calculator/domain/engine/calculator_engine.dart';

// Comprehensive unit tests for the Aizen v1.4.2 calculator engine.
//
// Covers: arithmetic, precedence, implicit multiplication, all trig/log/exp
// functions in both DEG and RAD mode, new functions (fact, log2, sq, rec,
// asinh, acosh, atanh, gcd, lcm), error handling, and formatting.
void main() {
  const engine = CalculatorEngine();

  // ── Arithmetic ────────────────────────────────────────────────────────
  group('CalculatorEngine — basic arithmetic', () {
    test('addition', () {
      expect(engine.evaluate('2 + 3').value, 5);
    });
    test('subtraction with negative result', () {
      expect(engine.evaluate('3 - 10').value, -7);
    });
    test('multiplication', () {
      expect(engine.evaluate('6 * 7').value, 42);
    });
    test('division', () {
      expect(engine.evaluate('20 / 8').value, 2.5);
    });
    test('modulo', () {
      expect(engine.evaluate('17 % 5').value, 2);
    });
    test('division by zero fails', () {
      final r = engine.evaluate('5 / 0');
      expect(r.isSuccess, isFalse);
      expect(r.error, contains('Division by zero'));
    });
    test('modulo by zero fails', () {
      final r = engine.evaluate('5 % 0');
      expect(r.isSuccess, isFalse);
      expect(r.error, contains('Modulo by zero'));
    });
  });

  // ── Operator precedence ────────────────────────────────────────────────
  group('CalculatorEngine — operator precedence', () {
    test('2 + 3 * 4 = 14', () => expect(engine.evaluate('2 + 3 * 4').value, 14));
    test('(2 + 3) * 4 = 20', () => expect(engine.evaluate('(2 + 3) * 4').value, 20));
    test('unary minus', () {
      expect(engine.evaluate('-5 + 3').value, -2);
      expect(engine.evaluate('3 - -5').value, 8);
      expect(engine.evaluate('-(-5)').value, 5);
    });
    test('unary plus', () => expect(engine.evaluate('+5').value, 5));
    test('left-assoc subtraction', () => expect(engine.evaluate('10 - 3 - 2').value, 5));
    test('left-assoc division', () => expect(engine.evaluate('100 / 5 / 2').value, 10));
  });

  // ── Implicit multiplication ────────────────────────────────────────────
  group('CalculatorEngine — implicit multiplication', () {
    test('2(3+1) == 8', () => expect(engine.evaluate('2(3+1)').value, 8));
    test('(2)(3) == 6', () => expect(engine.evaluate('(2)(3)').value, 6));
    test('3pi close to 9.42477', () {
      expect(engine.evaluate('3pi').value, closeTo(9.42477796076938, 1e-9));
    });
    test('2sin(0) == 0', () {
      expect(engine.evaluate('2sin(0)', degMode: true).value, closeTo(0, 1e-12));
    });
  });

  // ── Trig — DEG mode ────────────────────────────────────────────────────
  group('CalculatorEngine — trig (DEG mode)', () {
    test('sin(0) = 0', () {
      expect(engine.evaluate('sin(0)', degMode: true).value, closeTo(0, 1e-12));
    });
    test('sin(30) = 0.5', () {
      expect(engine.evaluate('sin(30)', degMode: true).value, closeTo(0.5, 1e-9));
    });
    test('sin(90) = 1', () {
      expect(engine.evaluate('sin(90)', degMode: true).value, closeTo(1, 1e-9));
    });
    test('cos(0) = 1', () {
      expect(engine.evaluate('cos(0)', degMode: true).value, closeTo(1, 1e-9));
    });
    test('cos(60) = 0.5', () {
      expect(engine.evaluate('cos(60)', degMode: true).value, closeTo(0.5, 1e-9));
    });
    test('cos(180) = -1', () {
      expect(engine.evaluate('cos(180)', degMode: true).value, closeTo(-1, 1e-9));
    });
    test('tan(0) = 0', () {
      expect(engine.evaluate('tan(0)', degMode: true).value, closeTo(0, 1e-12));
    });
    test('tan(45) = 1', () {
      expect(engine.evaluate('tan(45)', degMode: true).value, closeTo(1, 1e-9));
    });
    test('tan(90) fails gracefully in DEG mode', () {
      expect(engine.evaluate('tan(90)', degMode: true).isSuccess, isFalse);
    });
    test('tan(270) fails gracefully in DEG mode', () {
      expect(engine.evaluate('tan(270)', degMode: true).isSuccess, isFalse);
    });
    test('asin(0.5) = 30', () {
      expect(engine.evaluate('asin(0.5)', degMode: true).value, closeTo(30, 1e-6));
    });
    test('acos(0.5) = 60', () {
      expect(engine.evaluate('acos(0.5)', degMode: true).value, closeTo(60, 1e-6));
    });
    test('atan(1) = 45', () {
      expect(engine.evaluate('atan(1)', degMode: true).value, closeTo(45, 1e-6));
    });
    test('asin(2) fails', () {
      expect(engine.evaluate('asin(2)', degMode: true).isSuccess, isFalse);
    });
    test('acos(-2) fails', () {
      expect(engine.evaluate('acos(-2)', degMode: true).isSuccess, isFalse);
    });
  });

  // ── Trig — RAD mode ────────────────────────────────────────────────────
  group('CalculatorEngine — trig (RAD mode)', () {
    test('sin(pi/2) = 1', () {
      expect(engine.evaluate('sin(pi/2)', degMode: false).value, closeTo(1, 1e-9));
    });
    test('cos(pi) = -1', () {
      expect(engine.evaluate('cos(pi)', degMode: false).value, closeTo(-1, 1e-9));
    });
    test('tan(pi/4) = 1', () {
      expect(engine.evaluate('tan(pi/4)', degMode: false).value, closeTo(1, 1e-9));
    });
    test('asin(1) = pi/2', () {
      expect(engine.evaluate('asin(1)', degMode: false).value, closeTo(1.5707963267948966, 1e-9));
    });
    test('atan(1) = pi/4', () {
      expect(engine.evaluate('atan(1)', degMode: false).value, closeTo(0.7853981633974483, 1e-9));
    });
  });

  // ── Hyperbolic ─────────────────────────────────────────────────────────
  group('CalculatorEngine — hyperbolic functions', () {
    test('sinh(0) = 0', () {
      expect(engine.evaluate('sinh(0)').value, closeTo(0, 1e-12));
    });
    test('cosh(0) = 1', () {
      expect(engine.evaluate('cosh(0)').value, closeTo(1, 1e-12));
    });
    test('tanh(0) = 0', () {
      expect(engine.evaluate('tanh(0)').value, closeTo(0, 1e-12));
    });
    test('tanh(1) ≈ 0.7616', () {
      expect(engine.evaluate('tanh(1)').value, closeTo(0.7615941559557649, 1e-9));
    });
    test('asinh(0) = 0', () {
      expect(engine.evaluate('asinh(0)').value, closeTo(0, 1e-12));
    });
    test('acosh(1) = 0', () {
      expect(engine.evaluate('acosh(1)').value, closeTo(0, 1e-12));
    });
    test('acosh(0) fails', () {
      expect(engine.evaluate('acosh(0)').isSuccess, isFalse);
    });
    test('atanh(0) = 0', () {
      expect(engine.evaluate('atanh(0)').value, closeTo(0, 1e-12));
    });
    test('atanh(1) fails', () {
      expect(engine.evaluate('atanh(1)').isSuccess, isFalse);
    });
    test('atanh(-1) fails', () {
      expect(engine.evaluate('atanh(-1)').isSuccess, isFalse);
    });
  });

  // ── Logarithmic / exponential ──────────────────────────────────────────
  group('CalculatorEngine — log / exp', () {
    test('log(100) = 2', () {
      expect(engine.evaluate('log(100)').value, closeTo(2, 1e-9));
    });
    test('log(1) = 0', () {
      expect(engine.evaluate('log(1)').value, closeTo(0, 1e-12));
    });
    test('log(0) fails', () {
      expect(engine.evaluate('log(0)').isSuccess, isFalse);
    });
    test('log(-1) fails', () {
      expect(engine.evaluate('log(-1)').isSuccess, isFalse);
    });
    test('log2(8) = 3', () {
      expect(engine.evaluate('log2(8)').value, closeTo(3, 1e-9));
    });
    test('log2(1) = 0', () {
      expect(engine.evaluate('log2(1)').value, closeTo(0, 1e-12));
    });
    test('log2(0) fails', () {
      expect(engine.evaluate('log2(0)').isSuccess, isFalse);
    });
    test('ln(e) = 1', () {
      expect(engine.evaluate('ln(e)').value, closeTo(1, 1e-9));
    });
    test('ln(1) = 0', () {
      expect(engine.evaluate('ln(1)').value, closeTo(0, 1e-12));
    });
    test('ln(0) fails', () {
      expect(engine.evaluate('ln(0)').isSuccess, isFalse);
    });
    test('exp(0) = 1', () {
      expect(engine.evaluate('exp(0)').value, closeTo(1, 1e-9));
    });
    test('exp(1) = e', () {
      expect(engine.evaluate('exp(1)').value, closeTo(2.718281828459045, 1e-9));
    });
    test('ln(exp(3)) = 3', () {
      expect(engine.evaluate('ln(exp(3))').value, closeTo(3, 1e-9));
    });
    test('log(10^5) = 5', () {
      expect(engine.evaluate('log(10^5)').value, closeTo(5, 1e-9));
    });
  });

  // ── Roots / powers / special ───────────────────────────────────────────
  group('CalculatorEngine — roots / powers / special', () {
    test('sqrt(16) = 4', () {
      expect(engine.evaluate('sqrt(16)').value, closeTo(4, 1e-9));
    });
    test('sqrt(2) ≈ 1.41421', () {
      expect(engine.evaluate('sqrt(2)').value, closeTo(1.41421356237, 1e-9));
    });
    test('sqrt(-1) fails', () {
      expect(engine.evaluate('sqrt(-1)').isSuccess, isFalse);
    });
    test('cbrt(27) = 3', () {
      expect(engine.evaluate('cbrt(27)').value, closeTo(3, 1e-9));
    });
    test('cbrt(-8) = -2', () {
      expect(engine.evaluate('cbrt(-8)').value, closeTo(-2, 1e-9));
    });
    test('sq(5) = 25', () {
      expect(engine.evaluate('sq(5)').value, 25);
    });
    test('sq(-3) = 9', () {
      expect(engine.evaluate('sq(-3)').value, 9);
    });
    test('rec(4) = 0.25', () {
      expect(engine.evaluate('rec(4)').value, closeTo(0.25, 1e-12));
    });
    test('rec(0) fails', () {
      expect(engine.evaluate('rec(0)').isSuccess, isFalse);
    });
    test('2^10 = 1024', () {
      expect(engine.evaluate('2^10').value, 1024);
    });
    test('2^-1 = 0.5', () {
      expect(engine.evaluate('2^-1').value, 0.5);
    });
    test('(-2)^3 = -8', () {
      expect(engine.evaluate('(-2)^3').value, -8);
    });
    test('(-2)^0.5 fails', () {
      expect(engine.evaluate('(-2)^0.5').isSuccess, isFalse);
    });
    test('abs(-5) = 5', () {
      expect(engine.evaluate('abs(-5)').value, 5);
    });
    test('sign(-3) = -1', () {
      expect(engine.evaluate('sign(-3)').value, -1);
    });
    test('sign(7) = 1', () {
      expect(engine.evaluate('sign(7)').value, 1);
    });
    test('sign(0) = 0', () {
      expect(engine.evaluate('sign(0)').value, 0);
    });
  });

  // ── Factorial / GCD / LCM ─────────────────────────────────────────────
  group('CalculatorEngine — factorial / gcd / lcm', () {
    test('fact(0) = 1', () {
      expect(engine.evaluate('fact(0)').value, 1);
    });
    test('fact(1) = 1', () {
      expect(engine.evaluate('fact(1)').value, 1);
    });
    test('fact(5) = 120', () {
      expect(engine.evaluate('fact(5)').value, 120);
    });
    test('fact(10) = 3628800', () {
      expect(engine.evaluate('fact(10)').value, 3628800);
    });
    test('fact(-1) fails', () {
      expect(engine.evaluate('fact(-1)').isSuccess, isFalse);
    });
    test('fact(1.5) fails', () {
      expect(engine.evaluate('fact(1.5)').isSuccess, isFalse);
    });
    test('gcd(12, 8) = 4', () {
      expect(engine.evaluate('gcd(12, 8)').value, 4);
    });
    test('gcd(7, 5) = 1', () {
      expect(engine.evaluate('gcd(7, 5)').value, 1);
    });
    test('lcm(4, 6) = 12', () {
      expect(engine.evaluate('lcm(4, 6)').value, 12);
    });
  });

  // ── Rounding / variadic ────────────────────────────────────────────────
  group('CalculatorEngine — rounding / variadic', () {
    test('round(3.6) = 4', () => expect(engine.evaluate('round(3.6)').value, 4));
    test('round(3.4) = 3', () => expect(engine.evaluate('round(3.4)').value, 3));
    test('floor(3.9) = 3', () => expect(engine.evaluate('floor(3.9)').value, 3));
    test('ceil(3.1) = 4',  () => expect(engine.evaluate('ceil(3.1)').value, 4));
    test('trunc(3.9) = 3', () => expect(engine.evaluate('trunc(3.9)').value, 3));
    test('trunc(-3.9) = -3', () => expect(engine.evaluate('trunc(-3.9)').value, -3));
    test('max(1,2,3) = 3', () => expect(engine.evaluate('max(1,2,3)').value, 3));
    test('min(5,3,7) = 3', () => expect(engine.evaluate('min(5,3,7)').value, 3));
  });

  // ── Constants ──────────────────────────────────────────────────────────
  group('CalculatorEngine — constants', () {
    test('pi', () => expect(engine.evaluate('pi').value, closeTo(3.141592653589793, 1e-15)));
    test('e',  () => expect(engine.evaluate('e').value,  closeTo(2.718281828459045, 1e-15)));
    test('tau', () => expect(engine.evaluate('tau').value, closeTo(6.283185307179586, 1e-15)));
    test('phi', () => expect(engine.evaluate('phi').value, closeTo(1.6180339887498949, 1e-15)));
  });

  // ── Error handling ─────────────────────────────────────────────────────
  group('CalculatorEngine — error handling', () {
    test('empty expression', () {
      expect(engine.evaluate('').isSuccess, isFalse);
      expect(engine.evaluate('   ').isSuccess, isFalse);
    });
    test('unbalanced open paren', () {
      expect(engine.evaluate('(2+3').isSuccess, isFalse);
    });
    test('unbalanced close paren', () {
      expect(engine.evaluate('2+3)').isSuccess, isFalse);
    });
    test('unknown function', () {
      expect(engine.evaluate('foobar(2)').isSuccess, isFalse);
    });
    test('unknown constant', () {
      expect(engine.evaluate('xyzzy').isSuccess, isFalse);
    });
    test('unexpected character', () {
      expect(engine.evaluate('2 @ 3').isSuccess, isFalse);
    });
  });

  // ── Formatting ─────────────────────────────────────────────────────────
  group('CalculatorEngine — formatting', () {
    test('integer no decimal', () {
      expect(CalculatorResult.format(5), '5');
      expect(CalculatorResult.format(-42), '-42');
    });
    test('decimal trims trailing zeros', () {
      expect(CalculatorResult.format(2.5), '2.5');
      expect(CalculatorResult.format(1.25000000), '1.25');
    });
    test('NaN formats as Error', () {
      expect(CalculatorResult.format(double.nan), 'Error');
    });
    test('Infinity formats as ∞', () {
      expect(CalculatorResult.format(double.infinity), '∞');
      expect(CalculatorResult.format(double.negativeInfinity), '-∞');
    });
    test('10/4 formatted = 2.5', () {
      expect(engine.evaluate('10 / 4').formatted, '2.5');
    });
  });

  // ── Complex expressions ────────────────────────────────────────────────
  group('CalculatorEngine — complex expressions', () {
    test('sin(30)*2 + (3-1)^3 = 9', () {
      expect(engine.evaluate('sin(30)*2 + (3-1)^3', degMode: true).value,
          closeTo(9, 1e-9));
    });
    test('pi * 1^2 = pi', () {
      expect(engine.evaluate('pi * 1^2').value,
          closeTo(3.141592653589793, 1e-12));
    });
    test('abs(sin(180)) = 0', () {
      expect(engine.evaluate('abs(sin(180))', degMode: true).value,
          closeTo(0, 1e-9));
    });
    test('sqrt(sq(3) + sq(4)) = 5 (Pythagorean triple)', () {
      expect(engine.evaluate('sqrt(sq(3) + sq(4))').value, closeTo(5, 1e-9));
    });
    test('fact(5) + sq(3) = 129', () {
      expect(engine.evaluate('fact(5) + sq(3)').value, 129);
    });
  });
}
