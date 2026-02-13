# fcts_extended_dropdown

A highly customizable Flutter dropdown package with support for static/remote data, search with debounce, and single/multiple selection.

## Features

- [x] Select from list of static data.
- [x] Select from remote data source.
- [x] Search from both static and remote data sources with built-in debounce.
- [x] Single or multiple selection modes.
- [x] Fully customizable appearance via builders.

## Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  fcts_extended_dropdown: ^1.0.0
```

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

### Remote Search with Debounce

```dart
FctsExtendedDropdown<String>(
  label: 'Search Cities',
  onRemoteSearch: (query) async {
    final results = await api.searchCities(query);
    return results.map((e) => DropdownItem(label: e.name, value: e.id)).toList();
  },
  onChanged: (selected) {
    print(selected.first.label);
  },
)
```

### Multiple Selection

```dart
FctsExtendedDropdown<String>(
  label: 'Select Tags',
  isMultipleSelection: true,
  items: [
    DropdownItem(label: 'Flutter', value: 'flutter'),
    DropdownItem(label: 'Dart', value: 'dart'),
  ],
  onChanged: (selected) {
    print(selected.map((e) => e.value).toList());
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
