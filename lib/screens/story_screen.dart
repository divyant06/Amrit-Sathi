import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
// Story data
// ─────────────────────────────────────────────
class _StoryData {
  final String title;
  final String location;
  final String description;
  final List<Color> gradientColors;
  final List<_Waypoint> waypoints;

  const _StoryData({
    required this.title,
    required this.location,
    required this.description,
    required this.gradientColors,
    required this.waypoints,
  });
}

class _Waypoint {
  final double top;
  final double left;
  final Color color;
  const _Waypoint(this.top, this.left, this.color);
}

// Hardcoded reel deck — first item is overridden by [initialTitle]
final _kStories = [
  _StoryData(
    title: 'Amer Fort Sunrise',
    location: 'Jaipur, Rajasthan',
    description:
        'Watch the golden hour paint the ramparts of Amer Fort. Best spot: eastern gallery, 6 AM.',
    gradientColors: const [Color(0xFF1A0A00), Color(0xFF3B1F06), Color(0xFF7B3F00)],
    waypoints: [
      _Waypoint(0.28, 0.60, Color(0xFFB45309)),
      _Waypoint(0.55, 0.30, Color(0xFFF59E0B)),
      _Waypoint(0.72, 0.70, Color(0xFFD97706)),
    ],
  ),
  _StoryData(
    title: 'Goa Sunsets',
    location: 'Calangute Beach, Goa',
    description:
        'Shack-hop along Calangute as the Arabian Sea turns molten gold. Feni optional.',
    gradientColors: const [Color(0xFF0D0522), Color(0xFF3B1078), Color(0xFF8B3DFF)],
    waypoints: [
      _Waypoint(0.22, 0.45, Color(0xFF7C3AED)),
      _Waypoint(0.50, 0.70, Color(0xFFDB2777)),
      _Waypoint(0.68, 0.20, Color(0xFF6D28D9)),
    ],
  ),
  _StoryData(
    title: 'Pushkar Camel Fair',
    location: 'Pushkar, Rajasthan',
    description:
        "Thousands of camels, folk dancers, and the world's only Brahma temple -- all in one dusty oasis.",
    gradientColors: const [Color(0xFF001A0D), Color(0xFF004D26), Color(0xFF006B35)],
    waypoints: [
      _Waypoint(0.30, 0.55, Color(0xFF059669)),
      _Waypoint(0.58, 0.25, Color(0xFF10B981)),
      _Waypoint(0.75, 0.65, Color(0xFF34D399)),
    ],
  ),
  _StoryData(
    title: 'Blue City Rooftop',
    location: 'Jodhpur, Rajasthan',
    description:
        'Sip chai above a sea of indigo and cobalt. Every rooftop café has a front-row view of Mehrangarh.',
    gradientColors: const [Color(0xFF000D1A), Color(0xFF003166), Color(0xFF1D4ED8)],
    waypoints: [
      _Waypoint(0.25, 0.60, Color(0xFF2563EB)),
      _Waypoint(0.52, 0.30, Color(0xFF3B82F6)),
      _Waypoint(0.70, 0.68, Color(0xFF60A5FA)),
    ],
  ),
];

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────
class StoryScreen extends StatefulWidget {
  final String initialTitle;
  const StoryScreen({super.key, required this.initialTitle});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late final PageController _pageCtrl;
  late final List<_StoryData> _stories;
  int _currentPage = 0;

  // Per-story liked/bookmarked state
  late final List<bool> _liked;
  late final List<bool> _bookmarked;

