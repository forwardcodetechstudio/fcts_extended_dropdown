import 'package:flutter/material.dart';
import '../models/dropdown_item.dart';
import '../controllers/dropdown_controller.dart';

class DropdownModal<T> extends StatefulWidget {
  final DropdownController<T> controller;
  final String title;
  final String searchHint;
  final Widget Function(BuildContext, DropdownItem<T>, bool)? itemBuilder;
  final Widget Function(BuildContext)? emptyBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final InputDecoration? searchInputDecoration;

  const DropdownModal({
    super.key,
    required this.controller,
    this.title = 'Select Item',
    this.searchHint = 'Search...',
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.searchInputDecoration,
  });

  @override
  State<DropdownModal<T>> createState() => _DropdownModalState<T>();
}

class _DropdownModalState<T> extends State<DropdownModal<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    widget.controller.clearSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  if (widget.controller.onRemoteSearch != null)
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh data',
                      onPressed: widget.controller.refresh,
                    ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: widget.searchInputDecoration ??
                      InputDecoration(
                        hintText: widget.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            widget.controller.clearSearch();
                          },
                        ),
                      ),
                  onChanged: widget.controller.setSearchQuery,
                ),
              ),
              const SizedBox(width: 8),
              if (widget.controller.isMultipleSelection)
                TextButton.icon(
                  onPressed: () {
                    widget.controller.clearSelection();
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All'),
                )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<bool>(
              stream: widget.controller.loadingStream,
              builder: (context, loadingSnapshot) {
                if (loadingSnapshot.data ?? false) {
                  return widget.loadingBuilder?.call(context) ??
                      const Center(child: CircularProgressIndicator());
                }

                return StreamBuilder<List<DropdownItem<T>>>(
                  stream: widget.controller.itemsStream,
                  builder: (context, itemsSnapshot) {
                    final items = itemsSnapshot.data ?? [];

                    if (items.isEmpty) {
                      return widget.emptyBuilder?.call(context) ??
                          const Center(child: Text('No items found'));
                    }

                    return StreamBuilder<List<DropdownItem<T>>>(
                      stream: widget.controller.selectedItemsStream,
                      builder: (context, selectedSnapshot) {
                        final selectedItems = selectedSnapshot.data ?? [];

                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isSelected = selectedItems.contains(item);

                            if (widget.itemBuilder != null) {
                              return InkWell(
                                onTap: () {
                                  widget.controller.selectItem(item);
                                  if (!widget.controller.isMultipleSelection) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: widget.itemBuilder!(
                                    context, item, isSelected),
                              );
                            }

                            return ListTile(
                              title: Text(item.label),
                              subtitle: item.subLabel != null
                                  ? Text(item.subLabel!)
                                  : null,
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.blue)
                                  : (widget.controller.isMultipleSelection
                                      ? const Icon(Icons.radio_button_off)
                                      : null),
                              onTap: () {
                                widget.controller.selectItem(item);
                                if (!widget.controller.isMultipleSelection) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          if (widget.controller.isMultipleSelection) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
