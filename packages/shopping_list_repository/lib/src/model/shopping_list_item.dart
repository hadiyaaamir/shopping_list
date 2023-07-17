part of 'model.dart';

class ShoppingListItem extends Equatable {
  ShoppingListItem({
    required this.title,
    required this.listId,
    String? id,
    this.description = '',
    this.isCompleted = false,
    DateTime? dateCreated,
  })  : assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        dateCreated = dateCreated ?? DateTime.now(),
        id = id ?? const Uuid().v4();

  final String id;

  final String listId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dateCreated;

  ShoppingListItem copyWith({
    String? id,
    String? listId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dateCreated,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  static ShoppingListItem fromJson(Map<String, dynamic> json) =>
      ShoppingListItem(
        title: json['title'] as String,
        id: json['id'] as String?,
        listId: json['listId'] as String,
        description: json['description'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
        dateCreated: json['dateCreated'].toDate(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'listId': listId,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'dateCreated': dateCreated,
      };

  @override
  List<Object> get props => [id, title, description, isCompleted, dateCreated];
}
