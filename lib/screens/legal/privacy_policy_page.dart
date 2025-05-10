import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.privacyPolicy), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App name and intro
            Center(
              child: Text(
                'Zakrni – ذكرني',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Introduction paragraph
            Text(
              appLocalizations.privacyPolicyIntro,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // Data Collection
            _buildSectionTitle(context, appLocalizations.dataCollection),
            const SizedBox(height: 8),
            _buildBulletPoint(context, appLocalizations.noPersonalInfo),
            const SizedBox(height: 4),
            _buildBulletPoint(context, appLocalizations.noLogin),
            const SizedBox(height: 16),

            // Data Usage
            _buildSectionTitle(context, appLocalizations.dataUsage),
            const SizedBox(height: 8),
            _buildBulletPoint(context, appLocalizations.noDataStorage),
            const SizedBox(height: 4),
            _buildBulletPoint(context, appLocalizations.apiUsage),
            const SizedBox(height: 16),

            // Data Sharing
            _buildSectionTitle(context, appLocalizations.dataSharing),
            const SizedBox(height: 8),
            _buildBulletPoint(context, appLocalizations.noDataSharing),
            const SizedBox(height: 16),

            // Advertisements
            _buildSectionTitle(context, appLocalizations.advertisements),
            const SizedBox(height: 8),
            _buildBulletPoint(context, appLocalizations.noAds),
            const SizedBox(height: 16),

            // Security
            _buildSectionTitle(context, appLocalizations.security),
            const SizedBox(height: 8),
            _buildBulletPoint(context, appLocalizations.noDataProtection),
            const SizedBox(height: 4),
            _buildBulletPoint(context, appLocalizations.apiConnection),
            const SizedBox(height: 16),

            // Updates
            _buildSectionTitle(context, appLocalizations.updates),
            const SizedBox(height: 8),
            _buildBulletPoint(context, appLocalizations.policyUpdates),
            const SizedBox(height: 16),

            // Contact Us
            _buildSectionTitle(context, appLocalizations.contactUs),
            const SizedBox(height: 8),
            Text(
              appLocalizations.contactIntro,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'mohamedashraffathyoffical@gmail.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•  ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
