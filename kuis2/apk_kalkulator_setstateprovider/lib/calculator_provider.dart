import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider Class - ChangeNotifier
class CalculatorProvider extends ChangeNotifier {
  String _display = '0';
  String _firstOperand = '';
  String _operator = '';
  bool _waitingForSecondOperand = false;

  String get display => _display;
  String get firstOperand => _firstOperand;
  String get operator => _operator;
  bool get waitingForSecondOperand => _waitingForSecondOperand;

  void inputDigit(int digit) {
    if (_waitingForSecondOperand) {
      _display = digit.toString();
      _waitingForSecondOperand = false;
    } else {
      _display = _display == '0' ? digit.toString() : _display + digit.toString();
    }
    notifyListeners();
  }

  void inputDecimal() {
    if (_waitingForSecondOperand) {
      _display = '0.';
      _waitingForSecondOperand = false;
      notifyListeners();
      return;
    }
    if (!_display.contains('.')) {
      _display += '.';
      notifyListeners();
    }
  }

  void clear() {
    _display = '0';
    _firstOperand = '';
    _operator = '';
    _waitingForSecondOperand = false;
    notifyListeners();
  }

  void performOperation(String nextOperator) {
    final inputValue = double.parse(_display);

    if (_firstOperand.isEmpty) {
      _firstOperand = inputValue.toString();
    } else if (_operator.isNotEmpty) {
      final result = _calculate(
        double.parse(_firstOperand),
        inputValue,
        _operator,
      );
      _display = result.toString();
      _firstOperand = result.toString();
    }

    _waitingForSecondOperand = true;
    _operator = nextOperator;
    notifyListeners();
  }

  double _calculate(double first, double second, String op) {
    switch (op) {
      case '+':
        return first + second;
      case '-':
        return first - second;
      case '×':
        return first * second;
      case '÷':
        return first / second;
      default:
        return second;
    }
  }
}

// Calculator UI Widget (Consumer)
class CalculatorProviderPage extends StatelessWidget {
  const CalculatorProviderPage({super.key});

  Widget buildButton(
    BuildContext context,
    String text, {
    Color? bgColor,
    Color? textColor,
    int? flex,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      flex: flex ?? 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? Colors.white,
            foregroundColor: textColor ?? Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            elevation: 4,
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade600,
      appBar: AppBar(
        title: const Text('Kalkulator (Provider)'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Consumer<CalculatorProvider>(
            builder: (context, calculator, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade500, Colors.purple.shade500],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.settings, color: Colors.white, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'Kalkulator (Provider)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    color: Colors.grey.shade900,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (calculator.operator.isNotEmpty)
                          Text(
                            '${calculator.firstOperand} ${calculator.operator}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          calculator.display,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Buttons
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade50,
                    child: Column(
                      children: [
                        // Row 1
                        Row(
                          children: [
                            buildButton(
                              context,
                              'C',
                              flex: 2,
                              bgColor: Colors.red.shade500,
                              textColor: Colors.white,
                              onPressed: () => calculator.clear(),
                            ),
                            buildButton(
                              context,
                              '÷',
                              bgColor: Colors.indigo.shade400,
                              textColor: Colors.white,
                              onPressed: () => calculator.performOperation('÷'),
                            ),
                            buildButton(
                              context,
                              '×',
                              bgColor: Colors.indigo.shade400,
                              textColor: Colors.white,
                              onPressed: () => calculator.performOperation('×'),
                            ),
                          ],
                        ),

                        // Row 2
                        Row(
                          children: [
                            buildButton(context, '7', onPressed: () => calculator.inputDigit(7)),
                            buildButton(context, '8', onPressed: () => calculator.inputDigit(8)),
                            buildButton(context, '9', onPressed: () => calculator.inputDigit(9)),
                            buildButton(
                              context,
                              '−',
                              bgColor: Colors.indigo.shade400,
                              textColor: Colors.white,
                              onPressed: () => calculator.performOperation('-'),
                            ),
                          ],
                        ),

                        // Row 3
                        Row(
                          children: [
                            buildButton(context, '4', onPressed: () => calculator.inputDigit(4)),
                            buildButton(context, '5', onPressed: () => calculator.inputDigit(5)),
                            buildButton(context, '6', onPressed: () => calculator.inputDigit(6)),
                            buildButton(
                              context,
                              '+',
                              bgColor: Colors.indigo.shade400,
                              textColor: Colors.white,
                              onPressed: () => calculator.performOperation('+'),
                            ),
                          ],
                        ),

                        // Row 4 & 5
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      buildButton(context, '1', onPressed: () => calculator.inputDigit(1)),
                                      buildButton(context, '2', onPressed: () => calculator.inputDigit(2)),
                                      buildButton(context, '3', onPressed: () => calculator.inputDigit(3)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      buildButton(context, '0', flex: 2, onPressed: () => calculator.inputDigit(0)),
                                      buildButton(context, '.', onPressed: () => calculator.inputDecimal()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  onPressed: () => calculator.performOperation('='),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade500,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 60),
                                    elevation: 4,
                                  ),
                                  child: const Text(
                                    '=',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Import statement yang diperlukan untuk Consumer:
// import 'package:provider/provider.dart';