import 'package:flutter/material.dart';

class CalculatorSetState extends StatefulWidget {
  const CalculatorSetState({super.key});

  @override
  State<CalculatorSetState> createState() => _CalculatorSetStateState();
}

class _CalculatorSetStateState extends State<CalculatorSetState> {
  String display = '0';
  String firstOperand = '';
  String operator = '';
  bool waitingForSecondOperand = false;

  void inputDigit(int digit) {
    setState(() {
      if (waitingForSecondOperand) {
        display = digit.toString();
        waitingForSecondOperand = false;
      } else {
        display = display == '0' ? digit.toString() : display + digit.toString();
      }
    });
  }

  void inputDecimal() {
    setState(() {
      if (waitingForSecondOperand) {
        display = '0.';
        waitingForSecondOperand = false;
        return;
      }
      if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  void clear() {
    setState(() {
      display = '0';
      firstOperand = '';
      operator = '';
      waitingForSecondOperand = false;
    });
  }

  void performOperation(String nextOperator) {
    setState(() {
      final inputValue = double.parse(display);

      if (firstOperand.isEmpty) {
        firstOperand = inputValue.toString();
      } else if (operator.isNotEmpty) {
        final result = calculate(
          double.parse(firstOperand),
          inputValue,
          operator,
        );
        display = result.toString();
        firstOperand = result.toString();
      }

      waitingForSecondOperand = true;
      operator = nextOperator;
    });
  }

  double calculate(double first, double second, String op) {
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

  Widget buildButton(String text, {
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
      backgroundColor: Colors.purple.shade600,
      appBar: AppBar(
        title: const Text('Kalkulator (setState)'),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade500, Colors.blue.shade500],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.calculate, color: Colors.white, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'Kalkulator (setState)',
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
                    if (operator.isNotEmpty)
                      Text(
                        '$firstOperand $operator',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      display,
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
                          'C',
                          flex: 2,
                          bgColor: Colors.red.shade500,
                          textColor: Colors.white,
                          onPressed: clear,
                        ),
                        buildButton(
                          '÷',
                          bgColor: Colors.orange.shade400,
                          textColor: Colors.white,
                          onPressed: () => performOperation('÷'),
                        ),
                        buildButton(
                          '×',
                          bgColor: Colors.orange.shade400,
                          textColor: Colors.white,
                          onPressed: () => performOperation('×'),
                        ),
                      ],
                    ),

                    // Row 2
                    Row(
                      children: [
                        buildButton('7', onPressed: () => inputDigit(7)),
                        buildButton('8', onPressed: () => inputDigit(8)),
                        buildButton('9', onPressed: () => inputDigit(9)),
                        buildButton(
                          '−',
                          bgColor: Colors.orange.shade400,
                          textColor: Colors.white,
                          onPressed: () => performOperation('-'),
                        ),
                      ],
                    ),

                    // Row 3
                    Row(
                      children: [
                        buildButton('4', onPressed: () => inputDigit(4)),
                        buildButton('5', onPressed: () => inputDigit(5)),
                        buildButton('6', onPressed: () => inputDigit(6)),
                        buildButton(
                          '+',
                          bgColor: Colors.orange.shade400,
                          textColor: Colors.white,
                          onPressed: () => performOperation('+'),
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
                                  buildButton('1', onPressed: () => inputDigit(1)),
                                  buildButton('2', onPressed: () => inputDigit(2)),
                                  buildButton('3', onPressed: () => inputDigit(3)),
                                ],
                              ),
                              Row(
                                children: [
                                  buildButton('0', flex: 2, onPressed: () => inputDigit(0)),
                                  buildButton('.', onPressed: inputDecimal),
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
                              onPressed: () => performOperation('='),
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
          ),
        ),
      ),
    );
  }
}