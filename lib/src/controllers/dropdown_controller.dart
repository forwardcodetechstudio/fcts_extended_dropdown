import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../models/dropdown_item.dart';

typedef RemoteSearchCallback<T> = FutureOr<List<DropdownItem<T>>> Function(
    String query);

class DropdownController<T> {
  bool isMultipleSelection;
  Duration debounceDuration;
  RemoteSearchCallback<T>? onRemoteSearch;
  List<DropdownItem<T>> items;

  final _selectedItemsController =
      BehaviorSubject<List<DropdownItem<T>>>.seeded([]);
  Stream<List<DropdownItem<T>>> get selectedItemsStream =>
      _selectedItemsController.stream;
  List<DropdownItem<T>> get selectedItems => _selectedItemsController.value;

  final _itemsController = BehaviorSubject<List<DropdownItem<T>>>.seeded([]);
  Stream<List<DropdownItem<T>>> get itemsStream => _itemsController.stream;

  final _loadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get loadingStream => _loadingController.stream;

  final _searchQuery = BehaviorSubject<String>.seeded('');

  List<DropdownItem<T>>? _cachedRemoteItems;

  StreamSubscription? _searchSubscription;

  final ValueChanged<List<DropdownItem<T>>>? onChanged;

  DropdownController({
    this.isMultipleSelection = false,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.onRemoteSearch,
    List<DropdownItem<T>> initialItems = const [],
    List<DropdownItem<T>> initialSelectedItems = const [],
    this.onChanged,
  }) : items = initialItems {
    _itemsController.add(items);
    _selectedItemsController.add(initialSelectedItems);

    _searchSubscription =
        _searchQuery.debounceTime(debounceDuration).listen(_handleSearch);

    _selectedItemsController.stream.listen((items) {
      onChanged?.call(items);
    });
  }

  void setSearchQuery(String query) {
    _searchQuery.add(query);
  }

  void clearSearch() {
    _searchQuery.add('');
  }

  void syncWithWidget({
    required bool isMultipleSelection,
    required Duration debounceDuration,
    RemoteSearchCallback<T>? onRemoteSearch,
    required List<DropdownItem<T>> items,
  }) {
    this.isMultipleSelection = isMultipleSelection;
    if (debounceDuration != this.debounceDuration) {
      this.debounceDuration = debounceDuration;
      _searchSubscription?.cancel();
      _searchSubscription = _searchQuery
          .debounceTime(this.debounceDuration)
          .listen(_handleSearch);
    }

    this.onRemoteSearch = onRemoteSearch;
    this.items = items;

    if (this.onRemoteSearch == null && _searchQuery.value.isEmpty) {
      _itemsController.add(this.items);
    }
  }

  void refresh() {
    _cachedRemoteItems = null;
    _handleSearch(_searchQuery.value);
  }

  String get searchQuery => _searchQuery.value;

  Future<void> _handleSearch(String query) async {
    if (onRemoteSearch != null) {
      if (query.isEmpty && _cachedRemoteItems != null) {
        _itemsController.add(_cachedRemoteItems!);
        return;
      }

      _loadingController.add(true);
      try {
        final results = await onRemoteSearch!(query);
        if (query.isEmpty) {
          _cachedRemoteItems = results;
        }
        _itemsController.add(results);
      } catch (e) {
        // Handle error or add empty list
        _itemsController.add([]);
      } finally {
        _loadingController.add(false);
      }
    } else {
      if (query.isEmpty) {
        _itemsController.add(items);
      } else {
        final filtered = items.where((item) {
          return item.label.toLowerCase().contains(query.toLowerCase()) ||
              (item.subLabel?.toLowerCase().contains(query.toLowerCase()) ??
                  false);
        }).toList();
        _itemsController.add(filtered);
      }
    }
  }

  void selectItem(DropdownItem<T> item) {
    if (isMultipleSelection) {
      final current = List<DropdownItem<T>>.from(selectedItems);
      if (current.contains(item)) {
        current.remove(item);
      } else {
        current.add(item);
      }
      _selectedItemsController.add(current);
    } else {
      _selectedItemsController.add([item]);
    }
  }

  void setSelection(List<DropdownItem<T>> items) {
    if (!isMultipleSelection && items.length > 1) {
      _selectedItemsController.add([items.first]);
    } else {
      _selectedItemsController.add(items);
    }
  }

  void unselectItem(DropdownItem<T> item) {
    final current = List<DropdownItem<T>>.from(selectedItems);
    current.remove(item);
    _selectedItemsController.add(current);
  }

  void clearSelection() {
    _selectedItemsController.add([]);
  }

  void dispose() {
    _searchSubscription?.cancel();
    _selectedItemsController.close();
    _itemsController.close();
    _loadingController.close();
    _searchQuery.close();
  }
}
