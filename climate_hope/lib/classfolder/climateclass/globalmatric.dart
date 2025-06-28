class GlobalMetric {
  final String label;
  final String value;
  final String unit;
  final String description;
  final String? learnMoreUrl;

  GlobalMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.description,
    this.learnMoreUrl,
  });

  factory GlobalMetric.fromJson(Map<String, dynamic> json) {
    return GlobalMetric(
      label: json['label'],
      value: json['value'],
      unit: json['unit'],
      description: json['description'],
      learnMoreUrl: json['learnMoreUrl'],
    );
  }
}
