import 'package:flutter_test/flutter_test.dart';
import 'package:fcts_extended_dropdown/fcts_extended_dropdown.dart';

void main() {
  test('DropdownItem equality', () {
    const item1 = DropdownItem(label: 'Test', value: 1);
    const item2 = DropdownItem(label: 'Test', value: 1);
    const item3 = DropdownItem(label: 'Other', value: 2);

    expect(item1, equals(item2));
    expect(item1, isNot(equals(item3)));
  });

  test('DropdownController initial state', () {
    final controller = DropdownController<int>(
      initialItems: [
        const DropdownItem(label: '1', value: 1),
      ],
    );

    expect(controller.selectedItems, isEmpty);
    controller.dispose();
  });
}
