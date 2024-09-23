import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  dynamic displaytxt = '0';
  String pressedButton = ''; // Track the pressed button

  // Button Widget with animation
  Widget calcbutton(String btntxt, Color btncolor, Color txtcolor) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          pressedButton = btntxt; // Set the button as pressed
        });
      },
      onTapUp: (_) {
        setState(() {
          pressedButton = ''; // Reset the pressed button
          calculation(btntxt); // Perform the calculation
        });
      },
      child: AnimatedScale(
        scale: pressedButton == btntxt ? 0.9 : 1.0, // Apply scale only to the pressed button
        duration: Duration(milliseconds: 100),
        child: Container(
          child: ElevatedButton(
            onPressed: null, // Disable default onPressed, using GestureDetector instead
            child: Text(
              '$btntxt',
              style: TextStyle(
                fontSize: 35,
                color: txtcolor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: btncolor,
              padding: EdgeInsets.all(20),
              shape: CircleBorder(),
            ),
          ),
        ),
      ),
    );
  }

  // Text animation with fade effect
  Widget animatedDisplay() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Text(
        '$displaytxt',
        key: ValueKey<String>(displaytxt),
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 100,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 232, 232),
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Color.fromARGB(255, 210, 204, 204),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: animatedDisplay(),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('AC', const Color.fromARGB(255, 18, 18, 18), Colors.black),
                calcbutton('+/-', const Color.fromARGB(255, 18, 17, 17), Colors.black),
                calcbutton('%', const Color.fromARGB(255, 22, 22, 22), Colors.black),
                calcbutton('/', const Color.fromARGB(255, 18, 18, 18), Colors.black),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('7', Color.fromARGB(255, 62, 61, 61), Color.fromARGB(255, 30, 29, 29)),
                calcbutton('8', Color.fromARGB(255, 62, 61, 61), Color.fromARGB(255, 15, 15, 15)),
                calcbutton('9', Color.fromARGB(255, 62, 61, 61), Color.fromARGB(255, 20, 20, 20)),
                calcbutton('x', Color.fromARGB(255, 62, 61, 61), Color.fromARGB(255, 20, 20, 20)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('4', Color.fromARGB(255, 14, 13, 13), Color.fromARGB(255, 27, 27, 27)),
                calcbutton('5', Color.fromARGB(255, 24, 24, 24), Color.fromARGB(255, 26, 25, 25)),
                calcbutton('6', Color.fromARGB(255, 31, 30, 30), Color.fromARGB(255, 28, 28, 28)),
                calcbutton('-', Color.fromARGB(255, 30, 29, 29), Color.fromARGB(255, 30, 30, 30)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('1', Color.fromARGB(255, 27, 26, 26), Color.fromARGB(255, 29, 28, 28)),
                calcbutton('2', Color.fromARGB(255, 23, 22, 22), Color.fromARGB(255, 25, 25, 25)),
                calcbutton('3', Color.fromARGB(255, 29, 29, 29), Color.fromARGB(255, 31, 31, 31)),
                calcbutton('+', Color.fromARGB(255, 27, 26, 26), Color.fromARGB(255, 34, 33, 33)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    calculation('0');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(34, 20, 128, 20),
                    shape: StadiumBorder(),
                    backgroundColor: Colors.grey[850],
                  ),
                  child: Text(
                    '0',
                    style: TextStyle(fontSize: 35, color: Color.fromARGB(255, 22, 22, 22)),
                  ),
                ),
                calcbutton('.', Color.fromARGB(255, 31, 31, 31), const Color.fromARGB(255, 28, 27, 27)),
                calcbutton('=', Color.fromARGB(255, 22, 22, 22), const Color.fromARGB(255, 30, 29, 29)),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Calculator logic
  dynamic text = '0';
  double numOne = 0;
  double numTwo = 0;

  dynamic result = '';
  dynamic finalResult = '';
  dynamic opr = '';
  dynamic preOpr = '';

  void calculation(btnText) {
    if (btnText == 'AC') {
      text = '0';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = '0';
      opr = '';
      preOpr = '';
    } else if (opr == '=' && btnText == '=') {
      if (preOpr == '+') {
        finalResult = add();
      } else if (preOpr == '-') {
        finalResult = sub();
      } else if (preOpr == 'x') {
        finalResult = mul();
      } else if (preOpr == '/') {
        finalResult = div();
      }
    } else if (btnText == '+' || btnText == '-' || btnText == 'x' || btnText == '/' || btnText == '=') {
      if (numOne == 0) {
        numOne = double.parse(result);
      } else {
        numTwo = double.parse(result);
      }

      if (opr == '+') {
        finalResult = add();
      } else if (opr == '-') {
        finalResult = sub();
      } else if (opr == 'x') {
        finalResult = mul();
      } else if (opr == '/') {
        finalResult = div();
      }
      preOpr = opr;
      opr = btnText;
      result = '';
    } else if (btnText == '%') {
      result = (numOne / 100).toString();
      finalResult = doesContainDecimal(result);
    } else if (btnText == '.') {
      if (!result.toString().contains('.')) {
        result = result.toString() + '.';
      }
      finalResult = result;
    } else if (btnText == '+/-') {
      result.toString().startsWith('-') ? result = result.toString().substring(1) : result = '-' + result.toString();
      finalResult = result;
    } else {
      result = result + btnText;
      finalResult = result;
    }

    setState(() {
      displaytxt = finalResult;
    });
  }

  String add() {
    result = (numOne + numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String sub() {
    result = (numOne - numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String mul() {
    result = (numOne * numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String div() {
    result = (numOne / numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String doesContainDecimal(dynamic result) {
    if (result.toString().contains('.')) {
      List<String> splitDecimal = result.toString().split('.');
      if (!(int.parse(splitDecimal[1]) > 0)) {
        return result = splitDecimal[0].toString();
      }
    }
    return result;
  }
}
