import 'package:flutter/material.dart';
import '../app_theme.dart';

// ─────────────────────────────────────────────
// Accent colour (shared with rest of app)
// ─────────────────────────────────────────────
const Color _kTeal = Color(0xFF14B8A6);

// ─────────────────────────────────────────────
// Settings Screen
// ─────────────────────────────────────────────
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: c.subtext, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: c.text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: c.border),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ─────────────────────────────────────
          // Section: Preferences
          // ─────────────────────────────────────
          _SectionHeader(label: 'Preferences', c: c),

          _SettingsTile(
            icon: Icons.manage_accounts_outlined,
            iconColor: const Color(0xFF3B82F6),
            title: 'Account Details',
            subtitle: 'Edit your name, photo and travel bio',
            c: c,
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.people_alt_outlined,
            iconColor: const Color(0xFFEF4444),
            title: 'Manage Trusted Contacts',
            subtitle: 'Up to 3 contacts for SOS broadcasts',
            c: c,
            badge: 'SOS',
            badgeColor: const Color(0xFFEF4444),
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: 'Notifications',
            subtitle: 'Manage alerts and travel reminders',
            c: c,
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF0891B2),
            title: 'Language & Region',
            subtitle: 'English (India)',
            c: c,
            onTap: () {},
          ),

          const SizedBox(height: 8),

          // ─────────────────────────────────────
          // Section: About Amrit Sarovar
          // ─────────────────────────────────────
          _SectionHeader(label: 'About Amrit Sarovar', c: c),

          // Mission statement card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: c.card,
                border: Border.all(color: c.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo mark + name
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _kTeal.withValues(alpha: 0.12),
                          border: Border.all(
                              color: _kTeal.withValues(alpha: 0.3), width: 1),
                        ),
                        child: const Icon(Icons.route_rounded,
                            color: _kTeal, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amrit Sarovar',
                            style: TextStyle(
                              color: c.text,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            'Travel · Community · Purpose',
                            style: TextStyle(
                              color: c.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Divider(height: 1, color: c.border),
                  ),

                  // Mission paragraph
                  Text(
                    'Our Mission',
                    style: TextStyle(
                      color: _kTeal,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A holistic travel and local impact ecosystem designed to redefine domestic travel by merging budget-conscious trip planning with purpose-driven tourism.',
                    style: TextStyle(
                      color: c.subtext,
                      fontSize: 14,
                      height: 1.65,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),

          _SettingsTile(
            icon: Icons.star_outline_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: 'Rate the App',
            subtitle: 'Share your feedback on the Play Store',
            c: c,
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF6D28D9),
            title: 'Privacy Policy',
            subtitle: 'Read how we protect your data',
            c: c,
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.description_outlined,
            iconColor: c.muted,
            title: 'Terms of Service',
            subtitle: 'Review our terms and conditions',
            c: c,
            onTap: () {},
          ),

          const SizedBox(height: 32),

          // Version footer
          Center(
            child: Text(
              'Version 1.0.0 MVP',
              style: TextStyle(
                color: c.muted,
                fontSize: 12,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final AppColors c;
  const _SectionHeader({required this.label, required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: c.muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Settings Tile
// ─────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final AppColors c;
  final VoidCallback onTap;
  final String? badge;
  final Color? badgeColor;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.c,
    required this.onTap,
    this.badge,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Material(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border, width: 1),
            ),
            child: Row(
              children: [
                // Icon badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: iconColor.withValues(alpha: 0.12),
                    border: Border.all(
                        color: iconColor.withValues(alpha: 0.25), width: 1),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 12),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: c.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: (badgeColor ?? iconColor)
                                    .withValues(alpha: 0.12),
                                border: Border.all(
                                  color: (badgeColor ?? iconColor)
                                      .withValues(alpha: 0.35),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                badge!,
                                style: TextStyle(
                                  color: badgeColor ?? iconColor,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: c.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron
                Icon(Icons.chevron_right_rounded, color: c.muted, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
