import 'package:flutter/material.dart';
// flutter run -d chrome
void main() => runApp(const App());

//Data

typedef Task = ({
  String id,
  String title,
  String ticket,
  String assignee,
  String due,
  String priority,
});

// priority label (background, foreground) colors
const _pStyle = <String, (Color, Color)>{
  'Urgent':      (Color(0xFFFFEDED), Color(0xFFDC2626)),
  'In Progress': (Color(0xFFEDF4FF), Color(0xFF2563EB)),
  'Feature':     (Color(0xFFEDFFF4), Color(0xFF16A34A)),
  'Review':      (Color(0xFFFFF8ED), Color(0xFFD97706)),
  'Blocked':     (Color(0xFFF5EDFF), Color(0xFF7C3AED)),
};

//App

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Sprint Board',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
      useMaterial3: true,
    ),
    home: const SprintBoardPage(),
  );
}

//Screen

class SprintBoardPage extends StatefulWidget {
  const SprintBoardPage({super.key});
  @override
  State<SprintBoardPage> createState() => _SprintBoardState();
}

class _SprintBoardState extends State<SprintBoardPage> {
  final List<Task> _tasks = [
    (id: '1', title: 'Redesign onboarding flow',    ticket: 'DEV-201', assignee: 'JK', due: 'Oct 26', priority: 'Urgent'),
    (id: '2', title: 'Implement drag-to-reorder',   ticket: 'DEV-204', assignee: 'MA', due: 'Nov 5',  priority: 'In Progress'),
    (id: '3', title: 'Add dark mode support',       ticket: 'DEV-207', assignee: 'SL', due: 'Nov 12', priority: 'Feature'),
    (id: '4', title: 'Write API integration tests', ticket: 'DEV-210', assignee: 'RT', due: 'Nov 27', priority: 'Review'),
    (id: '5', title: 'Fix auth token refresh bug',  ticket: 'DEV-213', assignee: 'JK', due: 'Oct 27', priority: 'Blocked'),
    (id: '6', title: 'Optimize cold start time',    ticket: 'DEV-218', assignee: 'MA', due: 'Oct 29', priority: 'Feature'),
  ];

  // Reorder Logic
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex -= 1;
      _tasks.insert(newIndex, _tasks.removeAt(oldIndex));
    });
  }

  /// lift card = dragged.
  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = Curves.easeOut.transform(animation.value);
        return Transform.scale(
          scale: 1 + (0.025 * t),
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.18 * t),
                    blurRadius: 28 * t,
                    offset: Offset(0, 10 * t),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 24,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: _ProgressRail(done: 0.5),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sprint 14',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: Color(0xFF0F172A))),
            SizedBox(height: 2),
            Text('6 tasks, 3 in progress',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF8A96A6))),
          ],
        ),
        actions: const [
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFEEF2FF),
            child: Text('JK',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6366F1))),
          ),
          SizedBox(width: 20),
        ],
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ReorderableListView(
            buildDefaultDragHandles: false,
            proxyDecorator: _proxyDecorator,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
            onReorder: _onReorder,
            children: [
              for (int i = 0; i < _tasks.length; i++)
                _TaskCard(key: ValueKey(_tasks[i].id), index: i, task: _tasks[i]),
            ],
          ),
        ),
      ),
    );
  }
}

//Widgets

class _ProgressRail extends StatelessWidget {
  const _ProgressRail({required this.done});
  final double done;

  @override
  Widget build(BuildContext context) => Container(
    height: 3,
    color: const Color(0xFFE6EBF2),
    child: FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: done,
      child: Container(color: const Color(0xFF6366F1)),
    ),
  );
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required super.key, required this.index, required this.task});
  final int index;
  final Task task;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) =
        _pStyle[task.priority] ?? (const Color(0xFFF1F5F9), const Color(0xFF64748B));

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6EBF2)),
        boxShadow: const [
          BoxShadow(color: Color(0x0D0F172A), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4, color: fg),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
                leading: CircleAvatar(
                  radius: 17,
                  backgroundColor: bg,
                  child: Text(task.assignee,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          color: fg)),
                ),
                title: Text(task.title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                        color: Color(0xFF0F172A))),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(children: [
                    _Pill(label: task.priority, bg: bg, fg: fg),
                    const SizedBox(width: 10),
                    Text(task.ticket,
                        style: const TextStyle(
                            fontSize: 11.5,
                            fontFamily: 'monospace',
                            color: Color(0xFF94A3B8))),
                    const Spacer(),
                    const Icon(Icons.schedule_rounded,
                        size: 12, color: Color(0xFFC3CDD9)),
                    const SizedBox(width: 4),
                    Text(task.due,
                        style: const TextStyle(
                            fontSize: 11.5, color: Color(0xFF94A3B8))),
                  ]),
                ),
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                      child: Icon(Icons.drag_indicator_rounded,
                          color: const Color(0xFFB4C0CE), size: 22),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg, fg;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: fg)),
  );
}