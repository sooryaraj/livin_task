import 'package:flutter/material.dart';
import 'package:livin_task/billing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livin Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Livin Task'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Group 1",style: Theme.of(context).textTheme.titleSmall,),
              Text(bill.groupOneInvoice.join('\n')),
              Text("Group 2",style: Theme.of(context).textTheme.titleSmall,),
              Text(bill.groupTwoInvoice.join('\n')),
              Text("Group 3",style: Theme.of(context).textTheme.titleSmall,),
              Text(bill.groupThreeInvoice.join('\n')),
              Text(bill.groupTwoInvoice.join('\n')),
            ],
          ),
        ),
      ),
    );
  }
}
