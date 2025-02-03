class UploadResultModel {
  final String publicId;
  final String url;
  final String? error;

  UploadResultModel({
    required this.publicId,
    required this.url,
    this.error,
  });

  factory UploadResultModel.fromJson(Map<String, dynamic> json) {
    return UploadResultModel(
      publicId: json['public_id'] ?? '',
      url: json['secure_url'] ?? '',
      error: null,
    );
  }

  factory UploadResultModel.withError(String error) {
    return UploadResultModel(
      publicId: '',
      url: '',
      error: error,
    );
  }
}