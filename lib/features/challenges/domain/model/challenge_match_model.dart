/// Model for challenge match data from the challenges-index API.
class ChallengeMatch {
  final int id;
  final String playground;
  final PlaygroundLocation? playgroundLocation;
  final String date;
  final String startTime;
  final String amount;
  final bool isReserved;
  final bool? isCompetitive;
  final Map<String, dynamic>? team1;
  final Map<String, dynamic>? team2;

  ChallengeMatch({
    required this.id,
    required this.playground,
    this.playgroundLocation,
    required this.date,
    required this.startTime,
    required this.amount,
    required this.isReserved,
    this.isCompetitive,
    this.team1,
    this.team2,
  });

  factory ChallengeMatch.fromJson(Map<String, dynamic> json) {
    return ChallengeMatch(
      id: json['id'] ?? 0,
      playground: json['playground'] ?? '',
      playgroundLocation: json['playground_location'] is Map<String, dynamic>
          ? PlaygroundLocation.fromJson(
              json['playground_location'] as Map<String, dynamic>,
            )
          : null,
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      isReserved: json['is_reserved'] == true,
      isCompetitive: (() {
        final v = json['is_competitive'];
        if (v == null) return null;
        if (v is bool) return v;
        if (v is int) return v == 1;
        if (v is String) return v == '1' || v.toLowerCase() == 'true';
        return null;
      })(),
      team1: json['team1'],
      team2: json['team2'],
    );
  }

  /// Parses the date string to extract DateTime.
  DateTime get parsedDate {
    final datePart = date.split(' ')[1]; // Extract "2025-11-19"
    return DateTime.parse(datePart);
  }

  /// Checks if the match is in the past.
  bool get isPast => parsedDate.isBefore(DateTime.now());
}

/// Location details for a playground associated with a match.
class PlaygroundLocation {
  final String? lat; // kept as String to mirror API; parse to double when needed
  final String? lng;
  final String? location; // human readable address
  final String? googleMapsLink; // direct link if provided by API

  const PlaygroundLocation({this.lat, this.lng, this.location, this.googleMapsLink});

  factory PlaygroundLocation.fromJson(Map<String, dynamic> json) {
    return PlaygroundLocation(
      lat: json['lat']?.toString(),
      lng: json['lng']?.toString(),
      location: json['location']?.toString(),
      googleMapsLink: json['google_maps_link']?.toString(),
    );
  }
}
