# ReorderableListView Demo

A Flutter demo app showing how `ReorderableListView` lets users drag and drop list items to reorder them.

## How to Run

```bash
git clone https://github.com/Kiguru-Alu/FlutterWidgetDemo
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




<img width="502" height="901" alt="ReordableListWidgetAppScreenshot" src="https://github.com/user-attachments/assets/6c743153-80c0-423d-80c7-248db8661a79" />



