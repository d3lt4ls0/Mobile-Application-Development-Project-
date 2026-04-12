import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      home: ExpenseHome(),
    );
  }
}

class Expense {
  String title;
  double amount;

  Expense(this.title, this.amount);
}

class ExpenseHome extends StatefulWidget {a
  @override
  _ExpenseHomeState createState() => _ExpenseHomeState();
}

class _ExpenseHomeState extends State<ExpenseHome> {
  final List<Expense> _expenses = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _addExpense() {
    final String title = _titleController.text;
    final double? amount = double.tryParse(_amountController.text);

    if (title.isEmpty || amount == null) return;

    setState(() {
      _expenses.add(Expense(title, amount));
    });

    _titleController.clear();
    _amountController.clear();
  }

  double get totalExpense {
    return _expenses.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Manager"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Expense Title"),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addExpense,
              child: Text("Add Expense"),
            ),
            SizedBox(height: 20),
            Text(
              "Total: ₹${totalExpense.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_expenses[index].title),
                    trailing: Text("₹${_expenses[index].amount}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
