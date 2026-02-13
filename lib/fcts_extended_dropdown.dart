import 'package:flutter/material.dart';
import 'src/models/dropdown_item.dart';
import 'src/controllers/dropdown_controller.dart';
import 'src/widgets/dropdown_modal.dart';

export 'src/models/dropdown_item.dart';
export 'src/controllers/dropdown_controller.dart';

class FctsExtendedDropdown<T> extends StatefulWidget {
  final String label;
  final String? placeholder;
  final List<DropdownItem<T>> items;
  final List<DropdownItem<T>>? initialSelectedItems;
  final bool isMultipleSelection;
  final RemoteSearchCallback<T>? onRemoteSearch;
  final ValueChanged<List<DropdownItem<T>>>? onChanged;
  final Widget Function(BuildContext, List<DropdownItem<T>>)? fieldBuilder;
  final Widget Function(BuildContext, DropdownItem<T>, bool)? itemBuilder;
  final Widget Function(BuildContext)? emptyBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final String modalTitle;
  final String searchHint;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final Duration debounceDuration;
  final bool? showClearButton;

  const FctsExtendedDropdown({
    super.key,
    required this.label,
    this.placeholder,
    this.items = const [],
    this.initialSelectedItems,
    this.isMultipleSelection = false,
    this.onRemoteSearch,
    this.onChanged,
    this.fieldBuilder,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.modalTitle = 'Select Item',
    this.searchHint = 'Search...',
    this.decoration,
    this.padding,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.showClearButton = true,
  });

  @override
  State<FctsExtendedDropdown<T>> createState() =>
      _FctsExtendedDropdownState<T>();
}

class _FctsExtendedDropdownState<T> extends State<FctsExtendedDropdown<T>> {
  late DropdownController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller = DropdownController<T>(
      isMultipleSelection: widget.isMultipleSelection,
      onRemoteSearch: widget.onRemoteSearch,
      initialItems: widget.items,
      initialSelectedItems: widget.initialSelectedItems ?? [],
      debounceDuration: widget.debounceDuration,
    );

    _controller.selectedItemsStream.listen((items) {
      widget.onChanged?.call(items);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDropdownModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return DropdownModal<T>(
              controller: _controller,
              title: widget.modalTitle,
              searchHint: widget.searchHint,
              itemBuilder: widget.itemBuilder,
              emptyBuilder: widget.emptyBuilder,
              loadingBuilder: widget.loadingBuilder,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showDropdownModal,
          child: StreamBuilder<List<DropdownItem<T>>>(
            stream: _controller.selectedItemsStream,
            builder: (context, snapshot) {
              final selectedItems = snapshot.data ?? [];

              if (widget.fieldBuilder != null) {
                return widget.fieldBuilder!(context, selectedItems);
              }

              return Container(
                padding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: widget.decoration ??
                    BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: selectedItems.isEmpty
                          ? Text(
                              widget.placeholder ?? 'Select...',
                              style: TextStyle(color: Colors.grey.shade600),
                            )
                          : Text(
                              selectedItems.map((e) => e.label).join(', '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    if (selectedItems.isNotEmpty &&
                        (widget.showClearButton ?? true))
                      GestureDetector(
                        onTap: () {
                          _controller.clearSelection();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child:
                              Icon(Icons.clear, size: 20, color: Colors.grey),
                        ),
                      ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
