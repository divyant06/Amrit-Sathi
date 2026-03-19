import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'story_screen.dart';

// ─────────────────────────────────────────────
// Design tokens
// ─────────────────────────────────────────────
const Color _kBg = Color(0xFF0B1120);
const Color _kSurface = Color(0xFF111827);
const Color _kCard = Color(0xFF161F2E);
const Color _kBorder = Color(0xFF1E2D42);
const Color _kTeal = Color(0xFF14B8A6);
const Color _kRed = Color(0xFFEF4444);
const Color _kMuted = Color(0xFF64748B);
const Color _kText = Color(0xFFE2E8F0);
const Color _kSubtext = Color(0xFF94A3B8);

// ─────────────────────────────────────────────
// Data
// ─────────────────────────────────────────────
class _Friend {
  final String initials;
  final Color color;
  final LatLng position;
  const _Friend(this.initials, this.color, this.position);
}

final _friends = [
  _Friend('RK', const Color(0xFF7C3AED), LatLng(26.9124, 75.7873)), // Jaipur
  _Friend('SM', const Color(0xFFDB2777), LatLng(32.2396, 77.1887)), // Manali
  _Friend('AT', const Color(0xFF0891B2), LatLng(30.0869, 78.2676)), // Rishikesh
];

class _Story {
  final String title;
  final String location;
  final Color accent;
  final IconData icon;
  const _Story(this.title, this.location, this.accent, this.icon);
}

const _stories = [
  _Story(
    'Amer Fort Sunrise',
    'Jaipur',
    Color(0xFFB45309),
    Icons.wb_sunny_outlined,
  ),
  _Story(
    'Pushkar Camel Fair',
    'Pushkar',
    Color(0xFF0F766E),
    Icons.festival_outlined,
  ),
  _Story(
    'Blue City Rooftop',
    'Jodhpur',
    Color(0xFF1D4ED8),
    Icons.roofing_outlined,
  ),
  _Story(
    'Ranthambore Safari',
    'Sawai',
    Color(0xFF065F46),
    Icons.forest_outlined,
  ),
];

class _Hostel {
  final String name;
  final String location;
  final String price;
  final double rating;
  final Color accent;
  const _Hostel(this.name, this.location, this.price, this.rating, this.accent);
}

const _hostels = [
  _Hostel('Zostel Jaipur', '0.3 km away', '₹499/night', 4.7, Color(0xFF14B8A6)),
  _Hostel(
    'Moustache Hostel',
    '0.8 km away',
    '₹649/night',
    4.5,
    Color(0xFF7C3AED),
  ),
  _Hostel('The Hosteller', '1.2 km away', '₹399/night', 4.3, Color(0xFF0891B2)),
];

// ─────────────────────────────────────────────
// Squad member data
// ─────────────────────────────────────────────
class _SquadMember {
  final String initials;
  final String name;
  final Color color;
  const _SquadMember(this.initials, this.name, this.color);
}

const _squadMembers = [
  _SquadMember('RK', 'Rahul K.', Color(0xFF7C3AED)),
  _SquadMember('SM', 'Simran M.', Color(0xFFDB2777)),
  _SquadMember('AT', 'Aryan T.', Color(0xFF0891B2)),
];

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late final AnimationController _sosCtrl;
  late final Animation<double> _sosAnim;
  late final DraggableScrollableController _sheetCtrl;

  void _showSosSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _SosSheet(),
    );
  }

  void _showSquadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _SquadSheet(),
    );
  }

  @override
  void initState() {
    super.initState();
    _sosCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: false);
    _sosAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _sosCtrl, curve: Curves.easeOut));
    _sheetCtrl = DraggableScrollableController();
  }

  @override
  void dispose() {
    _sosCtrl.dispose();
    _sheetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: _kBg,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── 1. MAP BACKGROUND ─────────────────
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(28.6139, 77.2090), // New Delhi
              initialZoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                userAgentPackageName: 'com.example.amrit_sathi',
              ),
              MarkerLayer(
                markers: _friends.map((f) => Marker(
                  point: f.position,
                  width: 50,
                  height: 50,
                  alignment: Alignment.topCenter,
                  child: _FriendPin(friend: f),
                )).toList(),
              ),
            ],
          ),

          // ── 3. BOTTOM SHEET ───────────────────
          _DiscoverySheet(controller: _sheetCtrl),

          // ── 4. TOP HUD ────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: const _HudBar(),
          ),

          // ── 5. SOS BUTTON ─────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 76,
            right: 16,
            child: _SosButton(
              anim: _sosAnim,
              onTap: () => _showSosSheet(context),
            ),
          ),

          // ── 6. MY SQUAD PILL ──────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 72,
            left: 16,
            child: _SquadPill(onTap: () => _showSquadSheet(context)),
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────
// 2 · Friend Avatar Pins
// ─────────────────────────────────────────────
class _FriendPin extends StatelessWidget {
  final _Friend friend;
  const _FriendPin({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: friend.color,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: friend.color.withValues(alpha: 0.55),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              friend.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        // Pointer triangle
        CustomPaint(
          size: const Size(10, 6),
          painter: _PinPointerPainter(friend.color),
        ),
      ],
    );
  }
}

