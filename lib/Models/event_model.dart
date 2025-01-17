class Event {
  String title;
  String description;
  String venue;
  String date;
  String time;
  String timeZone;
  String photoUrl;

  Event({
    this.title = '',
    this.description = '',
    this.venue = '',
    this.date = '',
    this.time = '',
    this.timeZone = '',
    this.photoUrl = '',
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        title: json['title'],
        description: json['description'],
        venue: json['venue'],
        date: json['date'],
        time: json['time'],
        timeZone: json['timeZone'],
        photoUrl: json['photoUrl'],
      );
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'venue': venue,
        'date': date,
        'time': time,
        'timeZone': timeZone,
        'photoUrl': photoUrl,
      };
}
