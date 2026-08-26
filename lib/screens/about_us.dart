import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key, required this.members});

  final List<Member> members;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About AgroScan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AgroScanTheme.heroGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AgroScanTheme.softShadow,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AgroScan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Professional plant-health guidance for growers who need '
                  'fast, reliable insights in the field.',
                  style: TextStyle(
                    color: Color(0xFFDDEBDD),
                    height: 1.5,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const AgroSectionTitle('Development Team'),
          const SizedBox(height: 12),
          ...members.map((member) => _MemberCard(member: member)),
          const SizedBox(height: 20),
          const AgroInfoBanner(
            icon: Icons.info_outline_rounded,
            text:
                'AgroScan provides advisory results only. Always confirm serious '
                'plant health issues with a qualified agricultural professional.',
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AgroScanTheme.accentSoft,
              backgroundImage: member.image,
              child: member.image == null
                  ? Text(
                      member.name.characters.first,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AgroScanTheme.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AgroScanTheme.text,
                    ),
                  ),
                  if (member.title != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      member.title!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  if (member.email != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      member.email!,
                      style: const TextStyle(
                        color: AgroScanTheme.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Member {
  const Member({
    required this.name,
    this.title,
    this.image,
    this.email,
  });

  final String name;
  final String? title;
  final AssetImage? image;
  final String? email;
}

const List<Member> teamMembers = [
  Member(
    name: 'Kulaja Malwenna',
    title: 'Lead Developer',
    image: AssetImage('assets/images/Kulaja1.jpg'),
    email: 'kulajamalwenna@gmail.com',
  ),
];
