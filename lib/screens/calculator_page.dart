import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _firstOperand;
  String? _operator;
  bool _waitingForSecondOperand = false;

  int get _digitCount => _display.replaceAll(RegExp(r'[^0-9]'), '').length;

  void _onDigitPress(String digit) {
    setState(() {
      if (_waitingForSecondOperand) {
        _display = digit;
        _waitingForSecondOperand = false;
        return;
      }
      if (_display == '0') {
        _display = digit;
      } else if (_digitCount < 10) {
        _display += digit;
      }
    });
  }

  void _onDecimalPress() {
    setState(() {
      if (_waitingForSecondOperand) {
        _display = '0.';
        _waitingForSecondOperand = false;
        return;
      }
      if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onOperatorPress(String op) {
    setState(() {
      _firstOperand = double.tryParse(_display) ?? 0;
      _operator = op;
      _waitingForSecondOperand = true;
    });
  }

  void _onClear() {
    setState(() {
      _display = '0';
      _firstOperand = null;
      _operator = null;
      _waitingForSecondOperand = false;
    });
  }

  void _onEquals() {
    if (_firstOperand == null || _operator == null) return;
    final second = double.tryParse(_display) ?? 0;
    double result;
    switch (_operator) {
      case '+':
        result = _firstOperand! + second;
        break;
      case '-':
        result = _firstOperand! - second;
        break;
      case '×':
        result = _firstOperand! * second;
        break;
      case '÷':
        if (second == 0) {
          _display = 'ERR';
          setState(() {});
          return;
        }
        result = _firstOperand! / second;
        break;
      default:
        return;
    }
    String text = result.toStringAsFixed(10);
    text = text.replaceFirst(RegExp(r'\.0+\$'), '');
    text = text.replaceFirst(RegExp(r'(\.\d+?)0+\$'), r'$1');
    if (text.replaceAll(RegExp(r'[^0-9]'), '').length > 10) {
      _display = 'ERR';
    } else {
      _display = text;
    }
    _firstOperand = null;
    _operator = null;
    _waitingForSecondOperand = false;
    setState(() {});
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('電卓'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(16),
            child: Text(
              _display,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('7', () => _onDigitPress('7')),
                    _buildButton('8', () => _onDigitPress('8')),
                    _buildButton('9', () => _onDigitPress('9')),
                    _buildButton('÷', () => _onOperatorPress('÷')),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4', () => _onDigitPress('4')),
                    _buildButton('5', () => _onDigitPress('5')),
                    _buildButton('6', () => _onDigitPress('6')),
                    _buildButton('×', () => _onOperatorPress('×')),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1', () => _onDigitPress('1')),
                    _buildButton('2', () => _onDigitPress('2')),
                    _buildButton('3', () => _onDigitPress('3')),
                    _buildButton('-', () => _onOperatorPress('-')),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('C', _onClear),
                    _buildButton('0', () => _onDigitPress('0')),
                    _buildButton('.', _onDecimalPress),
                    _buildButton('+', () => _onOperatorPress('+')),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('=', _onEquals),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
