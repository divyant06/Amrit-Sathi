import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/prefs_service.dart';
import 'package:latlong2/latlong.dart' hide Path;

// ─────────────────────────────────────────────
// Accent colours (same in both modes)
// ─────────────────────────────────────────────
const Color _kTeal = Color(0xFF14B8A6);
const Color _kBlue = Color(0xFF3B82F6);

// ─────────────────────────────────────────────
// Suggestion chips
// ─────────────────────────────────────────────
class _Chip {
  final String label;
  final IconData icon;
  final Color accent;
  const _Chip(this.label, this.icon, this.accent);
}

const _kChips = [
  _Chip('Estimate Budget', Icons.receipt_long_outlined, Color(0xFF0E7490)),
  _Chip('Nearby Hostels', Icons.bed_outlined, Color(0xFF6D28D9)),
  _Chip('Story Mode', Icons.auto_stories_outlined, Color(0xFF0F766E)),
  _Chip('Street Food', Icons.ramen_dining_outlined, Color(0xFFB45309)),
  _Chip('Pack My Bag', Icons.luggage_outlined, Color(0xFF065F46)),
  _Chip('Hidden Gems', Icons.diamond_outlined, Color(0xFF1D4ED8)),
];

// ─────────────────────────────────────────────
// Message model
// ─────────────────────────────────────────────
class _Msg {
  final String role; // 'user' | 'ai'
  final String text;
  final String timestamp;

  _Msg({required this.role, required this.text})
    : timestamp = _fmt(DateTime.now());

  // Private constructor that preserves a saved timestamp (used when loading from storage)
  _Msg._raw({required this.role, required this.text, required this.timestamp});

  static String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Map<String, String> toMap() => {'role': role, 'text': text, 'timestamp': timestamp};

  factory _Msg.fromMap(Map<String, String> m) => _Msg._raw(
    role: m['role'] ?? 'ai',
    text: m['text'] ?? '',
    timestamp: m['timestamp'] ?? '',
  );
}

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────
class CopilotScreen extends StatefulWidget {
  final ValueChanged<LatLng>? onLocationSearched;
  const CopilotScreen({super.key, this.onLocationSearched});

  @override
  State<CopilotScreen> createState() => _CopilotScreenState();
}

class _CopilotScreenState extends State<CopilotScreen> {
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _hasText = false;
  bool _isLoading = false;

  final List<_Msg> _messages = [];

  // Local mocking enabled. External API elements removed.

  @override
  void initState() {
    super.initState();



    // ── Restore saved chat history ──
    final saved = PrefsService.instance.loadChat();
    if (saved.isNotEmpty) {
      _messages.addAll(
        saved.map((m) => _Msg.fromMap(m)),
      );
    }

    _inputCtrl.addListener(() {
      final has = _inputCtrl.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }



  // ── Scroll to bottom after new message ──
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  static const Map<String, LatLng> _locations = {
    // State Capitals
    'new delhi': LatLng(28.6139, 77.2090),
    'delhi': LatLng(28.6139, 77.2090),
    'mumbai': LatLng(19.0760, 72.8777),
    'bengaluru': LatLng(12.9716, 77.5946),
    'bangalore': LatLng(12.9716, 77.5946),
    'chennai': LatLng(13.0827, 80.2707),
    'kolkata': LatLng(22.5726, 88.3639),
    'hyderabad': LatLng(17.3850, 78.4867),
    'thiruvananthapuram': LatLng(8.5241, 76.9366),
    'lucknow': LatLng(26.8467, 80.9462),
    'patna': LatLng(25.5941, 85.1376),
    'jaipur': LatLng(26.9124, 75.7873),
    'gandhinagar': LatLng(23.2156, 72.6369),
    'ahmedabad': LatLng(23.0225, 72.5714),
    'bhopal': LatLng(23.2599, 77.4126),
    'chandigarh': LatLng(30.7333, 76.7794),
    'bhubaneswar': LatLng(20.2961, 85.8245),
    'dehradun': LatLng(30.3165, 78.0322),
    'shimla': LatLng(31.1048, 77.1734),
    'srinagar': LatLng(34.0837, 74.7973),
    'guwahati': LatLng(26.1445, 91.7362),
    'panaji': LatLng(15.4909, 73.8278),
    'goa': LatLng(15.2993, 74.1240),
    
    // Famous Destinations
    'manali': LatLng(32.2396, 77.1887),
    'rishikesh': LatLng(30.0869, 78.2676),
    'udaipur': LatLng(24.5854, 73.7125),
    'agra': LatLng(27.1767, 78.0081),
    'munnar': LatLng(10.0889, 77.0595),
    'darjeeling': LatLng(27.0410, 88.2663),
    'varanasi': LatLng(25.3176, 82.9739),
    'kashi': LatLng(25.3176, 82.9739),
    'kochi': LatLng(9.9312, 76.2673),
    'pune': LatLng(18.5204, 73.8567),
    'mysore': LatLng(12.2958, 76.6394),
    'jodhpur': LatLng(26.2389, 73.0243),
    'jaisalmer': LatLng(26.9157, 70.9083),
    'ooty': LatLng(11.4100, 76.6950),
    'leh': LatLng(34.1526, 77.5771),
    'ladakh': LatLng(34.1526, 77.5771),
    'gangtok': LatLng(27.3314, 88.6138),
    'shillong': LatLng(25.5788, 91.8933),
    'andaman': LatLng(11.7401, 92.6586),
    'kanyakumari': LatLng(8.0883, 77.5385),
    'amritsar': LatLng(31.6340, 74.8723),
    'hampi': LatLng(15.3350, 76.4600),
    'pondicherry': LatLng(11.9416, 79.8083),
    'khajuraho': LatLng(24.8318, 79.9199),
  };

  // ── Send message to Gemini (Intercepted for Location Routing) ──
  Future<void> _sendMessage([String? optionalText]) async {
    final text = optionalText ?? _inputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Msg(role: 'user', text: text));
      _isLoading = true;
    });
    _inputCtrl.clear();
    _scrollToBottom();

