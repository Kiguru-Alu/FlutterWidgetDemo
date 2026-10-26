# ReorderableListView Demo

A Flutter demo app showing how `ReorderableListView` lets users drag and drop list items to reorder them — built for an in-class widget presentation.

## How to Run

```bash
git clone <repo-url>
cd reorderable_list_demo
flutter pub get
flutter run
```

Press `r` in the terminal to hot reload after making code changes.

## Three Attributes Covered

**`header`**
- Default: `null` (no header inside the scrollable area)
- Adds a widget that scrolls with the list, just above the first item. Unlike an `AppBar`, it moves when the user scrolls. Useful for a short instruction label tied to the list content.
- To demo: uncomment the `header:` block in `main.dart`, then hot reload.

**`proxyDecorator`**
- Default: `null` (Flutter applies a generic drop shadow on the dragged item)
- Lets you fully replace the visual wrapper around the item being dragged. Common use: add a colored border or higher elevation so users can clearly see which item is "in flight."
- To demo: uncomment the `proxyDecorator:` closure in `main.dart`, then hot reload.

**`buildDefaultDragHandles`**
- Default: `true` (the entire tile is a drag surface — tap anywhere to drag)
- When set to `false`, Flutter removes the automatic drag detection. You then wrap a specific widget (like a drag icon in `trailing`) with `ReorderableDragStartListener` to control exactly where the user can grab. Useful when tiles have tappable buttons and you don't want a tap to accidentally trigger a drag.
- To demo: change `buildDefaultDragHandles: true` to `false` in `main.dart`, then hot reload. Dragging on the tile body will stop working; only the handle icon will work.


