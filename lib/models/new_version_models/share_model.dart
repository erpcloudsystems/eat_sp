class ShareModel {
  String? docType, docId, user;
  int? read, write, submit, share;

  ShareModel({
    this.docType,
    this.docId,
    this.user,
    this.read = 0,
    this.write = 0,
    this.share = 0,
    this.submit = 0,
  });
}
