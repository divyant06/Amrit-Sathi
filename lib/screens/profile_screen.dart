import 'dart:ui';
import 'package:flutter/material.dart';

import 'settings_screen.dart';

// ─────────────────────────────────────────────
// Design tokens
// ─────────────────────────────────────────────
const Color _kBg        = Color(0xFF0B1120); // flat dark canvas
const Color _kAccentGold = Color(0xFFF4C430);
const Color _kAccentTeal = Color(0xFF2EC4B6);
const Color _kAccentBlue = Color(0xFF4361EE);

// ─────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────
class _Badge {
  final String title;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final String backstory;
  const _Badge(this.title, this.icon, this.color,
      {this.unlocked = true, this.backstory = ''});
}

class _SavedPlace {
  final String name;
  final String country;
  final String date;
  final IconData icon;
  const _SavedPlace(this.name, this.country, this.date, this.icon);
}

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final double _xpProgress = 0.72;

  late final AnimationController _xpCtrl;
  late final Animation<double> _xpAnim;

  final int _countries = 34;
  final int _cities = 127;
  final int _bucketListCount = 58;

  final List<_Badge> _badges = const [
    _Badge(
      'Mountain Goat',
      Icons.terrain,
      Color(0xFF43AA8B),
      unlocked: true,
      backstory:
          'Awarded for surviving the brutal altitudes of Leh-Ladakh at 18,380 ft — where every breath is a victory and every step an achievement.',
    ),
    _Badge(
      'Temple Hopper',
      Icons.account_balance,
      Color(0xFFF9844A),
      unlocked: true,
      backstory:
          'Earned by visiting 40+ ancient temples across India, absorbing centuries of architecture, mythology, and divine silence.',
    ),
    _Badge(
      'Food Nomad',
      Icons.restaurant,
      Color(0xFFE63946),
      unlocked: true,
      backstory:
          'Granted to those who dare to eat from the most obscure roadside stalls — from Varanasi\'s kachori to Kolkata\'s jhal muri at midnight.',
    ),
    _Badge(
      'Deep Diver',
      Icons.scuba_diving,
      Color(0xFF4361EE),
      unlocked: false,
      backstory:
          'Yet to be unlocked. Dive 20m below the surface in the Andaman Sea to earn this coveted badge. The ocean waits.',
    ),
    _Badge(
      'Night Owl',
      Icons.nightlight_round,
      Color(0xFF7B2D8B),
      unlocked: false,
      backstory:
          'Reserved for explorers who witness 30 sunrises from mountain peaks. Three more left and it\'s yours.',
    ),
    _Badge(
      'Solo Trekker',
      Icons.hiking,
      Color(0xFF2EC4B6),
      unlocked: false,
      backstory:
          'Complete a 7-day solo trek across the Himalayan wilderness — no guides, no groups. Pure solitude. Pure you.',
    ),
  ];

  final List<_SavedPlace> _places = const [
    _SavedPlace('Santorini',    'Greece', 'Mar 2026', Icons.wb_sunny_outlined),
    _SavedPlace('Kyoto',        'Japan',  'Jun 2026', Icons.temple_buddhist_outlined),
    _SavedPlace('Machu Picchu', 'Peru',   'Sep 2026', Icons.landscape_outlined),
    _SavedPlace('Banff',        'Canada', 'Dec 2026', Icons.ac_unit_outlined),
    _SavedPlace('Amalfi Coast', 'Italy',  'Apr 2027', Icons.directions_boat_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _xpCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _xpAnim = CurvedAnimation(parent: _xpCtrl, curve: Curves.easeOutCubic);
    _xpCtrl.forward();
  }

  @override
  void dispose() {
    _xpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Flat dark canvas — glass cards will contrast beautifully against it
      backgroundColor: _kBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: BackButton(color: Colors.white70),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white70),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ─── Header Card ──────────────────
                  _GlassCard(
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [_kAccentTeal, _kAccentBlue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _kAccentTeal.withValues(alpha: 0.50),
                                blurRadius: 30, spreadRadius: 4,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 2.5,
                            ),
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.person, size: 54, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Alex Explorer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [_kAccentGold, Color(0xFFF9844A)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _kAccentGold.withValues(alpha: 0.35),
                                blurRadius: 12, offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            '🧭  Level 5 Backpacker',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _XpProgressBar(animation: _xpAnim, progress: _xpProgress),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── Travel Stats ─────────────────
                  Row(
                    children: [
                      _StatCard(value: _countries, label: 'Countries', icon: Icons.public, color: _kAccentBlue),
                      const SizedBox(width: 12),
                      _StatCard(value: _cities, label: 'Cities', icon: Icons.location_city, color: _kAccentTeal),
                      const SizedBox(width: 12),
                      _StatCard(value: _bucketListCount, label: 'Bucket List', icon: Icons.bookmark_rounded, color: _kAccentGold),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ─── Trophies ─────────────────────
                  _SectionTitle(
                    title: 'My Trophies',
                    subtitle: '${_badges.where((b) => b.unlocked).length}/${_badges.length} earned',
                  ),
                  const SizedBox(height: 14),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.90,
                    ),
                    itemCount: _badges.length,
                    itemBuilder: (context, i) => _BadgeTile(badge: _badges[i]),
                  ),

                  const SizedBox(height: 28),

                  // ─── Saved Places ─────────────────
                  const _SectionTitle(title: 'Saved Places', subtitle: 'Bucket List'),
                  const SizedBox(height: 14),

                  ..._places.map((p) => _PlaceListTile(place: p)),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Glass Card — premium frosted panel
// ─────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            // True premium frosted glass — barely-there tint
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 40,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// XP Progress Bar
// ─────────────────────────────────────────────
class _XpProgressBar extends StatelessWidget {
  final Animation<double> animation;
  final double progress;
  const _XpProgressBar({required this.animation, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'XP to Level 6',
              style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(color: _kAccentGold, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: animation.value * progress,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [_kAccentGold, Color(0xFFF9844A)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _kAccentGold.withValues(alpha: 0.65),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            '3,600 / 5,000 XP',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 11),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Stat Card — glass + press-pop
// ─────────────────────────────────────────────
class _StatCard extends StatefulWidget {
  final int value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatCard({required this.value, required this.label, required this.icon, required this.color});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withValues(alpha: _isPressed ? 0.08 : 0.05),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: _isPressed ? 0.18 : 0.10),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: _isPressed ? 0.40 : 0.18),
                      blurRadius: _isPressed ? 28 : 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(widget.icon, color: widget.color, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.value}',
                      style: TextStyle(color: widget.color, fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11.5, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section Title
// ─────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 4, height: 22,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [_kAccentTeal, _kAccentBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: 0.3)),
        const Spacer(),
        Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.50), fontSize: 12)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Badge Tile — taps open a Mega-Pop dialog
// ─────────────────────────────────────────────
class _BadgeTile extends StatefulWidget {
  final _Badge badge;
  const _BadgeTile({required this.badge});

  @override
  State<_BadgeTile> createState() => _BadgeTileState();
}

class _BadgeTileState extends State<_BadgeTile> {
  bool _isPressed = false;

  void _showMegaPop(BuildContext context) {
    final b = widget.badge;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Badge',
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (pbCtx, pbAnim, pbSecAnim) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, secAnim, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Opacity(
              opacity: anim.value.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: value,
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: () => Navigator.of(ctx).pop(),
            behavior: HitTestBehavior.opaque,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: GestureDetector(
                  // Prevent taps inside from closing
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color: b.unlocked
                                  ? b.color.withValues(alpha: 0.40)
                                  : Colors.white.withValues(alpha: 0.12),
                              width: 1.5,
                            ),
                            boxShadow: b.unlocked
                                ? [
                                    BoxShadow(
                                      color: b.color.withValues(alpha: 0.55),
                                      blurRadius: 60,
                                      spreadRadius: 4,
                                    ),
                                    BoxShadow(
                                      color: b.color.withValues(alpha: 0.20),
                                      blurRadius: 120,
                                      spreadRadius: 10,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.6),
                                      blurRadius: 40,
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Hero badge icon
                              b.unlocked
                                  ? _MegaBadgeIcon(icon: b.icon, color: b.color)
                                  : ColorFiltered(
                                      colorFilter: const ColorFilter.matrix([
                                        0.2126, 0.7152, 0.0722, 0, 0,
                                        0.2126, 0.7152, 0.0722, 0, 0,
                                        0.2126, 0.7152, 0.0722, 0, 0,
                                        0,      0,      0,      1, 0,
                                      ]),
                                      child: _MegaBadgeIcon(icon: b.icon, color: b.color),
                                    ),

                              const SizedBox(height: 20),

                              // Badge name
                              Text(
                                b.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: b.unlocked ? b.color : Colors.white54,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),

                              // Locked indicator
                              if (!b.unlocked) ...[
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.lock_outline, size: 13, color: Colors.white38),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Locked',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],

                              const SizedBox(height: 16),

                              // Divider
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withValues(alpha: 0.15),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // AI backstory
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 14,
                                    color: _kAccentGold.withValues(alpha: 0.8),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      b.backstory,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.70),
                                        fontSize: 13.5,
                                        height: 1.55,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Dismiss hint
                              Text(
                                'Tap outside to close',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.badge;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _showMegaPop(context);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // Premium dark-glass treatment
                color: Colors.white.withValues(alpha: _isPressed ? 0.09 : 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: _isPressed ? 0.18 : 0.10),
                  width: 1.2,
                ),
                boxShadow: b.unlocked
                    ? [
                        BoxShadow(
                          color: b.color.withValues(alpha: _isPressed ? 0.50 : 0.20),
                          blurRadius: _isPressed ? 28 : 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  b.unlocked
                      ? _BadgeIcon(icon: b.icon, color: b.color)
                      : ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0,      0,      0,      1, 0,
                          ]),
                          child: _BadgeIcon(icon: b.icon, color: b.color),
                        ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      b.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        color: b.unlocked
                            ? Colors.white.withValues(alpha: 0.92)
                            : Colors.white.withValues(alpha: 0.35),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (!b.unlocked) ...[
                    const SizedBox(height: 4),
                    const Icon(Icons.lock_outline, size: 12, color: Colors.white24),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Small badge icon used in the grid tile
class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _BadgeIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52, height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0.05)],
        ),
        border: Border.all(color: color.withValues(alpha: 0.40), width: 1.2),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.20), blurRadius: 10)],
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }
}

// Large badge icon used inside the Mega-Pop dialog
class _MegaBadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _MegaBadgeIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.40), color.withValues(alpha: 0.03)],
          radius: 0.8,
        ),
        border: Border.all(color: color.withValues(alpha: 0.55), width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 40, spreadRadius: 4),
          BoxShadow(color: color.withValues(alpha: 0.20), blurRadius: 80, spreadRadius: 10),
        ],
      ),
      child: Icon(icon, color: color, size: 60),
    );
  }
}

// ─────────────────────────────────────────────
// Place List Tile
// ─────────────────────────────────────────────
class _PlaceListTile extends StatelessWidget {
  final _SavedPlace place;
  const _PlaceListTile({required this.place});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10), width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.30), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [_kAccentTeal.withValues(alpha: 0.30), _kAccentBlue.withValues(alpha: 0.15)],
                  ),
                  border: Border.all(color: _kAccentTeal.withValues(alpha: 0.40), width: 1),
                ),
                child: Icon(place.icon, color: _kAccentTeal, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(place.country, style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12.5)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _kAccentGold.withValues(alpha: 0.10),
                  border: Border.all(color: _kAccentGold.withValues(alpha: 0.30)),
                ),
                child: Text(place.date, style: const TextStyle(color: _kAccentGold, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }
}
