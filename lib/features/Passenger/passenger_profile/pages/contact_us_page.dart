import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Contact BookMyBus'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need a Hand? Let\'s Talk.',
              style: tt.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'We\'d love to hear from you. Whether you have a question, want to share feedback, or need support with your bus operations, reach out using any of the options below. We aim to respond as quickly and clearly as possible.',
              style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Ways to Reach Us',
              style: tt.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ContactCard(
              icon: Icons.phone_outlined,
              title: 'Call Us',
              lines: const [
                '+94 76 764 6190 | +94 77 123 4567',
                'Monday – Friday, 9:00 AM – 6:00 PM',
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _ContactCard(
              icon: Icons.mail_outline,
              title: 'Mail Us',
              lines: const [
                'info@bookmybus.lk',
                'We usually respond within 24–48 hours.',
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _ContactCard(
              icon: Icons.location_on_outlined,
              title: 'Visit Us',
              lines: const [
                'Colombo, Sri Lanka',
                'Visits by appointment only.',
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Your feedback helps us make BookMyBus better for passengers, staff, and bus owners. Thank you for taking the time to reach out and stay connected with us.',
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> lines;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.section,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                ...lines.map(
                  (line) => Text(
                    line,
                    style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
