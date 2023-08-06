part of 'model.dart';

class ShoppingList extends Equatable {
  ShoppingList({
    String title = '',
    required this.userId,
    List<ListUser>? users,
    String? id,
    this.icon = Icons.shopping_cart,
    DateTime? dateCreated,
    this.totalItems = 0,
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
  final int totalItems;
  final IconData icon;

  ShoppingList copyWith({
    String? id,
    String? userId,
    List<ListUser>? users,
    String? title,
    IconData? icon,
    DateTime? dateCreated,
    int? totalItems,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      users: users ?? this.users,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      dateCreated: dateCreated ?? this.dateCreated,
      totalItems: totalItems ?? this.totalItems,
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
        totalItems: json['totalItems'] as int? ?? 0,
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
        'totalItems': totalItems,
      };

  @override
  List<Object> get props =>
      [id, title, dateCreated, users, userId, icon, totalItems];
}