class _PinPointerPainter extends CustomPainter {
  final Color color;
  const _PinPointerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────
// 3 · Discovery Bottom Sheet
// ─────────────────────────────────────────────
class _DiscoverySheet extends StatelessWidget {
  final DraggableScrollableController controller;
  const _DiscoverySheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: 0.28,
      minChildSize: 0.14,
      maxChildSize: 0.80,
      snap: true,
      snapSizes: const [0.14, 0.28, 0.55, 0.80],
      builder: (context, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
              top: BorderSide(color: _kBorder, width: 1),
              left: BorderSide(color: _kBorder, width: 1),
              right: BorderSide(color: _kBorder, width: 1),
            ),
          ),
          child: ListView(
            controller: scrollCtrl,
            padding: EdgeInsets.zero,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _kBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _kTeal.withValues(alpha: 0.12),
                      ),
                      child: const Icon(
                        Icons.explore_outlined,
                        color: _kTeal,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nearby Experiences',
                          style: TextStyle(
                            color: _kText,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          'Updated just now',
                          style: TextStyle(
                            color: _kMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _kTeal.withValues(alpha: 0.1),
                        border: Border.all(
                          color: _kTeal.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: _kTeal,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Section: Story Mode
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 0, 10),
                child: _SectionLabel(
                  icon: Icons.play_circle_outline_rounded,
                  label: 'Story Mode · Reels',
                ),
              ),
              SizedBox(
                height: 128,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  itemCount: _stories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, i) => _StoryCard(story: _stories[i]),
                ),
              ),

              const SizedBox(height: 16),

