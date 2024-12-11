//IM-2021-066

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = '0';
  String _currentInput = '';
  String _previousInput = '';
  String _operator = '';
  bool _isError = false;

  // List to store all calculations
  List<String> _calculationHistory = [];

  // Handle button presses
  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        output = '0';
        _currentInput = '';
        _previousInput = '';
        _operator = '';
        _isError = false;
        _calculationHistory.clear(); // Clear calculation history
      } else if (buttonText == 'C') {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          output = _currentInput.isEmpty ? '0' : _currentInput;
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        if (_currentInput.isNotEmpty) {
          if (_previousInput.isNotEmpty && _operator.isNotEmpty) {
            _calculate();
          }

          _previousInput = _currentInput;
          _currentInput = '';
          _operator = buttonText;
          output = _previousInput + ' ' + _operator;
        }
      } else if (buttonText == '=') {
        if (_operator.isNotEmpty && _previousInput.isNotEmpty && _currentInput.isNotEmpty) {
          _calculate();
        }
      } else if (buttonText == '√') {
        if (_currentInput.isNotEmpty) {
          double num = double.parse(_currentInput);
          if (num < 0) {
            _isError = true;
            output = 'Error: Negative Root';
            _addToHistory('√$_currentInput = Error');
          } else {
            double result = sqrt(num);
            _addToHistory('√$_currentInput = $result');
            _currentInput = result.toString();
            output = _currentInput;
            _previousInput = '';
            _operator = '';
          }
        }
      } else if (buttonText == '%') {
        if (_currentInput.isNotEmpty) {
          double num = double.parse(_currentInput);
          if (_previousInput.isNotEmpty && _operator.isNotEmpty) {
            double base = double.parse(_previousInput);
            _currentInput = (base * num / 100).toString();
          } else {
            _currentInput = (num / 100).toString();
          }
          _addToHistory('$_currentInput% = ${output}');
          output = _currentInput;
        }
      } else {
        if (_isError) {
          output = '0';
          _isError = false;
        }
        if (buttonText == '.' && _currentInput.contains('.')) return;
        _currentInput += buttonText;

        // Update display with complete expression
        output = _previousInput +
            ' ' +
            _operator +
            ' ' +
            _currentInput;
      }
    });
  }

  // Helper function to calculate and update the result
  void _calculate() {
    try {
      double num1 = double.parse(_previousInput);
      double num2 = double.parse(_currentInput);
      double result = 0;

      switch (_operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '×':
          result = num1 * num2;
          break;
        case '÷':
          if (num2 == 0) {
            _isError = true;
            output = "Can't divide by 0";
            return;
          }
          result = num1 / num2;
          break;
      }

      output = (result == result.toInt())
          ? result.toInt().toString()
          : result.toString();

      _addToHistory('$_previousInput $_operator $_currentInput = $output');
      _currentInput = output;
      _previousInput = '';
      _operator = '';
    } catch (e) {
      _isError = true;
      output = 'Error';
    }
  }

  // Add calculation to history
  void _addToHistory(String calculation) {
    setState(() {
      _calculationHistory.insert(0, calculation); // Add to the top of the list
    });
  }

  // Create a button widget
  Widget buildButton(String text, Color textColor, Color backgroundColor) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () => buttonPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 30, color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Calculation history
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _calculationHistory.length,
                itemBuilder: (context, index) {
                  return Text(
                    _calculationHistory[index],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  );
                },
              ),
            ),
            // Display
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                output,
                style: const TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20), // Space between display and buttons

            // Buttons
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton('AC', Colors.black, Colors.grey),
                    buildButton('C', Colors.black, Colors.grey),
                    buildButton('%', Colors.white, Colors.teal),
                    buildButton('÷', Colors.white, Colors.teal),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton('7', Colors.white, Colors.grey[800]!),
                    buildButton('8', Colors.white, Colors.grey[800]!),
                    buildButton('9', Colors.white, Colors.grey[800]!),
                    buildButton('×', Colors.white, Colors.teal),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton('4', Colors.white, Colors.grey[800]!),
                    buildButton('5', Colors.white, Colors.grey[800]!),
                    buildButton('6', Colors.white, Colors.grey[800]!),
                    buildButton('-', Colors.white, Colors.teal),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton('1', Colors.white, Colors.grey[800]!),
                    buildButton('2', Colors.white, Colors.grey[800]!),
                    buildButton('3', Colors.white, Colors.grey[800]!),
                    buildButton('+', Colors.white, Colors.teal),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton('0', Colors.white, Colors.grey[800]!),
                    buildButton('√', Colors.white, Colors.teal),
                    buildButton('.', Colors.white, Colors.teal),
                    buildButton('=', Colors.white, Colors.teal),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
