import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Stateful Widget',
      theme: ThemeData(primarySwatch: Colors.blue),
      // A widget that will be started on the application startup
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  //initial counter value
  int _counter = 0;
  final int _maxCounter = 100;
  final TextEditingController _incrementController = TextEditingController();
  final List<int> _counterHistory = [];

  void resetCounter() {
    setState(() {
      _counterHistory.add(_counter);
      _counter = 0;
    });
  }

  void _incrementCounter() {
    setState(() {
      if (_counter < _maxCounter) {
        _counterHistory.add(_counter);
        _counter++;
        if (_counter == _maxCounter) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Maximum limit reached!')));
        }
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counterHistory.add(_counter);
        _counter--;
      }
    });
  }

  void _customIncrementCounter() {
    final int? incrementValue = int.tryParse(_incrementController.text);
    if (incrementValue != null) {
      setState(() {
        if (_counter + incrementValue <= _maxCounter) {
          _counterHistory.add(_counter);
          _counter += incrementValue;
          if (_counter == _maxCounter) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Maximum limit reached!')));
          }
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Maximum limit reached!')));
        }
      });
    } else {
      // Show an error message if the input is not a valid number
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid number')));
    }
  }

  void _undoCounter() {
    setState(() {
      if (_counterHistory.isNotEmpty) {
        _counter = _counterHistory.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color counterColor;
    if (_counter == 0) {
      counterColor = Colors.red;
    } else if (_counter > 50) {
      counterColor = Colors.green;
    } else {
      counterColor = Colors.blue;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Stateful Widget')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: counterColor,
              child: Text(
                //displays the current number
                '$_counter',
                style: TextStyle(fontSize: 50.0),
              ),
            ),
          ),
          Slider(
            min: 0,
            max: _maxCounter.toDouble(),
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt();
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _incrementController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter custom increment value',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: resetCounter,
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: _decrementCounter,
                child: const Text('Decrement'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('Increment'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _customIncrementCounter,
                child: const Text('Custom Increment'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _undoCounter,
                child: const Text('Undo'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Counter History:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _counterHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Value: ${_counterHistory[index]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
