import 'package:flutter/material.dart';
import 'assessment_page.dart';
import 'chat_page.dart';

void main() {
  runApp(const LearnMateApp());
}

const Color bg = Color(0xFF0B1020);
const Color surface = Color(0xFF151D33);
const Color surface2 = Color(0xFF1C2742);
const Color violet = Color(0xFF9585FF);
const Color mint = Color(0xFF52D6B5);
const Color orange = Color(0xFFFFBD75);
const Color muted = Color(0xFF9BA8C3);

class LearnMateApp extends StatelessWidget {
  const LearnMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LearnMate AI',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: violet,
          brightness: Brightness.dark,
          surface: surface,
        ),
        fontFamily: 'Roboto',
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surface,
          indicatorColor: violet.withOpacity(0.20),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;
  String goal = 'Master VLSI Design';
  String level = 'Beginner';
  final Set<int> completedTasks = {0};

  void changeTab(int index) {
    setState(() => currentIndex = index);
  }

  void toggleTask(int index) {
    setState(() {
      if (completedTasks.contains(index)) {
        completedTasks.remove(index);
      } else {
        completedTasks.add(index);
      }
    });
  }

  void updateProfile(String newGoal, String newLevel) {
    setState(() {
      goal = newGoal;
      level = newLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        goal: goal,
        level: level,
        completedCount: completedTasks.length,
        onNavigate: changeTab,
        onPersonalise: () =>
            showPersonaliseDialog(context, goal, level, updateProfile),
      ),
      LearningPathPage(goal: goal, level: level),
      StudyPlanPage(completedTasks: completedTasks, onToggle: toggleTask),
      ProfilePage(
        goal: goal,
        level: level,
        onPersonalise: () =>
            showPersonaliseDialog(context, goal, level, updateProfile),
      ),
      const AssessmentPage(),
      const ChatPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: currentIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_rounded),
            label: 'My Path',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Planner',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_alt_rounded),
            label: 'Assess',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_rounded),
            label: 'AI Tutor',
          ),
        ],
      ),
    );
  }
}

// ---------------- REUSABLE UI COMPONENTS ----------------

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: muted, fontSize: 13),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;

  const SectionTitle({super.key, required this.title, this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            child: Text(action!, style: const TextStyle(color: violet)),
          ),
      ],
    );
  }
}

class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.055)),
      ),
      child: child,
    );
  }
}

class Tag extends StatelessWidget {
  final String label;
  final Color color;

