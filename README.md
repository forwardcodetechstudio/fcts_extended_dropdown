# fcts_extended_dropdown

A highly customizable Flutter dropdown package with support for static/remote data, search with debounce, and single/multiple selection.

## Features

- [x] Static and Remote data sources.
- [x] Search with built-in debounce.
- [x] Single and Multiple selection modes.
- [x] **TextField Style**: Supports standard `InputDecoration` (Floating labels, outline borders).
- [x] **Form Ready**: Includes `FctsExtendedDropdownFormField` for standard Flutter `Form` validation.
- [x] Fully customizable appearance via builders.

## Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  fcts_extended_dropdown: ^1.1.0
```

## Widgets

### 1. FctsExtendedDropdown
Direct widget for quick selection and reactive UI. Best used when you handle state manually.

### 2. FctsExtendedDropdownFormField
Wraps the dropdown in a `FormField`. Perfect for use inside a `Form` widget with validation rules.

## Usage

### Simple Static Dropdown
```dart
FctsExtendedDropdown<int>(
  label: 'Select Number',
  items: [
    DropdownItem(label: 'One', value: 1),
    DropdownItem(label: 'Two', value: 2),
  ],
  onChanged: (selected) {
    print(selected.first.value);
  },
)
```

### TextField-Style (Outline & Floating Labels)
Use the `decoration` property to apply Material `InputDecoration`.

```dart
FctsExtendedDropdown<int>(
  label: 'Choose Number',
  items: staticItems,
  decoration: InputDecoration(
    labelText: 'Select Number',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    prefixIcon: Icon(Icons.numbers),
  ),
  onChanged: (selected) => print(selected),
)
```

### Form Integration (Validation)
Use `FctsExtendedDropdownFormField` for seamless form validation.

#### Remote Search + Required Validation
```dart
Form(
  key: _formKey,
  child: FctsExtendedDropdownFormField<String>(
    label: 'City Search',
    onRemoteSearch: (query) async {
       return await api.search(query);
    },
    decoration: InputDecoration(
      labelText: 'Required City Selection',
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please search and select a city';
      }
      return null;
    },
  ),
)
```

#### Multi-Select + Custom Validation
```dart
FctsExtendedDropdownFormField<String>(
  label: 'Skills',
  isMultipleSelection: true,
  items: [
    DropdownItem(label: 'Dart', value: 'dart'),
    DropdownItem(label: 'Flutter', value: 'flutter'),
  ],
  validator: (value) {
    if (value == null || value.length < 2) {
      return 'Select at least 2 skills';
    }
    return null;
  },
)
```

## Contributors

- **Rahul Gupta** - [Linkedin](https://www.linkedin.com/in/rahul-gupta-ji/)
- **Forwardcode TechStudio** - [GitHub](https://github.com/forwardcodetechstudio)

## About Forwardcode TechStudio

[Forwardcode TechStudio](https://forwardcode.in/) is a software development studio specialized in building high-quality mobile applications, web platforms, and custom software solutions. We focus on delivering performance-oriented and scalable products.

### Need a custom solution?

If you're looking for expert development services or have a project in mind, we're here to help!

[![Hire Forwardcode TechStudio](https://img.shields.io/badge/Contact-Forwardcode_TechStudio-0052FF?style=for-the-badge&logo=appveyor)](https://forwardcode.in/?utm_source=fcts_extended_dropdown&utm_medium=readme&utm_campaign=project_inquiry)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
