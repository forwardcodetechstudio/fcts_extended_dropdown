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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FctsExtendedDropdownState<String>> _standaloneKey =
      GlobalKey<FctsExtendedDropdownState<String>>();
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
            const SizedBox(height: 24),
            FctsExtendedDropdown<int>(
              label: 'TextField Style (Outline)',
              items: _staticItems,
              decoration: const InputDecoration(
                labelText: 'Select Number (Floating)',
                hintText: 'Choose from list',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                prefixIcon: Icon(Icons.numbers),
              ),
              onChanged: (selected) {
                // Handle selection
              },
            ),
            const SizedBox(height: 24),
            FctsExtendedDropdown<String>(
              label: 'TextField Style (Filled)',
              onRemoteSearch: _handleRemoteSearch,
              decoration: InputDecoration(
                labelText: 'City Search',
                filled: true,
                fillColor: Colors.deepPurple.withValues(alpha: 0.05),
                border: const UnderlineInputBorder(),
              ),
              onChanged: (selected) {
                // Handle selection
              },
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 48),
            const Text(
              'Form Integration (Required)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  FctsExtendedDropdown<String>(
                    key: _standaloneKey,
                    label: 'Standalone Validator Dropdown',
                    placeholder: 'Must select something',
                    items: const [
                      DropdownItem(label: 'Option A', value: 'a'),
                      DropdownItem(label: 'Option B', value: 'b'),
                    ],
                    validator: (items) {
                      if (items.isEmpty) {
                        return 'Please select an option (Standalone)';
                      }
                      return null;
                    },
                    onChanged: (selected) {
                      // selection change
                    },
                  ),
                  const SizedBox(height: 24),
                  FctsExtendedDropdownFormField<int>(
                    label: 'Required Selection',
                    items: _staticItems,
                    decoration: const InputDecoration(
                      labelText: 'Must select a number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select at least one number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FctsExtendedDropdownFormField<String>(
                    label: 'Remote Form Field',
                    onRemoteSearch: _handleRemoteSearch,
                    decoration: const InputDecoration(
                      labelText: 'Search City (Required)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please search and select a city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FctsExtendedDropdownFormField<String>(
                    label: 'Multi-Select Form Field',
                    isMultipleSelection: true,
                    items: const [
                      DropdownItem(label: 'Dart', value: 'dart'),
                      DropdownItem(label: 'Flutter', value: 'flutter'),
                      DropdownItem(label: 'Swift', value: 'swift'),
                      DropdownItem(label: 'Kotlin', value: 'kotlin'),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Selected Skills',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      prefixIcon: Icon(Icons.code),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 2) {
                        return 'Please select at least 2 skills';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form is valid!')),
                        );
                      }
                    },
                    child: const Text('Submit Form'),
                  ),
                ],
              ),
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
