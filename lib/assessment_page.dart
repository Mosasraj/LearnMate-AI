import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  static const bg = Color(0xFF0B1020);
  static const surface = Color(0xFF151D33);
  static const violet = Color(0xFF9585FF);
  static const mint = Color(0xFF52D6B5);
  static const muted = Color(0xFF9BA8C3);

  int step = 0;
  String goal = 'Master VLSI Design';
  String level = 'Beginner';
  String confidence = 'Somewhat confident';
  final Set<String> interests = {'Digital Electronics'};
  final Set<String> knownTopics = {'Logic Gates'};

  final List<String> goals = [
    'Master VLSI Design',
    'Learn Verilog Programming',
    'Prepare for Exams',
    'Build Career Skills',
  ];

  final List<String> interestOptions = [
    'Digital Electronics',
    'Verilog HDL',
    'Computer Architecture',
    'CMOS Design',
    'Embedded Systems',
  ];

  final List<String> topics = [
    'Number Systems',
    'Logic Gates',
    'Boolean Algebra',
    'K-Maps',
    'Flip-Flops',
    'FSM Design',
    'Verilog RTL',
    'Memory Design',
    'CMOS Basics',
  ];

  List<String> get gaps =>
      topics.where((topic) => !knownTopics.contains(topic)).toList();
  Future<void> saveLearnerProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final profile = {
      'goal': goal,
      'level': level,
      'confidence': confidence,
      'interests': interests.toList(),
      'knownTopics': knownTopics.toList(),
      'learningGaps': gaps,
      'assessmentDate': DateTime.now().toIso8601String(),
    };

    await prefs.setString('learner_profile', jsonEncode(profile));
  }

  Future<void> next() async {
    if (step < 2) {
      setState(() => step++);
    } else {
      await saveLearnerProfile();

      if (!mounted) return;

      setState(() => step = 3);
    }
  }

  void back() {
    if (step > 0) setState(() => step--);
  }

  Widget heading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(color: muted, fontSize: 13, height: 1.5),
        ),
      ],
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 23),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget choice({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? violet.withOpacity(0.16) : surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? violet : Colors.white12,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: selected ? Colors.white : muted,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? violet : muted,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGoalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(
          'Let’s understand you.',
          'First, tell us what you want to achieve.',
        ),
        sectionTitle('1. What is your main learning goal?'),
        ...goals.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: choice(
              text: item,
              selected: goal == item,
              onTap: () => setState(() => goal = item),
            ),
          ),
        ),
        sectionTitle('2. What is your current skill level?'),
        ...['Beginner', 'Intermediate', 'Advanced'].map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: choice(
              text: item,
              selected: level == item,
              onTap: () => setState(() => level = item),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInterestStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(
          'What interests you?',
          'Choose the subjects you want to explore. Select as many as you like.',
        ),
        sectionTitle('Your areas of interest'),
        ...interestOptions.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: choice(
              text: item,
              selected: interests.contains(item),
              onTap: () {
                setState(() {
                  if (interests.contains(item)) {
                    interests.remove(item);
                  } else {
                    interests.add(item);
                  }
                });
              },
            ),
          ),
        ),
        sectionTitle('How confident do you feel about your goal?'),
        ...['Not confident yet', 'Somewhat confident', 'Very confident'].map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: choice(
              text: item,
              selected: confidence == item,
              onTap: () => setState(() => confidence = item),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildKnowledgeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(
          'What do you already know?',
          'Select the topics you are comfortable with. Be honest — this helps identify your learning gaps.',
        ),
        sectionTitle('Your knowledge checklist'),
        ...topics.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: choice(
              text: item,
              selected: knownTopics.contains(item),
              onTap: () {
                setState(() {
                  if (knownTopics.contains(item)) {
                    knownTopics.remove(item);
                  } else {
                    knownTopics.add(item);
                  }
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'You can select zero topics if you are starting from scratch.',
          style: TextStyle(color: muted, fontSize: 11),
        ),
      ],
    );
  }

  Widget buildResult() {
    final completed = knownTopics.length;
    final missing = gaps.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Icon(Icons.auto_awesome_rounded, color: mint, size: 55),
        ),
        const SizedBox(height: 17),
        const Center(
          child: Text(
            'Your assessment is ready!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 23,
            ),
          ),
        ),
        const SizedBox(height: 9),
        const Center(
          child: Text(
            'Here is your initial learning profile.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YOUR LEARNER PROFILE',
                style: TextStyle(
                  color: mint,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 17),
              resultRow('Goal', goal),
              resultRow('Skill level', level),
              resultRow('Confidence', confidence),
              resultRow('Topics selected as known', '$completed'),
              resultRow('Topics to explore', '$missing'),
            ],
          ),
        ),
        sectionTitle('Recommended learning priorities'),
        ...gaps
            .take(5)
            .map(
              (topic) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.play_circle_outline_rounded,
                      color: violet,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        topic,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        if (gaps.isEmpty)
          const Text(
            'You marked all listed topics as known. Your next step is advanced practice and assessment.',
            style: TextStyle(color: mint, height: 1.5),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: violet.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'This is an initial checklist-based assessment. The Llama-powered adaptive assessment will be connected in the next development stage.',
            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => setState(() => step = 0),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retake assessment'),
            style: FilledButton.styleFrom(
              backgroundColor: violet,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: muted, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        title: const Text(
          'Learner assessment',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (step < 3)
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(
                        3,
                        (index) => Expanded(
                          child: Container(
                            height: 5,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: index <= step ? violet : surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'STEP ${step + 1} OF 3',
                        style: const TextStyle(
                          color: muted,
                          fontSize: 10,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
                child: step == 0
                    ? buildGoalStep()
                    : step == 1
                    ? buildInterestStep()
                    : step == 2
                    ? buildKnowledgeStep()
                    : buildResult(),
              ),
            ),
            if (step < 3)
              Container(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
                decoration: const BoxDecoration(
                  color: surface,
                  border: Border(top: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  children: [
                    if (step > 0)
                      OutlinedButton(
                        onPressed: back,
                        child: const Text('Back'),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: next,
                      style: FilledButton.styleFrom(
                        backgroundColor: violet,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 27,
                          vertical: 14,
                        ),
                      ),
                      child: Text(step == 2 ? 'Analyse my skills' : 'Continue'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