  @override
  void initState() {
    super.initState();

    // Build story deck: find matching title for first slot, else prepend a
    // synthetic entry based on the passed title.
    final matchIdx =
        _kStories.indexWhere((s) => s.title == widget.initialTitle);
    if (matchIdx >= 0) {
      // Rotate so the tapped story appears first
      _stories = [
        ..._kStories.sublist(matchIdx),
        ..._kStories.sublist(0, matchIdx),
      ];
    } else {
      _stories = [
        _StoryData(
          title: widget.initialTitle,
          location: 'India',
          description: 'Explore this incredible destination at your own pace.',
          gradientColors: const [
            Color(0xFF0F1923),
            Color(0xFF1A2B3C),
            Color(0xFF14B8A6),
          ],
          waypoints: [
            const _Waypoint(0.35, 0.55, Color(0xFF14B8A6)),
            const _Waypoint(0.60, 0.30, Color(0xFF0891B2)),
          ],
        ),
        ..._kStories,
      ];
    }

    _liked = List.filled(_stories.length, false);
    _bookmarked = List.filled(_stories.length, false);
    _pageCtrl = PageController();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleLike(int i) => setState(() => _liked[i] = !_liked[i]);
  void _toggleBookmark(int i) =>
      setState(() => _bookmarked[i] = !_bookmarked[i]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageCtrl,
        scrollDirection: Axis.vertical,
        itemCount: _stories.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (context, i) {
          final story = _stories[i];
          return _StoryPage(
            story: story,
            pageIndex: i,
            totalPages: _stories.length,
            liked: _liked[i],
            bookmarked: _bookmarked[i],
            onLike: () => _toggleLike(i),
            onBookmark: () => _toggleBookmark(i),
            isActive: i == _currentPage,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Single Story Page
// ─────────────────────────────────────────────
class _StoryPage extends StatefulWidget {
  final _StoryData story;
  final int pageIndex;
  final int totalPages;
  final bool liked;
  final bool bookmarked;
  final VoidCallback onLike;
  final VoidCallback onBookmark;
  final bool isActive;

  const _StoryPage({
    required this.story,
    required this.pageIndex,
    required this.totalPages,
    required this.liked,
    required this.bookmarked,
    required this.onLike,
    required this.onBookmark,
    required this.isActive,
  });

  @override
  State<_StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<_StoryPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimCtrl;

  @override
  void initState() {
    super.initState();
    _shimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── 1. Simulated video background ──
        _SimulatedVideo(story: widget.story, anim: _shimCtrl),

        // ── 2. Bottom gradient scrim ──
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.45, 1.0],
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
        ),

        // ── 3. Progress bars (top) ──
        Positioned(
          top: top + 12,
          left: 52,
          right: 16,
          child: Row(
            children: List.generate(widget.totalPages, (i) {
              final fill = i < widget.pageIndex
                  ? 1.0
                  : i == widget.pageIndex
                      ? 1.0
                      : 0.0;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: fill,
                      minHeight: 2.5,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // ── 4. Back button (top-left) ──
        Positioned(
          top: top + 6,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),

        // ── 5. Bottom-left: Title / description / CTA ──
        Positioned(
          bottom: bottom + 24,
          left: 16,
          right: 80,
          child: _BottomInfo(story: widget.story),
        ),

        // ── 6. Bottom-right: Action icons ──
        Positioned(
          bottom: bottom + 24,
          right: 12,
          child: _ActionColumn(
            size: size,
            liked: widget.liked,
            bookmarked: widget.bookmarked,
            onLike: widget.onLike,
            onBookmark: widget.onBookmark,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Simulated Video Background
// ─────────────────────────────────────────────
class _SimulatedVideo extends StatelessWidget {
  final _StoryData story;
  final Animation<double> anim;
  const _SimulatedVideo({required this.story, required this.anim});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: anim,
      builder: (_, _) => CustomPaint(
        size: size,
        painter: _VideoPainter(story: story, progress: anim.value),
      ),
    );
  }
}

class _VideoPainter extends CustomPainter {
  final _StoryData story;
  final double progress;
  const _VideoPainter({required this.story, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: story.gradientColors,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Animated noise/grain — subtle circles drifting
    final rng = math.Random(42);
    for (int i = 0; i < 18; i++) {
      final dx = rng.nextDouble() * size.width;
      final dy = rng.nextDouble() * size.height;
      final r = 18 + rng.nextDouble() * 80;
      final phase = (i / 18 + progress * 0.4) % 1.0;
      final alpha = (math.sin(phase * math.pi) * 0.12).clamp(0.0, 0.12);
      canvas.drawCircle(
        Offset(dx + math.sin(progress * math.pi * 2 + i) * 14, dy),
        r,
        Paint()
          ..color = story.gradientColors.last.withValues(alpha: alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
      );
    }

    // Grid of subtly lit street lines — feels like aerial city footage
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 45) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    for (double x = 0; x < size.width; x += 45) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Glowing waypoints (location pins on the "map")
    for (final wp in story.waypoints) {
      final cx = size.width * wp.left;
      final cy = size.height * wp.top;
      final pulse = math.sin(progress * math.pi * 2) * 0.5 + 0.5;

      canvas.drawCircle(
        Offset(cx, cy),
        22 + pulse * 6,
        Paint()
          ..color = wp.color.withValues(alpha: 0.12 + pulse * 0.06)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
      );
      canvas.drawCircle(
        Offset(cx, cy),
        8,
        Paint()..color = wp.color.withValues(alpha: 0.7 + pulse * 0.3),
      );
      canvas.drawCircle(
        Offset(cx, cy),
        8,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(_VideoPainter old) =>
      old.progress != progress || old.story != story;
}

// ─────────────────────────────────────────────
// Bottom-left info overlay
// ─────────────────────────────────────────────
class _BottomInfo extends StatelessWidget {
  final _StoryData story;
  const _BottomInfo({required this.story});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Location pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withValues(alpha: 0.15),
            border:
                Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on_rounded,
                  color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Text(
                story.location,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Title
        Text(
          story.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: -0.3,
            shadows: [
              Shadow(color: Colors.black54, blurRadius: 12),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          story.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
            height: 1.45,
            shadows: const [Shadow(color: Colors.black45, blurRadius: 8)],
          ),
        ),
        const SizedBox(height: 16),

        // View on Map CTA
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFF14B8A6),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF14B8A6).withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map_rounded, color: Colors.white, size: 15),
                SizedBox(width: 6),
                Text(
                  'View on Map',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Right-side action column
// ─────────────────────────────────────────────
class _ActionColumn extends StatelessWidget {
  final Size size;
  final bool liked;
  final bool bookmarked;
  final VoidCallback onLike;
  final VoidCallback onBookmark;
  const _ActionColumn({
    required this.size,
    required this.liked,
    required this.bookmarked,
    required this.onLike,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionBtn(
          icon: liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label: liked ? '1.2K' : '1.1K',
          color: liked ? const Color(0xFFEF4444) : Colors.white,
          onTap: onLike,
        ),
        const SizedBox(height: 20),
        _ActionBtn(
          icon: Icons.chat_bubble_outline_rounded,
          label: '84',
          color: Colors.white,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        _ActionBtn(
          icon: Icons.share_rounded,
          label: 'Share',
          color: Colors.white,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        _ActionBtn(
          icon: bookmarked
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          label: 'Save',
          color: bookmarked ? const Color(0xFFF4C430) : Colors.white,
          onTap: onBookmark,
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 30,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 8)]),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
            ),
          ),
        ],
      ),
    );
  }
}
