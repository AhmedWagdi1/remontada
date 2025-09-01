import 'package:flutter/material.dart';
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
              // Match Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: match.isPast ? Colors.green.shade100 : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: match.isPast ? Colors.green.shade300 : Colors.blue.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      match.isPast ? Icons.check_circle : Icons.schedule,
                      color: match.isPast ? Colors.green.shade700 : Colors.blue.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      match.isPast ? 'تحدي مكتمل' : 'تحدي جاهز',
                      style: TextStyle(
                        color: match.isPast ? Colors.green.shade700 : Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
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
                          backgroundImage: (match.team1?['logo_url'] is String && (match.team1!['logo_url'] as String).isNotEmpty)
                              ? NetworkImage(match.team1!['logo_url'] as String) as ImageProvider
                              : AssetImage('assets/images/profile_image.png'),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          backgroundImage: (match.team2?['logo_url'] is String && (match.team2!['logo_url'] as String).isNotEmpty)
                              ? NetworkImage(match.team2!['logo_url'] as String) as ImageProvider
                              : AssetImage('assets/images/profile_image.png'),
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

                    // Playground
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey.shade600, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'الملعب: ${match.playground}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Date and Time
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 20),
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
                        Icon(Icons.attach_money, color: Colors.grey.shade600, size: 20),
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

                    const SizedBox(height: 12),

                    // Reservation Status
                    Row(
                      children: [
                        Icon(
                          match.isReserved ? Icons.check_circle : Icons.cancel,
                          color: match.isReserved ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          match.isReserved ? 'محجوز' : 'غير محجوز',
                          style: TextStyle(
                            fontSize: 16,
                            color: match.isReserved ? Colors.green : Colors.red,
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
}
