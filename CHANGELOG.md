## 1.0.1

* Introduced `FctsExtendedDropdownFormField` for seamless Flutter `Form` integration.
* Added support for standard `InputDecoration` to enable "TextField-style" dropdowns with floating labels and themed borders.
* Added `validator`, `onSaved`, and `autovalidateMode` support.
* Support for custom validation logic in both single and multi-selection modes.
* Updated documentation and examples for Form integration.

## 1.0.0

* Initial release of `fcts_extended_dropdown`.
* Generic `DropdownItem<T>` model for flexible data types.
* `FctsExtendedDropdown` widget with:
    * Static data support.
    * Remote data source support with `RemoteSearchCallback`.
    * Built-in search with debounce using `rxdart`.
    * Single and multiple selection modes.
    * Results caching for remote searches.
    * "Reload" capability to refresh remote data.
    * Clear selection functionality from field and modal.
    * Fully customizable appearance via builder functions.
