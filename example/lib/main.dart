import 'package:flutter/material.dart';
import 'package:fcts_extended_dropdown/fcts_extended_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fcts Extended Dropdown Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DropdownItem<int>> _selectedStatic = [];
  List<DropdownItem<String>> _selectedRemote = [];
  List<DropdownItem<String>> _selectedMulti = [];

  final List<DropdownItem<int>> _staticItems = List.generate(
    20,
    (index) => DropdownItem(
        label: 'Item $index', value: index, subLabel: 'Subtitle for $index'),
  );

  Future<List<DropdownItem<String>>> _handleRemoteSearch(String query) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final allRemoteItems = List.generate(
      50,
      (index) =>
          DropdownItem(label: 'Remote City $index', value: 'city_$index'),
    );

    if (query.isEmpty) return allRemoteItems.take(10).toList();

    return allRemoteItems
        .where((item) => item.label.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fcts Extended Dropdown'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            FctsExtendedDropdown<int>(
              label: 'Static Data Dropdown',
              placeholder: 'Select a number',
              items: _staticItems,
              onChanged: (selected) {
                setState(() => _selectedStatic = selected);
              },
            ),
            const SizedBox(height: 24),
            FctsExtendedDropdown<String>(
              label: 'Remote Search Dropdown',
              placeholder: 'Search cities...',
              onRemoteSearch: _handleRemoteSearch,
              onChanged: (selected) {
                setState(() => _selectedRemote = selected);
              },
            ),
            const SizedBox(height: 24),
            FctsExtendedDropdown<String>(
              label: 'Multiple Selection Dropdown',
              placeholder: 'Select multiple items',
              isMultipleSelection: true,
              items: List.generate(
                10,
                (index) =>
                    DropdownItem(label: 'Option $index', value: 'opt_$index'),
              ),
              onChanged: (selected) {
                setState(() => _selectedMulti = selected);
              },
            ),
            const SizedBox(height: 48),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Selection Results',
                        style: Theme.of(context).textTheme.titleMedium),
                    const Divider(),
                    Text(
                        'Static: ${_selectedStatic.map((e) => e.label).join(', ')}'),
                    Text(
                        'Remote: ${_selectedRemote.map((e) => e.label).join(', ')}'),
                    Text(
                        'Multi: ${_selectedMulti.map((e) => e.label).join(', ')}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
