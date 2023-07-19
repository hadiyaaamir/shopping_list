part of 'model.dart';

class ShoppingList extends Equatable {
  ShoppingList({
    String title = '',
    required this.userId,
    List<String>? users,
    String? id,
    DateTime? dateCreated,
    this.completedItems = 0,
    this.activeItems = 0,
  })  : assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        dateCreated = dateCreated ?? DateTime.now(),
        title = title.isEmpty ? DateTime.now().toString() : title,
        id = id ?? const Uuid().v4(),
        users = users ?? [];

  final String id;
  final String userId;
  final List<String> users;
  final String title;
  final DateTime dateCreated;
  final int completedItems;
  final int activeItems;

  ShoppingList copyWith({
    String? id,
    String? userId,
    List<String>? users,
    String? title,
    DateTime? dateCreated,
    int? completedItems,
    int? activeItems,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      users: users ?? this.users,
      title: title ?? this.title,
      dateCreated: dateCreated ?? this.dateCreated,
      completedItems: completedItems ?? this.completedItems,
      activeItems: activeItems ?? this.activeItems,
    );
  }

  static ShoppingList fromJson(Map<String, dynamic> json) => ShoppingList(
        title: json['title'] as String,
        id: json['id'] as String?,
        userId: json['userId'] as String,
        users: List<String>.from(json['users'] as List<dynamic>),
        dateCreated: json['dateCreated'].toDate(),
        completedItems: json['completedItems'] as int,
        activeItems: json['activeItems'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'users': users,
        'title': title,
        'dateCreated': dateCreated,
        'completedItems': completedItems,
        'activeItems': activeItems,
      };

  @override
  List<Object> get props =>
      [id, title, dateCreated, users, userId, completedItems, activeItems];
}
