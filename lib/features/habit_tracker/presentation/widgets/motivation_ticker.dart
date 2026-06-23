import 'dart:async';
import 'package:flutter/material.dart';

class MotivationTicker extends StatefulWidget {
  const MotivationTicker({super.key});

  @override
  State<MotivationTicker> createState() => _MotivationTickerState();
}

class _MotivationTickerState extends State<MotivationTicker> {
  final List<String> _quotes = [
    "He who has a why to live can bear almost any how. — Nietzsche",
    "Self-discipline is the only true freedom. — Epictetus",
    "We are what we repeatedly do. Excellence, then, is not an act, but a habit. — Aristotle",
    "If you are going through hell, keep going. — Winston Churchill",
    "Do not pray for an easy life, pray for the strength to endure a difficult one. — Bruce Lee",
    "Conquer yourself rather than the world. — René Descartes",
    "The secret of getting ahead is getting started. — Mark Twain",
    "The first and best victory is to conquer self. — Plato",
    "Friction builds willpower. Relapse is not defeat; it is database feedback.",
    "Show me your calendar and I will show you your future.",
    "Your habits are the atoms of your success.",
    "We must all suffer one of two things: the pain of discipline or the pain of regret. — Jim Rohn",
    "It is not that we have a short time to live, but that we waste a lot of it. — Seneca",
    "No man is free who is not master of himself. — Pythagoras",
    "Concentrate all your thoughts upon the work at hand. — Alexander Graham Bell",
    "The best way to predict the future is to create it. — Peter Drucker",
    "It does not matter how slowly you go as long as you do not stop. — Confucius",
    "Willpower is a muscle. Work it to exhaustion, then let it rebuild.",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _quotes.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF141414)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Text(
          _quotes[_currentIndex],
          key: ValueKey<int>(_currentIndex),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11,
            fontStyle: FontStyle.italic,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
