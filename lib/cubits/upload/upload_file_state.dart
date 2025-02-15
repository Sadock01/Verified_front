import 'package:equatable/equatable.dart';

enum UploadStatus {
  initial,
  uploading,
  uploaded,
  fileExists,
  error,
}

class UploadFileState extends Equatable {
  final UploadStatus uploadStatus;
  final String fileUrl; // URL du fichier PDF après upload
  final String errorMessage;

  const UploadFileState({
    required this.uploadStatus,
    required this.fileUrl,
    required this.errorMessage,
  });

  factory UploadFileState.initial() {
    return const UploadFileState(
      uploadStatus: UploadStatus.initial,
      fileUrl: "",
      errorMessage: "",
    );
  }

  UploadFileState copyWith({
    UploadStatus? uploadStatus,
    String? fileUrl,
    String? errorMessage,
  }) {
    return UploadFileState(
      uploadStatus: uploadStatus ?? this.uploadStatus,
      fileUrl: fileUrl ?? this.fileUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [uploadStatus, fileUrl, errorMessage];
}
