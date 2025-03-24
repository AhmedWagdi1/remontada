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
      'playground_id': playgroundId,
      'subscribers_qty': subscribers_quantity,
      'date': date,
      'start_time': statrtTime,
      'end_time': endTime,
      'durations': duration,
      'durations_text': durationTetx,
      'amount': amount,
      'details': details,
      'type': type,
      if (isUpdate == true) '_method': "put",
    };
  }
}
