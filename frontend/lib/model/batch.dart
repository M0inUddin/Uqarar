class Batchs {
  String id;
  final String batchYear;

  Batchs({required this.id, required this.batchYear});

  Map<String, dynamic> toJson() => {'id': id, 'batchYear': batchYear};

  static Batchs fromJson(Map<String, dynamic> json) =>
      Batchs(id: json['id'], batchYear: json['batchYear']);
}
