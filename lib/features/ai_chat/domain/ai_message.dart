/// One message in a SuccessAI thread. `isAi` distinguishes the assistant's
/// replies from the student's own messages; `sender` is the display label
/// the server sends (e.g. "SuccessAI" / the student's name).
class AiMessage {
  const AiMessage({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isAi,
    required this.sender,
    required this.createdAt,
  });

  final String id;
  final String conversationId;
  final String content;
  final bool isAi;
  final String sender;
  final DateTime createdAt;

  factory AiMessage.fromJson(Map<String, dynamic> json, {required String conversationId}) => AiMessage(
        id: json['id'].toString(),
        conversationId: (json['conversation_id'] ?? conversationId).toString(),
        content: (json['content'] as String?) ?? '',
        isAi: json['is_ai'] == true,
        sender: (json['sender'] as String?) ?? (json['is_ai'] == true ? 'SuccessAI' : 'You'),
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      );
}
