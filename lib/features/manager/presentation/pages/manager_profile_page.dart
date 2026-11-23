import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/data/auth_service.dart';

class ManagerProfilePage extends StatefulWidget {
  const ManagerProfilePage({super.key});

  @override
  State<ManagerProfilePage> createState() => _ManagerProfilePageState();
}

class _ManagerProfilePageState extends State<ManagerProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _salonNameController;

  bool _isEditing = false;
  bool _queueArrivalAlerts = true;
  bool _walkinNotifications = true;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    _nameController = TextEditingController(text: user?.name ?? 'Dharmi Lunagariya');
    _emailController = TextEditingController(text: user?.email ?? 'dharmi@goqueue.com');
    _phoneController = TextEditingController(text: '+1 (555) 789-0123');
    _salonNameController = TextEditingController(text: 'Luxe Cut Studio');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _salonNameController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    AuthService.instance.logout();
    NavigationService.pushNamedAndRemoveUntil(
      RouteNames.login,
      (route) => false,
    );
  }

  void _saveProfile() {
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Manager profile updated successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _nameController.text.trim();
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'M';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _emailController.text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.softPink,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.storefront_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            _salonNameController.text,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Manager Information
              _SectionCard(
                title: 'Manager & Salon Information',
                trailing: TextButton(
                  onPressed: () {
                    if (_isEditing) {
                      _saveProfile();
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
                  child: Text(_isEditing ? 'Save' : 'Edit'),
                ),
                children: [
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Manager Name',
                    controller: _nameController,
                    enabled: _isEditing,
                  ),
                  const Divider(height: 24, color: AppColors.divider),
                  _InfoRow(
                    icon: Icons.storefront_outlined,
                    label: 'Assigned Salon',
                    controller: _salonNameController,
                    enabled: _isEditing,
                  ),
                  const Divider(height: 24, color: AppColors.divider),
                  _InfoRow(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email Address',
                    controller: _emailController,
                    enabled: _isEditing,
                  ),
                  const Divider(height: 24, color: AppColors.divider),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Contact Phone',
                    controller: _phoneController,
                    enabled: _isEditing,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Operational Preferences
              _SectionCard(
                title: 'Queue & Floor Notifications',
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Customer Arrival Sound'),
                    subtitle: const Text('Chime alert when customer joins live queue'),
                    value: _queueArrivalAlerts,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) => setState(() => _queueArrivalAlerts = val),
                  ),
                  const Divider(height: 12, color: AppColors.divider),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Walk-in Reminders'),
                    subtitle: const Text('Prompt staff when wait time exceeds 20 minutes'),
                    value: _walkinNotifications,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) => setState(() => _walkinNotifications = val),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Logout Button
              AppButton(
                text: 'Log Out',
                backgroundColor: Colors.red.shade700,
                onPressed: _handleLogout,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.controller,
    required this.enabled,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.softPink,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              enabled
                  ? TextField(
                      controller: controller,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    )
                  : Text(
                      controller.text,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
