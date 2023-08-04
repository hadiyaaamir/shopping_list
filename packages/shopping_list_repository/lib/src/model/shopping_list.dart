part of 'model.dart';

class ShoppingList extends Equatable {
  ShoppingList({
    String title = '',
    required this.userId,
    List<ListUser>? users,
    String? id,
    this.icon = Icons.shopping_cart,
    DateTime? dateCreated,
    this.completedItems = 0,
    this.activeItems = 0,
  })  : assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        dateCreated = dateCreated ?? DateTime.now(),
        title = title.isEmpty ? 'Unnamed' : title,
        id = id ?? const Uuid().v4(),
        users = users ?? [];

  final String id;
  final String userId;
  final List<ListUser> users;
  final String title;
  final DateTime dateCreated;
  final int completedItems;
  final int activeItems;
  final IconData icon;

  ShoppingList copyWith({
    String? id,
    String? userId,
    List<ListUser>? users,
    String? title,
    IconData? icon,
    DateTime? dateCreated,
    int? completedItems,
    int? activeItems,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      users: users ?? this.users,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      dateCreated: dateCreated ?? this.dateCreated,
      completedItems: completedItems ?? this.completedItems,
      activeItems: activeItems ?? this.activeItems,
    );
  }

  static ShoppingList fromJson(Map<String, dynamic> json) => ShoppingList(
        title: json['title'] as String,
        id: json['id'] as String?,
        userId: json['userId'] as String,
        users: (json['users'] as List<dynamic>)
            .map((userJson) => ListUser.fromJson(userJson))
            .toList(),
        icon: json['icon'] != null
            ? IconData(
                json['icon']['codePoint'] as int,
                fontFamily: json['icon']['fontFamily'] as String?,
                fontPackage: json['icon']['fontPackage'] as String?,
              )
            : Icons.shopping_cart,
        dateCreated: json['dateCreated'].toDate(),
        completedItems: json['completedItems'] as int,
        activeItems: json['activeItems'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'users': users.map((user) => user.toJson()).toList(),
        'title': title,
        'icon': {
          'codePoint': icon.codePoint,
          'fontFamily': icon.fontFamily,
          'fontPackage': icon.fontPackage,
        },
        'dateCreated': dateCreated,
        'completedItems': completedItems,
        'activeItems': activeItems,
      };

  @override
  List<Object> get props => [
        id,
        title,
        dateCreated,
        users,
        userId,
        icon,
        completedItems,
        activeItems,
      ];
}
