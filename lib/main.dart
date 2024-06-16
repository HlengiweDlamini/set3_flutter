import 'package:flutter/material.dart';
import 'dart:math';

List<int> generateRandomPermutation(int n) {
  var rng = Random();
  List<int> permutation = List<int>.generate(n, (index) => index + 1);
  for (int i = n - 1; i > 0; i--) {
    int j = rng.nextInt(i + 1);
    int temp = permutation[i];
    permutation[i] = permutation[j];
    permutation[j] = temp;
  }
  return permutation;
}

List<int> calculateCycleLengths(List<int> perm) {
  int n = perm.length;
  List<bool> visited = List<bool>.filled(n, false);
  List<int> cycleLengths = [];

  for (int i = 0; i < n; i++) {
    if (!visited[i]) {
      int cycleLength = 0;
      int j = i;
      while (!visited[j]) {
        visited[j] = true;
        cycleLength++;
        j = perm[j] - 1;
      }
      cycleLengths.add(cycleLength);
    }
  }
  return cycleLengths;
}

double calculateAverageCycleLength(List<int> cycleLengths) {
  int totalLength = cycleLengths.fold(0, (sum, length) => sum + length);
  return totalLength / cycleLengths.length;
}

double calculateExpectedNumberOfCycles(int n) {
  double harmonicNumber = 0.0;
  for (int k = 1; k <= n; k++) {
    harmonicNumber += 1 / k;
  }
  return harmonicNumber;
}

double estimateExpectedCycleLength(int n) {
  double totalCycleLength = 0.0;
  for (int cycleLength = 1; cycleLength <= n; cycleLength++) {
    totalCycleLength += cycleLength * (1 / n);
  }
  return totalCycleLength;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cycle Analysis',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.red),
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int n = 10; // Default value
  List<int>? permutation;
  List<int>? cycleLengths;
  double? averageCycleLength;
  double? expectedNumberOfCycles;
  double? expectedCycleLength;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Analysis'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Generate Permutation of size:',
            ),
            const SizedBox(height: 10),
            DropdownButton<int?>(
              value: n,
              onChanged: (int? newValue) {
                setState(() {
                  if (newValue != null) {
                    n = newValue;
                  }
                });
              },
              items: <int>[5, 10, 15, 20, 25]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                List<int> generatedPermutation = generateRandomPermutation(n);
                List<int> calculatedCycleLengths =
                    calculateCycleLengths(generatedPermutation);
                double avgCycleLength =
                    calculateAverageCycleLength(calculatedCycleLengths);
                double expectedNumOfCycles = calculateExpectedNumberOfCycles(n);
                double expectedCycleLen = estimateExpectedCycleLength(n);

                setState(() {
                  permutation = generatedPermutation;
                  cycleLengths = calculatedCycleLengths;
                  averageCycleLength = avgCycleLength;
                  expectedNumberOfCycles = expectedNumOfCycles;
                  expectedCycleLength = expectedCycleLen;
                });
              },
              child: const Text('Generate'),
            ),
            const SizedBox(height: 20),
            if (permutation != null) ...[
              Text('Permutation: ${permutation!.join(", ")}'),
              Text('Cycle Lengths: ${cycleLengths!.join(", ")}'),
              Text(
                  'Average Cycle Length: ${averageCycleLength!.toStringAsFixed(2)}'),
              Text(
                  'Expected Number of Cycles: ${expectedNumberOfCycles!.toStringAsFixed(2)}'),
              Text(
                  'Expected Cycle Length: ${expectedCycleLength!.toStringAsFixed(2)}'),
            ],
          ],
        ),
      ),
    );
  }
}
