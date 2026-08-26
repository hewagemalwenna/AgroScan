import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:flutter/material.dart';

class ResponsibleAdviceScreen extends StatelessWidget {
  const ResponsibleAdviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroScanTheme.background,
      appBar: AppBar(
        title: const Text('Responsible Advice'),
        backgroundColor: AgroScanTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            const AgroHeroChip(
              label: 'Important',
              value: 'Guidance, Not Diagnosis',
              icon: Icons.verified_user_outlined,
            ),
            const SizedBox(height: 20),
            Text(
              'AgroScan helps you spot possible potato leaf problems quickly. '
              'It is an advisory tool — always confirm serious or uncertain '
              'results with a qualified professional.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            const AgroSectionTitle('What AgroScan Is'),
            const SizedBox(height: 12),
            const AgroDetailCard(
              title: 'Advisory Tool',
              body: 'Scan results suggest a possible problem class based on '
                  'patterns in training photos. They are not a certified '
                  'diagnosis or laboratory test.',
              icon: Icons.info_outline_rounded,
            ),
            const AgroDetailCard(
              title: 'Potato Leaves Only',
              body: 'The model was trained on potato leaf images. Scanning '
                  'other crops or objects may return incorrect labels.',
              icon: Icons.grass_outlined,
            ),
            const AgroDetailCard(
              title: 'On-Device Analysis',
              body: 'Leaf photos are processed on your phone. Account details '
                  'and crop logs are stored using Firebase when you sign in.',
              icon: Icons.phone_android_outlined,
            ),
            const SizedBox(height: 12),
            const AgroSectionTitle('Model Limitations'),
            const SizedBox(height: 8),
            Text(
              'Based on test-set evaluation of the current model (~69% accuracy).',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            const AgroDetailCard(
              title: 'Overall Accuracy',
              body: 'About 69% of test images were classified correctly. '
                  'Roughly 1 in 3 scans may be wrong — treat low-confidence '
                  'results as uncertain.',
              icon: Icons.analytics_outlined,
            ),
            const AgroDetailCard(
              title: 'Easily Confused Classes',
              body: 'Fungi and Pest, Healthy and diseased leaves, and Virus '
                  'versus pest damage are often mixed up. Rescan with a '
                  'clearer photo if results seem wrong.',
              icon: Icons.swap_horiz_rounded,
            ),
            const AgroDetailCard(
              title: 'Nematode Results',
              body: 'Nematode had the smallest training set (68 images). '
                  'Leaf-based nematode detection is the least reliable label — '
                  'soil testing is needed for potato cyst nematode (PCN).',
              icon: Icons.warning_amber_rounded,
            ),
            const AgroDetailCard(
              title: 'Confidence Scores',
              body: 'If confidence is below about 50%, do not rely on the '
                  'result alone. Take another photo or seek expert advice.',
              icon: Icons.speed_outlined,
            ),
            const SizedBox(height: 12),
            const AgroSectionTitle('Better Scan Results'),
            const SizedBox(height: 12),
            const AgroDetailCard(
              title: 'Photograph One Leaf',
              body: 'Use good natural daylight. Fill the frame with a single '
                  'potato leaf against a plain background.',
              icon: Icons.camera_alt_outlined,
            ),
            const AgroDetailCard(
              title: 'Avoid Common Mistakes',
              body: 'Blurry images, heavy shade, multiple leaves in frame, '
                  'or non-potato plants reduce accuracy.',
              icon: Icons.block_outlined,
            ),
            const SizedBox(height: 12),
            const AgroSectionTitle('When to Seek Expert Help'),
            const SizedBox(height: 12),
            const AgroDetailCard(
              title: 'Low Confidence or Repeated Conflicts',
              body: 'If scans keep giving different labels or low scores, '
                  'consult an agronomist or plant clinic.',
              icon: Icons.support_agent_outlined,
            ),
            const AgroDetailCard(
              title: 'Commercial Crops at Risk',
              body: 'Before treating a large field or applying chemicals at '
                  'scale, get professional confirmation.',
              icon: Icons.agriculture_outlined,
            ),
            const AgroDetailCard(
              title: 'Suspected Notifiable Disease',
              body: 'Report serious outbreaks through the UK Plant Health '
                  'Service if you suspect a regulated pest or disease.',
              icon: Icons.report_outlined,
            ),
            const SizedBox(height: 12),
            const AgroSectionTitle('UK Chemical & Legal Reminders'),
            const SizedBox(height: 12),
            const AgroDetailCard(
              title: 'Follow Product Labels',
              body: 'Only use pesticides approved for potatoes in the UK. '
                  'Follow HSE/CRD guidance, label rates, and harvest intervals.',
              icon: Icons.menu_book_outlined,
            ),
            const AgroDetailCard(
              title: 'On-Farm Safety',
              body: 'Follow COSHH and on-farm safety rules when handling '
                  'chemicals. Keep records of applications in Crop Records.',
              icon: Icons.health_and_safety_outlined,
            ),
            const SizedBox(height: 16),
            const AgroInfoBanner(
              icon: Icons.shield_outlined,
              text:
                  'AgroScan is designed to support informed decisions, not replace '
                  'qualified agricultural advisers, statutory reporting, or '
                  'professional laboratory testing.',
            ),
          ],
        ),
      ),
    );
  }
}
