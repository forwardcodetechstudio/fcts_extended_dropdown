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
  final BoxDecoration? fieldDecoration;
  final EdgeInsetsGeometry? padding;
  final Duration debounceDuration;
  final bool? showClearButton;
  final InputDecoration? decoration;
  final DropdownController<T>? controller;
  final String? errorText;
  final String? Function(List<DropdownItem<T>>)? validator;
  final AutovalidateMode autovalidateMode;

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
    this.searchHint = '',
    this.fieldDecoration,
    this.padding,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.showClearButton = true,
    this.decoration,
    this.controller,
    this.errorText,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  State<FctsExtendedDropdown<T>> createState() =>
      FctsExtendedDropdownState<T>();
}

class FctsExtendedDropdownState<T> extends State<FctsExtendedDropdown<T>> {
  late DropdownController<T> _controller;
  bool _isLocalController = false;
  String? _internalErrorText;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _isLocalController = true;
      _controller = DropdownController<T>(
        isMultipleSelection: widget.isMultipleSelection,
        onRemoteSearch: widget.onRemoteSearch,
        initialItems: widget.items,
        initialSelectedItems: widget.initialSelectedItems ?? [],
        debounceDuration: widget.debounceDuration,
      );
    }

    _controller.syncWithWidget(
      isMultipleSelection: widget.isMultipleSelection,
      debounceDuration: widget.debounceDuration,
      onRemoteSearch: widget.onRemoteSearch,
      items: widget.items,
    );

    _controller.selectedItemsStream.listen((items) {
      if (widget.validator != null &&
          widget.autovalidateMode != AutovalidateMode.disabled) {
        validate();
      }
      widget.onChanged?.call(items);
    });
  }

  String? validate() {
    if (widget.validator != null) {
      final error = widget.validator!(_controller.selectedItems);
      setState(() {
        _internalErrorText = error;
      });
      return error;
    }
    return null;
  }

  @override
  void didUpdateWidget(covariant FctsExtendedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_isLocalController) {
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _isLocalController = false;
      } else {
        _isLocalController = true;
        _controller = DropdownController<T>(
          isMultipleSelection: widget.isMultipleSelection,
          onRemoteSearch: widget.onRemoteSearch,
          initialItems: widget.items,
          initialSelectedItems: widget.initialSelectedItems ?? [],
          debounceDuration: widget.debounceDuration,
        );
      }
    }

    _controller.syncWithWidget(
      isMultipleSelection: widget.isMultipleSelection,
      debounceDuration: widget.debounceDuration,
      onRemoteSearch: widget.onRemoteSearch,
      items: widget.items,
    );
  }

  @override
  void dispose() {
    if (_isLocalController) {
      _controller.dispose();
    }
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
    final effectiveErrorText = widget.errorText ?? _internalErrorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.decoration == null ||
            widget.decoration?.labelText == null) ...[
          Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: _showDropdownModal,
          child: StreamBuilder<List<DropdownItem<T>>>(
            stream: _controller.selectedItemsStream,
            builder: (context, snapshot) {
              final selectedItems = snapshot.data ?? [];

              if (widget.fieldBuilder != null) {
                return widget.fieldBuilder!(context, selectedItems);
              }

              final child = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: selectedItems.isEmpty
                        ? Text(
                            widget.placeholder ?? '',
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
                        child: Icon(Icons.clear, size: 20, color: Colors.grey),
                      ),
                    ),
                  const Icon(Icons.arrow_drop_down),
                ],
              );

              if (widget.decoration != null) {
                return InputDecorator(
                  decoration: widget.decoration!.copyWith(
                    errorText: effectiveErrorText,
                  ),
                  isEmpty: selectedItems.isEmpty,
                  child: child,
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: widget.padding ??
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                    decoration: widget.fieldDecoration ??
                        BoxDecoration(
                          border: Border.all(
                              color: effectiveErrorText != null
                                  ? Colors.red
                                  : Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                    child: child,
                  ),
                  if (effectiveErrorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 12),
                      child: Text(
                        effectiveErrorText,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class FctsExtendedDropdownFormField<T>
    extends FormField<List<DropdownItem<T>>> {
  final String label;
  final String? placeholder;
  final List<DropdownItem<T>> items;
  final List<DropdownItem<T>>? initialSelectedItems;
  final bool isMultipleSelection;
  final RemoteSearchCallback<T>? onRemoteSearch;
  final Widget Function(BuildContext, DropdownItem<T>, bool)? itemBuilder;
  final Widget Function(BuildContext)? emptyBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final String modalTitle;
  final String searchHint;
  final BoxDecoration? fieldDecoration;
  final EdgeInsetsGeometry? padding;
  final Duration debounceDuration;
  final bool? showClearButton;
  final InputDecoration? decoration;
  final ValueChanged<List<DropdownItem<T>>>? onChanged;
  final DropdownController<T>? controller;

  FctsExtendedDropdownFormField({
    super.key,
    required this.label,
    this.placeholder,
    this.items = const [],
    this.initialSelectedItems,
    this.isMultipleSelection = false,
    this.onRemoteSearch,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.modalTitle = 'Select Item',
    this.searchHint = '',
    this.fieldDecoration,
    this.padding,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.showClearButton = true,
    this.decoration,
    this.onChanged,
    this.controller,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled = true,
    super.autovalidateMode,
  }) : super(
          builder: (FormFieldState<List<DropdownItem<T>>> state) {
            final _FctsExtendedDropdownFormFieldState<T> field =
                state as _FctsExtendedDropdownFormFieldState<T>;
            return FctsExtendedDropdown<T>(
              label: label,
              placeholder: placeholder,
              items: items,
              initialSelectedItems: initialValue ?? initialSelectedItems,
              isMultipleSelection: isMultipleSelection,
              onRemoteSearch: onRemoteSearch,
              itemBuilder: itemBuilder,
              emptyBuilder: emptyBuilder,
              loadingBuilder: loadingBuilder,
              modalTitle: modalTitle,
              searchHint: searchHint,
              fieldDecoration: fieldDecoration,
              padding: padding,
              debounceDuration: debounceDuration,
              showClearButton: showClearButton,
              decoration: decoration,
              onChanged: onChanged,
              controller: field._controller,
              errorText: state.errorText,
            );
          },
        );

  @override
  FormFieldState<List<DropdownItem<T>>> createState() =>
      _FctsExtendedDropdownFormFieldState<T>();
}

class _FctsExtendedDropdownFormFieldState<T>
    extends FormFieldState<List<DropdownItem<T>>> {
  late DropdownController<T> _controller;
  bool _isLocalController = false;

  @override
  void initState() {
    super.initState();
    final FctsExtendedDropdownFormField<T> widget =
        this.widget as FctsExtendedDropdownFormField<T>;

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _isLocalController = true;
      _controller = DropdownController<T>(
        isMultipleSelection: widget.isMultipleSelection,
        onRemoteSearch: widget.onRemoteSearch,
        initialItems: widget.items,
        initialSelectedItems: value ?? widget.initialSelectedItems ?? [],
        debounceDuration: widget.debounceDuration,
      );
    }

    _controller.selectedItemsStream.listen((items) {
      didChange(items);
    });
  }

  @override
  void didUpdateWidget(covariant FctsExtendedDropdownFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final FctsExtendedDropdownFormField<T> widget =
        this.widget as FctsExtendedDropdownFormField<T>;

    if (widget.controller != oldWidget.controller) {
      if (_isLocalController) {
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _isLocalController = false;
      } else {
        _isLocalController = true;
        _controller = DropdownController<T>(
          isMultipleSelection: widget.isMultipleSelection,
          onRemoteSearch: widget.onRemoteSearch,
          initialItems: widget.items,
          initialSelectedItems: value ?? widget.initialSelectedItems ?? [],
          debounceDuration: widget.debounceDuration,
        );
      }
    }
  }

  @override
  void dispose() {
    if (_isLocalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    final FctsExtendedDropdownFormField<T> widget =
        this.widget as FctsExtendedDropdownFormField<T>;
    _controller
        .setSelection(widget.initialValue ?? widget.initialSelectedItems ?? []);
  }
}
