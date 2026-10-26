# ReorderableListView Demo

A Flutter demo app showing how `ReorderableListView` lets users drag and drop list items to reorder them.

## How to Run

```bash
git clone <repo-url>
cd reorderable_list_demo
flutter pub get
flutter run
```

Press `r` in the terminal to hot reload after making code changes.

## Key Attributes

- **`key`** — Each card gets its own `ValueKey(task.id)`. Flutter uses it to
  tell the cards apart while they shift around during a drag.

- **`ReorderableDragStartListener`** — Wraps the handle icon on the right of
  each card. It picks up the moment a drag starts on that card.

- **`onReorder`** — Runs when the card is dropped. It gets `oldIndex` and
  `newIndex`, subtracts one from `newIndex` if the card moved down the list,
  then does the move with `removeAt` and `insert`. All of it sits inside
  `setState()`, so the list redraws in the new order.


**`Screenshot of App`**
<img width="720" height="1600" alt="Reordablelistappscreenshot" src="https://github.com/user-attachments/assets/3b63da0e-d8b0-42d8-8f08-c8dcf5c32d03" />


