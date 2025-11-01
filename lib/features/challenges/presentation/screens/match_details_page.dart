import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/model/challenge_match_model.dart';

/// Page for displaying detailed information about a completed challenge match.
class MatchDetailsPage extends StatelessWidget {
  final ChallengeMatch match;

  const MatchDetailsPage({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'تفاصيل التحدي',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badges Row
              Row(
                children: [
                  // Match Status Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: match.isPast
                          ? Colors.green.shade100
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: match.isPast
                            ? Colors.green.shade300
                            : Colors.blue.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          match.isPast ? Icons.check_circle : Icons.schedule,
                          color: match.isPast
                              ? Colors.green.shade700
                              : Colors.blue.shade700,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          match.isPast ? 'تحدي مكتمل' : 'تحدي جاهز',
                          style: TextStyle(
                            color: match.isPast
                                ? Colors.green.shade700
                                : Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Competitive/Friendly Badge
                  if (match.isCompetitive != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: match.isCompetitive == true
                            ? Colors.orange.shade100
                            : Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: match.isCompetitive == true
                              ? Colors.orange.shade300
                              : Colors.purple.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            match.isCompetitive == true
                                ? Icons.emoji_events
                                : Icons.handshake,
                            color: match.isCompetitive == true
                                ? Colors.orange.shade700
                                : Colors.purple.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            match.isCompetitive == true
                                ? 'مباراة تنافسية'
                                : 'مباراة ودية',
                            style: TextStyle(
                              color: match.isCompetitive == true
                                  ? Colors.orange.shade700
                                  : Colors.purple.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Teams Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Team 1
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              _getTeamLogoImage(match.team1?['logo_url']),
                          child: match.team1?['logo_url'] == null ||
                                  (match.team1!['logo_url'] is String &&
                                      (match.team1!['logo_url'] as String)
                                          .isEmpty) ||
                                  (match.team1!['logo_url'] is String &&
                                      !(match.team1!['logo_url'] as String)
                                          .startsWith('http'))
                              ? const Icon(Icons.groups,
                                  color: Colors.grey, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            match.team1?['name'] ?? 'فريق 1',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // VS Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: darkBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'VS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Team 2
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              _getTeamLogoImage(match.team2?['logo_url']),
                          child: match.team2?['logo_url'] == null ||
                                  (match.team2!['logo_url'] is String &&
                                      (match.team2!['logo_url'] as String)
                                          .isEmpty) ||
                                  (match.team2!['logo_url'] is String &&
                                      !(match.team2!['logo_url'] as String)
                                          .startsWith('http'))
                              ? const Icon(Icons.groups,
                                  color: Colors.grey, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            match.team2?['name'] ?? 'فريق 2',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Match Details Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تفاصيل المباراة',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Playground with open in maps button
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.grey.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'الملعب: ${match.playground}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => _openPlaygroundInMaps(context),
                          icon: const Icon(Icons.map, size: 18),
                          label: const Text(
                            'عرض على الخريطة',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Date and Time
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.grey.shade600, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'التاريخ والوقت: ${match.date} ${match.startTime}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Amount
                    Row(
                      children: [
                        Icon(Icons.attach_money,
                            color: Colors.grey.shade600, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'المبلغ: ${match.amount} ريال',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Match ID for reference
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'رقم التحدي: #${match.id}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper function to get the appropriate image provider for a team logo.
  ImageProvider? _getTeamLogoImage(dynamic logoUrl) {
    if (logoUrl is String && logoUrl.isNotEmpty && logoUrl.startsWith('http')) {
      return NetworkImage(logoUrl);
    }
    return null; // Return null to use the child widget (icon)
  }

  Future<void> _openPlaygroundInMaps(BuildContext context) async {
    final loc = match.playgroundLocation;
    final lat = loc?.lat;
    final lng = loc?.lng;

    if (lat == null || lat.isEmpty || lng == null || lng.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد إحداثيات للموقع')),
      );
      return;
    }

    // Build platform-specific URIs
    Uri? uriToLaunch;

    if (Platform.isIOS) {
      // Apple Maps
      uriToLaunch = Uri.parse('https://maps.apple.com/?q=$lat,$lng');
    } else if (Platform.isAndroid) {
      // Try geo: scheme to allow user to choose the app if multiple map apps exist
      final label = Uri.encodeComponent(loc?.location ?? match.playground);
      final geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng($label)');
      if (await canLaunchUrl(geoUri)) {
        uriToLaunch = geoUri;
      } else {
        // Fallback to Google Maps link (from API if available, else universal query)
        final gLink = loc?.googleMapsLink;
        uriToLaunch = Uri.parse(
            gLink ?? 'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      }
    } else {
      // Other platforms: open a universal Google Maps URL
      final gLink = loc?.googleMapsLink;
      uriToLaunch = Uri.parse(
          gLink ?? 'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    }

    final launched = await launchUrl(
      uriToLaunch,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر فتح تطبيق الخرائط')),
      );
    }
  }
}
