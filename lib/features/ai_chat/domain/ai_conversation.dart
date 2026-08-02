/// One SuccessAI conversation thread (SUCCESSAI_BUILD_PROMPT.md Section 2's
/// `GET /ai/conversations`) — `lastMessage` is a preview only, the full
/// history is fetched separately per-conversation.
class AiConversation {
  const AiConversation({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.lastMessage,
  });

  final String id;
  final String title;
  final DateTime updatedAt;
  final String? lastMessage;

  factory AiConversation.fromJson(Map<String, dynamic> json) => AiConversation(
        id: json['id'].toString(),
        title: (json['title'] as String?) ?? 'New chat',
        updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
        lastMessage: json['last_message'] as String?,
      );
}
