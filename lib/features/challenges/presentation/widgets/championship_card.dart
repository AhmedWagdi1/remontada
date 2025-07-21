import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:remontada/core/app_strings/locale_keys.dart';

/// Base widget that renders a championship card with a title, rounds
/// information and a join badge.
class ChampionshipCard extends StatelessWidget {
  const ChampionshipCard({
    super.key,
    required this.titleKey,
    required this.rounds,
    required this.icon,
    required this.gradientColors,
  });

  /// Localization key for the card title.
  final String titleKey;

  /// Number of rounds played in the championship.
  final int rounds;

  /// Icon displayed on the top right of the card.
  final IconData icon;

  /// Gradient colors used as the card background.
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            titleKey.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(icon, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, size: 20, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          LocaleKeys.rounds_count.tr(args: [rounds.toString()]),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        LocaleKeys.available_to_join.tr(),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_back_ios, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// Championship card for the "سوبر ريمونتادا" competition.
class SuperRemontadaChampionshipCard extends StatelessWidget {
  const SuperRemontadaChampionshipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChampionshipCard(
      titleKey: LocaleKeys.super_remontada_championship,
      rounds: 4,
      icon: Icons.star,
      gradientColors: [Colors.blueGrey.shade200, Colors.blue.shade200],
    );
  }
}

/// Championship card for the "نخبة ريمونتادا" competition.
class EliteRemontadaChampionshipCard extends StatelessWidget {
  const EliteRemontadaChampionshipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChampionshipCard(
      titleKey: LocaleKeys.elite_remontada_championship,
      rounds: 8,
      icon: Icons.diamond_outlined,
      gradientColors: [Colors.purple.shade200, Colors.deepPurple.shade200],
    );
  }
}

/// Championship card for the "دوري أبطال ريمونتادا" competition.
class RemontadaChampionsLeagueCard extends StatelessWidget {
  const RemontadaChampionsLeagueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChampionshipCard(
      titleKey: LocaleKeys.champions_league_remontada_championship,
      rounds: 16,
      icon: Icons.emoji_events,
      gradientColors: [Colors.lightBlue.shade200, Colors.lightBlueAccent.shade100],
    );
  }
}