    // Give a slight delay to simulate "thinking"
    await Future.delayed(const Duration(milliseconds: 600));

    final q = text.toLowerCase();
    String? matchedKey;
    for (final key in _locations.keys) {
      if (q.contains(key)) {
        matchedKey = key;
        break;
      }
    }

    if (!mounted) return;

    if (matchedKey != null) {
      final displayName = matchedKey.split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '').join(' ');
      
      setState(() {
        _messages.add(_Msg(role: 'ai', text: 'Sure thing! Taking you to $displayName...'));
        _isLoading = false;
      });
      _scrollToBottom();
      
      await PrefsService.instance.saveChat(
        _messages.map((m) => m.toMap()).toList(),
      );

      // Delay for a natural feel before switching tabs
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;
      widget.onLocationSearched?.call(_locations[matchedKey]!);
    } else {
      setState(() {
        _messages.add(_Msg(role: 'ai', text: 'That sounds like a great idea! Where exactly would you like to go?'));
        _isLoading = false;
      });
      _scrollToBottom();
      
      await PrefsService.instance.saveChat(
        _messages.map((m) => m.toMap()).toList(),
      );
    }
  }

  void _onChipTap(String label) {
    _inputCtrl.text = label;
    _focusNode.requestFocus();
    setState(() => _hasText = true);
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      resizeToAvoidBottomInset: true,
      appBar: _CopilotAppBar(),
      body: Column(
        children: [
          // Search Bar removed

          // ── Suggestion chips ──
          _ChipRow(chips: _kChips, onTap: _onChipTap),
          Divider(height: 1, thickness: 1, color: c.border),

          // ── Chat list ──
          Expanded(
            child: _messages.isEmpty
                ? _EmptyState(c: c)
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (_isLoading && i == _messages.length) {
                        return const _TypingIndicator();
                      }
                      return _BubbleRow(message: _messages[i]);
                    },
                  ),
          ),

          // ── Input bar ──
          _InputBar(
            controller: _inputCtrl,
            focusNode: _focusNode,
            hasText: _hasText,
            isLoading: _isLoading,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final AppColors c;
  const _EmptyState({required this.c});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _kTeal.withValues(alpha: 0.1),
              border: Border.all(
                color: _kTeal.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: const Icon(Icons.route_rounded, color: _kTeal, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            'Ask Amrit Sathi anything',
            style: TextStyle(
              color: c.text,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Budget tips · Hidden gems · Hostel picks',
            style: TextStyle(color: c.muted, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Typing indicator (3 animated dots)
// ─────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _AiAvatar(),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              color: c.card,
              border: Border.all(color: c.border, width: 1),
            ),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final delay = i * 0.3;
                  final alpha =
                      (((_anim.value - delay).clamp(0.0, 1.0)) * 0.9 + 0.1)
                          .clamp(0.1, 1.0);
                  return Padding(
                    padding: EdgeInsets.only(right: i < 2 ? 4 : 0),
                    child: Opacity(
                      opacity: alpha,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _kTeal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Chip Row
// ─────────────────────────────────────────────
class _ChipRow extends StatelessWidget {
  final List<_Chip> chips;
  final ValueChanged<String> onTap;
  const _ChipRow({required this.chips, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, i) =>
            _ChipItem(chip: chips[i], onTap: () => onTap(chips[i].label)),
      ),
    );
  }
}

class _ChipItem extends StatefulWidget {
  final _Chip chip;
  final VoidCallback onTap;
  const _ChipItem({required this.chip, required this.onTap});

  @override
  State<_ChipItem> createState() => _ChipItemState();
}

class _ChipItemState extends State<_ChipItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: _hover ? widget.chip.accent.withValues(alpha: 0.18) : c.card,
            border: Border.all(
              color: _hover
                  ? widget.chip.accent.withValues(alpha: 0.45)
                  : c.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.chip.icon,
                size: 13,
                color: _hover ? widget.chip.accent : c.muted,
              ),
              const SizedBox(width: 5),
              Text(
                widget.chip.label,
                style: TextStyle(
                  color: _hover ? c.text : c.subtext,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Chat Bubble Row
// ─────────────────────────────────────────────
class _BubbleRow extends StatelessWidget {
  final _Msg message;
  const _BubbleRow({required this.message});

  bool get _isUser => message.role == 'user';

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: _isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isUser) ...[_AiAvatar(), const SizedBox(width: 10)],
          Flexible(
            child: Column(
              crossAxisAlignment: _isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 2, right: 2),
                  child: Text(
                    _isUser ? 'You' : 'Amrit Sathi',
                    style: TextStyle(
                      color: c.muted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                _isUser
                    ? _UserBubble(message: message)
                    : _AiBubble(message: message, c: c),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 2, right: 2),
                  child: Text(
                    message.timestamp,
                    style: TextStyle(
                      color: c.muted,
                      fontSize: 10.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isUser) ...[const SizedBox(width: 10), _UserAvatar()],
        ],
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final _Msg message;
  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border.all(color: _kBlue.withValues(alpha: 0.2), width: 1),
      ),
      child: _RichText(text: message.text, isUser: true),
    );
  }
}

class _AiBubble extends StatelessWidget {
  final _Msg message;
  final AppColors c;
  const _AiBubble({required this.message, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.82,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: c.card,
        border: Border.all(color: c.border, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: const BoxDecoration(
                color: _kTeal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                child: _RichText(text: message.text, isUser: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Avatars
// ─────────────────────────────────────────────
class _AiAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _kTeal.withValues(alpha: 0.12),
        border: Border.all(color: _kTeal.withValues(alpha: 0.3), width: 1),
      ),
      child: const Icon(Icons.route_rounded, color: _kTeal, size: 14),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _kBlue.withValues(alpha: 0.15),
        border: Border.all(color: _kBlue.withValues(alpha: 0.3), width: 1),
      ),
      child: const Center(
        child: Text(
          'Y',
          style: TextStyle(
            color: _kBlue,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Rich text parser (**bold**)
// ─────────────────────────────────────────────
class _RichText extends StatelessWidget {
  final String text;
  final bool isUser;
  const _RichText({required this.text, required this.isUser});

  List<TextSpan> _parse(String raw, AppColors c) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int last = 0;
    for (final m in regex.allMatches(raw)) {
      if (m.start > last) {
        spans.add(TextSpan(text: raw.substring(last, m.start)));
      }
      spans.add(
        TextSpan(
          text: m.group(1),
          style: TextStyle(fontWeight: FontWeight.w700, color: c.text),
        ),
      );
      last = m.end;
    }
    if (last < raw.length) spans.add(TextSpan(text: raw.substring(last)));
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: isUser ? const Color(0xFFE2E8F0) : c.text,
          fontSize: 14,
          height: 1.6,
          letterSpacing: 0.1,
        ),
        children: _parse(text, c),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// AppBar
// ─────────────────────────────────────────────
class _CopilotAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return AppBar(
      backgroundColor: c.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: c.muted, size: 18),
        onPressed: () => Navigator.maybePop(context),
      ),
      titleSpacing: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _kTeal.withValues(alpha: 0.12),
              border: Border.all(
                color: _kTeal.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: const Icon(Icons.route_rounded, color: _kTeal, size: 17),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Amrit Sathi',
                style: TextStyle(
                  color: c.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kTeal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'AI Travel Companion · Gemini',
                    style: TextStyle(
                      color: c.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_horiz_rounded, color: c.muted),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: c.border),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Input Bar
// ─────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasText;
  final bool isLoading;
  final Future<void> Function([String?]) onSend;

  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.hasText,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border, width: 1)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 130),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: c.card,
                border: Border.all(color: c.border, width: 1),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                readOnly: isLoading,
                style: TextStyle(
                  color: c.text,
                  fontSize: 14,
                  height: 1.5,
                  letterSpacing: 0.1,
                ),
                cursorColor: _kTeal,
                cursorWidth: 1.5,
                decoration: InputDecoration(
                  hintText: isLoading
                      ? 'Amrit Sathi is thinking…'
                      : 'Ask anything about your trip…',
                  hintStyle: TextStyle(
                    color: c.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  border: InputBorder.none,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: isLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.8,
                                  color: _kTeal,
                                ),
                              ),
                            ),
                          )
                        : Icon(
                            Icons.mic_none_rounded,
                            color: c.muted,
                            size: 18,
                          ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                onSubmitted: isLoading ? null : (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: (hasText && !isLoading)
                ? _SendBtn(onTap: onSend, key: const ValueKey('s'))
                : const SizedBox(width: 0, key: ValueKey('e')),
          ),
        ],
      ),
    );
  }
}

class _SendBtn extends StatefulWidget {
  final Future<void> Function([String?]) onTap;
  const _SendBtn({super.key, required this.onTap});

  @override
  State<_SendBtn> createState() => _SendBtnState();
}

class _SendBtnState extends State<_SendBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onTap(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _hover ? _kTeal.withValues(alpha: 0.85) : _kTeal,
          ),
          child: const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
            size: 19,
          ),
        ),
      ),
    );
  }
}
