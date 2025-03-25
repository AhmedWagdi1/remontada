// ignore_for_file: public_member_api_docs, sort_constructors_first
class CreateMatchRequest {
  String? playgroundId;
  String? subscribers_quantity;
  String? date;
  String? statrtTime;
  String? endTime;
  String? duration;
  String? durationTetx;
  String? amount;
  String? details;
  String? type;
  bool? isUpdate;
  CreateMatchRequest({
    this.playgroundId,
    this.subscribers_quantity,
    this.date,
    this.statrtTime,
    this.endTime,
    this.duration,
    this.durationTetx,
    this.amount,
    this.details,
    this.isUpdate,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (playgroundId != null) 'playground_id': playgroundId,
      if (subscribers_quantity != null) 'subscribers_qty': subscribers_quantity,
      if (date != null) 'date': date,
      if (statrtTime != null) 'start_time': statrtTime,
      if (endTime != null) 'end_time': endTime,
      if (duration != null) 'durations': duration,
      if (durationTetx != null) 'durations_text': durationTetx,
      if (amount != null) 'amount': amount,
      if (details != null) 'details': details,
      if (type != null) 'type': type,
      if (isUpdate == true) '_method': "put",
    };
  }
}