              // Section: Hostels
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 0, 10),
                child: _SectionLabel(
                  icon: Icons.bed_outlined,
                  label: 'Hostels & Stays',
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                itemCount: _hostels.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _HostelRow(hostel: _hostels[i]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _kMuted),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: _kSubtext,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class _StoryCard extends StatelessWidget {
  final _Story story;
  const _StoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => StoryScreen(initialTitle: story.title),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 280),
        ),
      ),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: story.accent.withValues(alpha: 0.12),
          border: Border.all(
            color: story.accent.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: story.accent.withValues(alpha: 0.18),
                border: Border.all(
                  color: story.accent.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Icon(story.icon, color: story.accent, size: 20),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                story.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _kText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              story.location,
              style: const TextStyle(color: _kMuted, fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _HostelRow extends StatelessWidget {
  final _Hostel hostel;
  const _HostelRow({required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _kCard,
        border: Border.all(color: _kBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: hostel.accent.withValues(alpha: 0.12),
              border: Border.all(
                color: hostel.accent.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(Icons.bed_rounded, color: hostel.accent, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hostel.name,
                  style: const TextStyle(
                    color: _kText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hostel.location,
                  style: const TextStyle(color: _kMuted, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hostel.price,
                style: const TextStyle(
                  color: _kTeal,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF59E0B),
                    size: 12,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    hostel.rating.toString(),
                    style: const TextStyle(color: _kSubtext, fontSize: 11.5),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 4 · HUD Search Bar
// ─────────────────────────────────────────────
class _HudBar extends StatelessWidget {
  const _HudBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search pill
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _kSurface.withValues(alpha: 0.92),
                border: Border.all(color: _kBorder, width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Icons.search_rounded, color: _kMuted, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Search places, hostels, stories…',
                      style: TextStyle(
                        color: _kMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 24, color: _kBorder),
                  // Filter button
                  InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(Icons.tune_rounded, color: _kTeal, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Layer toggle
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _kSurface.withValues(alpha: 0.92),
            border: Border.all(color: _kBorder, width: 1),
          ),
          child: const Icon(Icons.layers_outlined, color: _kSubtext, size: 20),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 5 · SOS Button with pulsing rings
// ─────────────────────────────────────────────
class _SosButton extends StatelessWidget {
  final Animation<double> anim;
  final VoidCallback onTap;
  const _SosButton({required this.anim, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        return SizedBox(
          width: 62,
          height: 62,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Opacity(
                opacity: (1 - anim.value).clamp(0.0, 1.0),
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _kRed.withValues(
                        alpha: (1 - anim.value).clamp(0.0, 0.6),
                      ),
                      width: 2,
                    ),
                  ),
                ),
              ),
              // Mid ring
              Opacity(
                opacity: (1 - ((anim.value - 0.3).clamp(0.0, 1.0))).clamp(
                  0.0,
                  1.0,
                ),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kRed.withValues(
                      alpha: (0.25 * (1 - anim.value)).clamp(0.0, 0.25),
                    ),
                  ),
                ),
              ),
              // Core button
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kRed,
                    boxShadow: [
                      BoxShadow(
                        color: _kRed.withValues(alpha: 0.5),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'SOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// 6 · SOS Emergency Bottom Sheet
// ─────────────────────────────────────────────
class _SosSheet extends StatelessWidget {
  const _SosSheet();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(
          top: BorderSide(color: _kBorder, width: 1),
          left: BorderSide(color: _kBorder, width: 1),
          right: BorderSide(color: _kBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kRed.withValues(alpha: 0.12),
              border: Border.all(
                color: _kRed.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: const Icon(Icons.emergency_rounded, color: _kRed, size: 28),
          ),

          const SizedBox(height: 14),

          // Title
          const Text(
            'Emergency SOS',
            style: TextStyle(
              color: _kRed,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 8),

          // Subtext
          const Text(
            'Broadcast your live offline coordinates to your 3 trusted contacts?',
            textAlign: TextAlign.center,
            style: TextStyle(color: _kSubtext, fontSize: 13.5, height: 1.5),
          ),

          const SizedBox(height: 28),

          // ── Primary: Alert button ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                    content: const Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Simulated: Live location securely broadcasted to 3 trusted contacts.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 4),
                  ),
                );
              },
              icon: const Icon(
                Icons.wifi_tethering_rounded,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Alert Trusted Contacts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Secondary: Find Hospitals / Police ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.local_hospital_outlined,
                color: _kText,
                size: 18,
              ),
              label: const Text(
                'Find Nearby Hospitals / Police',
                style: TextStyle(
                  color: _kText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _kBorder, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: _kText,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // ── Cancel text button ──
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: _kMuted,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 7 · My Squad Pill Button
// ─────────────────────────────────────────────
class _SquadPill extends StatelessWidget {
  final VoidCallback onTap;
  const _SquadPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: _kSurface.withValues(alpha: 0.95),
          border: Border.all(color: _kBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kTeal.withValues(alpha: 0.15),
                border: Border.all(
                  color: _kTeal.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: const Icon(Icons.group_rounded, color: _kTeal, size: 14),
            ),
            const SizedBox(width: 8),
            const Text(
              'My Squad',
              style: TextStyle(
                color: _kText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _kTeal.withValues(alpha: 0.15),
              ),
              child: const Text(
                '3',
                style: TextStyle(
                  color: _kTeal,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 8 · Squad Manager Bottom Sheet
// ─────────────────────────────────────────────
class _SquadSheet extends StatelessWidget {
  const _SquadSheet();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(
          top: BorderSide(color: _kBorder, width: 1),
          left: BorderSide(color: _kBorder, width: 1),
          right: BorderSide(color: _kBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ──
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ──
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _kTeal.withValues(alpha: 0.12),
                  border: Border.all(
                    color: _kTeal.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(Icons.group_rounded, color: _kTeal, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Trip: Delhi Weekend',
                      style: TextStyle(
                        color: _kText,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF22C55E),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '3/4 members connected. Offline sync active.',
                          style: TextStyle(
                            color: _kMuted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Divider ──
          Container(height: 1, color: _kBorder),

          const SizedBox(height: 16),

          // ── Member List ──
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _squadMembers.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _SquadMemberTile(member: _squadMembers[i]),
          ),

          const SizedBox(height: 14),

          // ── Add Friend dashed button ──
          _AddFriendButton(),

          const SizedBox(height: 20),

          // ── Ping Meetup button ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                    content: const Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Simulated: Meetup ping sent to squad.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(
                Icons.near_me_rounded,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Ping Meetup Location to Squad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kTeal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Squad member tile
// ─────────────────────────────────────────────
class _SquadMemberTile extends StatelessWidget {
  final _SquadMember member;
  const _SquadMemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: member.color,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: member.color.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              member.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Name + status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                style: const TextStyle(
                  color: _kText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Location Synced just now',
                style: TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Online indicator
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF22C55E),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Add Friend dashed button
// ─────────────────────────────────────────────
class _AddFriendButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add_outlined, color: _kMuted, size: 18),
              SizedBox(width: 8),
              Text(
                'Add Friend to Squad',
                style: TextStyle(
                  color: _kSubtext,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    final paint = Paint()
      ..color = _kBorder
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    const radius = 12.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(radius),
    );
    final path = Path()..addRRect(rect);
    final metric = path.computeMetrics().first;
    double distance = 0;
    while (distance < metric.length) {
      final end = (distance + dashWidth).clamp(0, metric.length);
      canvas.drawPath(metric.extractPath(distance, end as double), paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
