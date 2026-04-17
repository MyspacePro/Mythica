import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final bool isPrivateChat;

  const ChatScreen({
    super.key,
    required this.title,
    this.isPrivateChat = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final String? replyTo;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.replyTo,
  });
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color bgSecondary = Color(0xFF2A1E47);
  static const Color bgDeep = Color(0xFF140F26);
  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);
  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardBorder = Color(0xFF3A2D5C);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _recordController;

  final List<ChatMessage> messages = [];
  bool showScrollButton = false;
  bool isRecording = false;
  ChatMessage? replyingTo;

  @override
  void initState() {
    super.initState();
    _recordController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _loadDummyMessages();
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset < _scrollController.position.maxScrollExtent - 300;
      if (shouldShow != showScrollButton) {
        setState(() => showScrollButton = shouldShow);
      }
    });
  }

  void _loadDummyMessages() {
    messages.addAll([
      ChatMessage(id: '1', text: widget.isPrivateChat ? 'Hey, what are you reading?' : 'Has anyone read Atomic Habits?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 5))),
      ChatMessage(id: '2', text: 'Yes! It\'s amazing 🔥', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 4))),
      ChatMessage(id: '3', text: widget.isPrivateChat ? 'Let\'s discuss tonight.' : 'Any fantasy book recommendations?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 2))),
    ]);
  }

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: true,
        time: DateTime.now(),
        replyTo: replyingTo?.text,
      ));
      _controller.clear();
      replyingTo = null;
    });

    Future.delayed(const Duration(milliseconds: 150), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _formatTime(DateTime time) => '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _recordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [bgPrimary, bgSecondary, bgDeep], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              Expanded(child: _buildChatContainer()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: textSecondary)),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(shape: BoxShape.circle, color: goldPrimary, boxShadow: [BoxShadow(color: goldGlow.withValues(alpha:0.3), blurRadius: 15)]),
            child: const Icon(Icons.menu_book, color: bgPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.isPrivateChat ? 'Online now' : '1,248 members • 342 online', style: const TextStyle(color: textMuted, fontSize: 12)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: goldPrimary)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: textSecondary)),
        ],
      ),
    );
  }

  Widget _buildChatContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Container(
          decoration: BoxDecoration(color: cardFill.withValues(alpha:0.95), borderRadius: BorderRadius.circular(35), border: Border.all(color: cardBorder)),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) => _buildMessage(messages[index]),
                ),
              ),
              if (showScrollButton)
                FloatingActionButton(mini: true, backgroundColor: goldPrimary, onPressed: _scrollToBottom, child: const Icon(Icons.arrow_downward, color: bgPrimary)),
              _inputSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return GestureDetector(
      onLongPress: () => setState(() => replyingTo = message),
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: message.isMe ? goldPrimary : cardFill,
            borderRadius: BorderRadius.circular(22),
            border: message.isMe ? null : Border.all(color: cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.replyTo != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(color: bgPrimary.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
                  child: Text(message.replyTo!, style: const TextStyle(fontSize: 12, color: textSecondary)),
                ),
              Text(message.text, style: TextStyle(color: message.isMe ? bgPrimary : textSecondary)),
              const SizedBox(height: 6),
              Text(_formatTime(message.time), style: const TextStyle(fontSize: 10, color: textMuted)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onLongPressStart: (_) => setState(() => isRecording = true),
            onLongPressEnd: (_) => setState(() => isRecording = false),
            child: AnimatedBuilder(
              animation: _recordController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isRecording ? 1 + (_recordController.value * 0.2) : 1,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: goldPrimary),
                    child: const Icon(Icons.mic, color: bgPrimary),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: bgPrimary.withValues(alpha:0.6), borderRadius: BorderRadius.circular(30), border: Border.all(color: cardBorder)),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => sendMessage(),
                style: const TextStyle(color: textSecondary),
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: textMuted),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: goldPrimary),
              child: const Icon(Icons.send, color: bgPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
