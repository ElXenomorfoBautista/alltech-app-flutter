class Evidence {
  int? id;
  int? fileId;
  int? entityTypeId;
  int? entityId;
  DateTime? createdOn;
  int? createdBy;
  FileEvidence? file;

  Evidence({
    this.id,
    this.fileId,
    this.entityTypeId,
    this.entityId,
    this.createdOn,
    this.createdBy,
    this.file,
  });

  Evidence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileId = json['fileId'];
    entityTypeId = json['entityTypeId'];
    entityId = json['entityId'];
    createdOn =
        json['createdOn'] != null ? DateTime.parse(json['createdOn']) : null;
    createdBy = json['createdBy'];
    file = json['file'] != null ? FileEvidence.fromJson(json['file']) : null;
  }
}

class FileEvidence {
  int? id;
  String? originalName;
  String? fileName;
  String? filePath;
  String? fileType;
  String? accessUrl;

  FileEvidence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    originalName = json['originalName'];
    fileName = json['fileName'];
    filePath = json['filePath'];
    fileType = json['fileType'];
    accessUrl = json['accessUrl'];
  }
}
