class CommentsModel {
  final String id;
  final String content;
  final String createdAt;
  final CommentAuthor author;
  final List<CommentsModel> replies;

  CommentsModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.author,
    this.replies = const [],
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    final List rawReplies = json['replies'] ?? [];
    return CommentsModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      author: CommentAuthor.fromJson(json['author']),
      replies: rawReplies.map((e) => CommentsModel.fromJson(e)).toList(),
    );
  }
}

class CommentAuthor {
  final String id;
  final String name;
  final String profileImage;
  final bool isVerified;

  CommentAuthor({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isVerified,
  });

  factory CommentAuthor.fromJson(Map<String, dynamic> json) {
    return CommentAuthor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }
}
