import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/passenger_profile/widgets/profile_header.dart';
import 'package:bookmybus/features/Passenger/passenger_profile/widgets/profile_help_support.dart';
import 'package:bookmybus/features/Passenger/passenger_profile/widgets/profile_information_card.dart';
import 'package:bookmybus/features/Passenger/passenger_profile/widgets/update_profile_button.dart';
import 'package:bookmybus/features/Passenger/passenger_profile/widgets/wallet_balance_card.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class PassengerProfilePage extends StatefulWidget {
  const PassengerProfilePage({super.key});

  @override
  State<PassengerProfilePage> createState() => _PassengerProfilePageState();
}

class _PassengerProfilePageState extends State<PassengerProfilePage> {
  final _firstNameController = TextEditingController(text: 'Test');
  final _lastNameController = TextEditingController(text: 'Booking');
  final _nicController = TextEditingController(text: '123456789V');
  final _emailController = TextEditingController(text: 'john.doe@example.com');

  bool _isLoading = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onUpdateProfile() async {
    setState(() {
      _isLoading = true;
      _showSuccess = false;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _showSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            const SizedBox(height: AppSpacing.xl),
            ProfileInformationCard(
              phoneNumber: '+94701002770',
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              nicController: _nicController,
              emailController: _emailController,
            ),
            const SizedBox(height: AppSpacing.lg),
            WalletBalanceCard(balance: 0.00),
            const SizedBox(height: AppSpacing.xl),
            if (_showSuccess) ...[
              _SuccessBanner(),
              const SizedBox(height: AppSpacing.md),
            ],
            UpdateProfileButton(
              onPressed: _onUpdateProfile,
              isLoading: _isLoading,
            ),
            const SizedBox(height: AppSpacing.xl),
            const ProfileHelpSupport(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'All changes saved',
            style: tt.bodyMedium?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
