
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const Color _chatSurface = Color(0xFF151D33);
const Color _chatViolet = Color(0xFF9585FF);
const Color _chatMint = Color(0xFF52D6B5);
const Color _chatMuted = Color(0xFF9BA8C3);

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const MethodChannel _channel = MethodChannel('learnmate/ai');

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [];

  bool _modelLoaded = false;
  bool _loadingModel = false;
  bool _sending = false;
  String _status = 'AI model not loaded';
  Map<String, dynamic> _learnerProfile = {};
  bool _profileLoaded = false;

  Future<void> _loadModel() async {
    if (_loadingModel || _modelLoaded) return;

    setState(() {
      _loadingModel = true;
      _status = 'Loading AI model...';
    });

    try {
      final result = await _channel.invokeMethod<String>('loadModel');

      if (!mounted) return;

      setState(() {
        _modelLoaded = true;
        _status = result ?? 'AI model loaded successfully';
      });
    } on PlatformException catch (e) {
      if (!mounted) return;

      setState(() {
        _status = 'Loading failed: ${e.message ?? e.code}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _status = 'Loading failed: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _loadingModel = false);
      }
    }
  }

  Future<void> _sendMessage() async {
    final prompt = _controller.text.trim();

    if (prompt.isEmpty || !_modelLoaded || _sending) return;

    _controller.clear();

    setState(() {
      _messages.add(_ChatMessage(text: prompt, isUser: true));
      _sending = true;
    });

    _scrollToBottom();

    try {
  // Always get the latest assessment profile.
  await _loadLearnerProfile();

  final personalizedPrompt = _buildPersonalizedPrompt(prompt);

  final response = await _channel.invokeMethod<String>(
    'generate',
    {'prompt': personalizedPrompt},
  );


      if (!mounted) return;

      setState(() {
        _messages.add(
          _ChatMessage(
            text: response ?? 'The model returned an empty response.',
            isUser: false,
          ),
        );
      });
    } on PlatformException catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          _ChatMessage(
            text: 'AI error: ${e.message ?? e.code}',
            isUser: false,
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          _ChatMessage(text: 'Error: $e', isUser: false),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        _scrollToBottom();
      }
    }
  }
Future<void> _loadLearnerProfile() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final savedProfile = prefs.getString('learner_profile');

    if (savedProfile != null) {
      final decoded = jsonDecode(savedProfile);

      if (decoded is Map) {
        _learnerProfile = Map<String, dynamic>.from(decoded);
      }
    }
  } catch (e) {
    debugPrint('Profile loading error: $e');
  }

  if (mounted) {
    setState(() => _profileLoaded = true);
  }
}

@override
void initState() {
  super.initState();
  _loadLearnerProfile();
}

String _buildPersonalizedPrompt(String question) {
  final profile = _learnerProfile ?? {};

  final goal = profile['goal'] ?? 'Learn technical subjects';
  final level = profile['level'] ?? 'Beginner';
  final interests = profile['interests'] ?? [];
  final knownTopics = profile['knownTopics'] ?? [];
  final learningGaps = profile['learningGaps'] ?? [];

  return '''
You are LearnMate AI, a professional engineering education tutor.

IMPORTANT CONTEXT:
The student is studying Electronics and Communication Engineering (ECE).
Your primary subjects are:
- Digital Electronics
- VLSI Design
- Verilog HDL
- Computer Architecture
- Semiconductor Devices

ACRONYM RULE:
Always understand abbreviations using the engineering context.
For example:
FSM = Finite State Machine in Digital Electronics.
VLSI = Very Large Scale Integration.
HDL = Hardware Description Language.
Never invent unrelated meanings for technical abbreviations.

STUDENT PROFILE:
Learning goal: $goal
Skill level: $level
Interests: $interests
Known topics: $knownTopics
Learning gaps: $learningGaps

TEACHING RULES:
1. Answer the exact question asked.
2. Stay relevant to engineering and education.
3. Explain concepts using simple English.
4. Start with WHY the concept is needed.
5. Explain WHAT it is and HOW it works.
6. Use practical engineering examples.
7. Explain difficult words in simple language.
8. Do not invent facts.
9. If uncertain, clearly say so.
10. Avoid unrelated meanings and unnecessary content.

RESPONSE FORMAT:
- Simple definition
- Why it is needed
- How it works
- Practical example
- Short summary

Student question:
$question

Answer:
''';
}

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF302A65),
                child: Icon(Icons.smart_toy_rounded, color: _chatViolet),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LearnMate AI Tutor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Your offline learning companion',
                      style: TextStyle(color: _chatMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Load AI model',
                onPressed: _modelLoaded || _loadingModel ? null : _loadModel,
                icon: const Icon(Icons.download_rounded),
                color: _chatViolet,
              ),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _chatSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              if (_loadingModel)
                const SizedBox(
                  height: 17,
                  width: 17,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  _modelLoaded
                      ? Icons.check_circle_rounded
                      : Icons.info_outline_rounded,
                  color: _modelLoaded ? _chatMint : _chatViolet,
                  size: 19,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _status,
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ),
              if (!_modelLoaded && !_loadingModel)
                TextButton(
                  onPressed: _loadModel,
                  child: const Text(
                    'LOAD',
                    style: TextStyle(color: _chatViolet),
                  ),
                ),
            ],
          ),
        ),

        Expanded(
          child: _messages.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: _chatViolet.withOpacity(0.8),
                          size: 48,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Learn something new today.',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Load the AI model to start your first offline conversation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _chatMuted,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(18),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];

                    return Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 310),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? const Color(0xFF40377D)
                              : _chatSurface,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Text(
                          message.text,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),

        if (_sending)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'LearnMate is thinking...',
              style: TextStyle(color: _chatMuted, fontSize: 11),
            ),
          ),

        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: _modelLoaded && !_sending,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: _modelLoaded
                          ? 'Ask your learning question...'
                          : 'Load the model first...',
                      filled: true,
                      fillColor: _chatSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                IconButton.filled(
                  onPressed: _modelLoaded && !_sending
                      ? _sendMessage
                      : null,
                  style: IconButton.styleFrom(
                    backgroundColor: _chatViolet,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({
    required this.text,
    required this.isUser,
  });
}
