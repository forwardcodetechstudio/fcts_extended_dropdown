class DropdownItem<T> {
  final String label;
  final T value;
  final String? subLabel;
  final dynamic data;

  const DropdownItem({
    required this.label,
    required this.value,
    this.subLabel,
    this.data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItem &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          value == other.value;

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}