  const Tag(this.label, {super.key, this.color = violet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double value;
  final Color color;

  const ProgressBar({super.key, required this.value, this.color = violet});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 7,
        backgroundColor: Colors.white.withOpacity(0.08),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

// ---------------- DASHBOARD ----------------

class DashboardPage extends StatelessWidget {
  final String goal;
  final String level;
  final int completedCount;
  final ValueChanged<int> onNavigate;
  final VoidCallback onPersonalise;

  const DashboardPage({
    super.key,
    required this.goal,
    required this.level,
    required this.completedCount,
    required this.onNavigate,
    required this.onPersonalise,
  });

  @override
  Widget build(BuildContext context) {
    final progress = completedCount / 4;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [violet, Color(0xFF6755DA)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LearnMate AI',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'YOUR PERSONAL LEARNING SPACE',
                      style: TextStyle(
                        color: muted,
                        fontSize: 9,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onPersonalise,
                icon: const Icon(Icons.tune_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: surface,
                  foregroundColor: violet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'GOOD TO SEE YOU 👋',
            style: TextStyle(
              color: mint,
              fontSize: 11,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Small steps.\nBig possibilities.',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your journey is unique. Let’s make every learning session count.',
            style: TextStyle(color: muted, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),

          // Personal learning goal card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF5546A8),
                  Color(0xFF302A65),
                  Color(0xFF1A2343),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.flag_rounded,
                      color: Color(0xFFFFD58B),
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'YOUR CURRENT GOAL',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Tag(level, color: orange),
                  ],
                ),
                const SizedBox(height: 17),
                Text(
                  goal,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: Color(0xFFFFD58B),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Keep building your knowledge',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: onPersonalise,
                      child: const Text(
                        'EDIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),

          const SectionTitle(title: 'Your learning overview'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.track_changes_rounded,
                  iconColor: violet,
                  value: '${(progress * 100).round()}%',
                  label: 'Today’s progress',
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: mint,
                  value: '$completedCount/4',
                  label: 'Tasks completed',
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          const SectionTitle(title: 'Continue your journey'),
          const SizedBox(height: 12),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: violet.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.memory_rounded,
                        color: violet,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Digital Electronics',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Module 02 • Logic Design',
                            style: TextStyle(color: muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Tag('IN PROGRESS', color: mint),
                  ],
                ),
                const SizedBox(height: 19),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Course progress',
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                    Text(
                      '35%',
                      style: TextStyle(
                        color: violet,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                const ProgressBar(value: 0.35),
                const SizedBox(height: 17),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => onNavigate(1),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Continue learning'),
                    style: FilledButton.styleFrom(
                      backgroundColor: violet,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          const SectionTitle(title: 'Your AI learning insight'),
          const SizedBox(height: 12),
          SurfaceCard(
            color: const Color(0xFF172B35),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_rounded, color: mint, size: 26),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A smarter way to learn',
                        style: TextStyle(
                          color: mint,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Build strong foundations first. Your learning pathway is organised into manageable milestones.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'LEARN AT YOUR PACE. GROW EVERY DAY.',
              style: TextStyle(
                color: muted,
                fontSize: 9,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 13),
          Text(
            value,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: muted, fontSize: 11)),
        ],
      ),
    );
  }
}

// ---------------- LEARNING PATH ----------------

class LearningPathPage extends StatelessWidget {
  final String goal;
  final String level;

  const LearningPathPage({super.key, required this.goal, required this.level});

  final List<Map<String, dynamic>> modules = const [
    {
      'title': 'Foundation',
      'subtitle': 'Understand the essential concepts',
      'duration': '3 lessons',
      'icon': Icons.foundation_rounded,
      'status': 'COMPLETED',
      'color': mint,
    },
    {
      'title': 'Core concepts',
      'subtitle': 'Develop your technical understanding',
      'duration': '5 lessons',
      'icon': Icons.memory_rounded,
      'status': 'CURRENT',
      'color': violet,
    },
    {
      'title': 'Practical application',
      'subtitle': 'Apply concepts through projects',
      'duration': '4 lessons',
      'icon': Icons.build_circle_rounded,
      'status': 'UP NEXT',
      'color': orange,
    },
    {
      'title': 'Advanced mastery',
      'subtitle': 'Challenge yourself with advanced topics',
      'duration': '6 lessons',
      'icon': Icons.emoji_events_rounded,
      'status': 'LOCKED',
      'color': muted,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'My learning path',
            subtitle: 'A roadmap designed around your goal.',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(19),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43388D), Color(0xFF202A50)],
                ),
                borderRadius: BorderRadius.circular(23),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Tag('PERSONALISED ROADMAP', color: mint),
                  const SizedBox(height: 13),
                  Text(
                    goal,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current level: $level',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 18),
                  const ProgressBar(value: 0.35, color: mint),
                  const SizedBox(height: 9),
                  const Text(
                    'Your roadmap is ready to explore',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 26, 22, 13),
            child: SectionTitle(title: 'Learning milestones'),
          ),
          ...List.generate(modules.length, (index) {
            final item = modules[index];
            final color = item['color'] as Color;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 48,
                    child: Column(
                      children: [
                        Container(
                          height: 43,
                          width: 43,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: color.withOpacity(0.3)),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: color,
                            size: 21,
                          ),
                        ),
                        if (index != modules.length - 1)
                          Container(
                            height: 75,
                            width: 2,
                            color: Colors.white.withOpacity(0.10),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: SurfaceCard(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['title'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Tag(item['status'] as String, color: color),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            item['subtitle'] as String,
                            style: const TextStyle(
                              color: muted,
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.menu_book_rounded,
                                size: 14,
                                color: muted,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                item['duration'] as String,
                                style: const TextStyle(
                                  color: muted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: SurfaceCard(
              color: const Color(0xFF172B35),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: mint, size: 25),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your roadmap can evolve as you improve your skills.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- STUDY PLANNER ----------------

class StudyPlanPage extends StatelessWidget {
  final Set<int> completedTasks;
  final ValueChanged<int> onToggle;

  const StudyPlanPage({
    super.key,
    required this.completedTasks,
    required this.onToggle,
  });

  final List<Map<String, String>> tasks = const [
    {
      'time': '09:00 AM',
      'title': 'Revise digital logic basics',
      'subject': 'Digital Electronics',
      'duration': '25 min',
    },
    {
      'time': '10:00 AM',
      'title': 'Learn sequential circuits',
      'subject': 'Core Concepts',
      'duration': '30 min',
    },
    {
      'time': '04:00 PM',
      'title': 'Practise Verilog RTL',
      'subject': 'Practical Learning',
      'duration': '35 min',
    },
    {
      'time': '07:00 PM',
      'title': 'Review and self-assessment',
      'subject': 'Revision',
      'duration': '15 min',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final progress = completedTasks.length / tasks.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Study planner',
            subtitle: 'Consistency matters more than speed.',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Your daily focus',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Tag('TODAY', color: mint),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${completedTasks.length}',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7, left: 5),
                        child: Text(
                          '/ ${tasks.length} tasks completed',
                          style: const TextStyle(color: muted, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ProgressBar(value: progress, color: mint),
                  const SizedBox(height: 10),
                  Text(
                    '${(progress * 100).round()}% of your planned tasks completed',
                    style: const TextStyle(color: muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 27, 22, 14),
            child: SectionTitle(title: 'Your study sessions'),
          ),
          ...List.generate(tasks.length, (index) {
            final task = tasks[index];
            final isDone = completedTasks.contains(index);
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 11),
              child: SurfaceCard(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      height: 43,
                      width: 43,
                      decoration: BoxDecoration(
                        color: isDone
                            ? mint.withOpacity(0.13)
                            : violet.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        isDone ? Icons.check_rounded : Icons.menu_book_rounded,
                        color: isDone ? mint : violet,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['time']!,
                            style: const TextStyle(color: muted, fontSize: 10),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            task['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isDone ? muted : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${task['subject']} • ${task['duration']}',
                            style: const TextStyle(color: muted, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: isDone,
                      activeColor: mint,
                      onChanged: (_) => onToggle(index),
                    ),
                  ],
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SurfaceCard(
              color: const Color(0xFF172B35),
              child: const Row(
                children: [
                  Icon(Icons.favorite_rounded, color: mint, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Take breaks. Rest is also part of learning.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- PROFILE ----------------

class ProfilePage extends StatelessWidget {
  final String goal;
  final String level;
  final VoidCallback onPersonalise;

  const ProfilePage({
    super.key,
    required this.goal,
    required this.level,
    required this.onPersonalise,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          const PageHeader(
            title: 'Your profile',
            subtitle: 'Your goals. Your pace. Your journey.',
          ),
          Container(
            height: 94,
            width: 94,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [violet, Color(0xFF594AC0)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: violet.withOpacity(0.2),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 49,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Learner',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your personal learning space',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LEARNING PREFERENCES',
                    style: TextStyle(
                      color: muted,
                      fontSize: 10,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 19),
                  _ProfileRow(
                    icon: Icons.flag_rounded,
                    label: 'Learning goal',
                    value: goal,
                  ),
                  const Divider(height: 28, color: Colors.white12),
                  _ProfileRow(
                    icon: Icons.signal_cellular_alt_rounded,
                    label: 'Current skill level',
                    value: level,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onPersonalise,
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('Update preferences'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: violet,
                        side: const BorderSide(color: violet),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SurfaceCard(
              child: const Column(
                children: [
                  _MenuRow(
                    icon: Icons.offline_bolt_rounded,
                    title: 'Offline-first learning',
                    subtitle: 'Designed for on-device AI',
                  ),
                  Divider(height: 25, color: Colors.white12),
                  _MenuRow(
                    icon: Icons.security_rounded,
                    title: 'Privacy',
                    subtitle: 'Your learning data stays on your device',
                  ),
                  Divider(height: 25, color: Colors.white12),
                  _MenuRow(
                    icon: Icons.info_outline_rounded,
                    title: 'About LearnMate AI',
                    subtitle: 'Personalised learning companion',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'LEARNMATE AI • LEARN WITHOUT LIMITS',
            style: TextStyle(
              color: muted,
              fontSize: 9,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: violet, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: muted, fontSize: 11)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: mint, size: 23),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: muted, fontSize: 10),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: muted),
      ],
    );
  }
}

// ---------------- PERSONALISATION ----------------

Future<void> showPersonaliseDialog(
  BuildContext context,
  String currentGoal,
  String currentLevel,
  void Function(String, String) onSave,
) async {
  String selectedGoal = currentGoal;
  String selectedLevel = currentLevel;

  const goals = [
    'Master VLSI Design',
    'Learn Programming',
    'Prepare for Exams',
    'Improve Communication',
    'Build Career Skills',
  ];

  const levels = ['Beginner', 'Intermediate', 'Advanced'];

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                24,
                22,
                MediaQuery.of(context).viewInsets.bottom + 22,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: violet,
                      size: 30,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Personalise your journey',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Tell us what you want to achieve and where you are starting.',
                      style: TextStyle(color: muted, fontSize: 12, height: 1.5),
                    ),
                    const SizedBox(height: 23),
                    const Text(
                      'WHAT IS YOUR LEARNING GOAL?',
                      style: TextStyle(
                        fontSize: 10,
                        color: muted,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 9,
                      children: goals.map((item) {
                        final selected = selectedGoal == item;
                        return ChoiceChip(
                          label: Text(item),
                          selected: selected,
                          selectedColor: violet.withOpacity(0.25),
                          onSelected: (_) {
                            setModalState(() => selectedGoal = item);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 23),
                    const Text(
                      'YOUR CURRENT SKILL LEVEL',
                      style: TextStyle(
                        fontSize: 10,
                        color: muted,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: levels.map((item) {
                        return ChoiceChip(
                          label: Text(item),
                          selected: selectedLevel == item,
                          selectedColor: mint.withOpacity(0.22),
                          onSelected: (_) {
                            setModalState(() => selectedLevel = item);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          onSave(selectedGoal, selectedLevel);
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: violet,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Save my preferences',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
