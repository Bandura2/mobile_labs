import 'dart:async';
import 'dart:math';

class RandomGenerator {
  final _random = Random();
  int _currentValue = 0;

  void start() {
    _generate();
    Timer.periodic(const Duration(seconds: 5), (_) => _generate());
  }

  void _generate() {
    _currentValue = _random.nextInt(100);
  }

  int get value => _currentValue;
}
