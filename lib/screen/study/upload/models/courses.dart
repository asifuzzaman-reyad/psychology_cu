class Courses {
  Courses({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.fileUrl,
  });

  final String title;
  final String subtitle;
  final String date;
  final String fileUrl;

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'date': date,
        'fileUrl': fileUrl,
      };
}
