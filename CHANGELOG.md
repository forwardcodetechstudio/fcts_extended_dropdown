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
