part of 'model.dart';

class ShoppingListItem extends Equatable {
  ShoppingListItem({
    required this.item,
    required this.listId,
    required this.userId,
    String? id,
    this.quantity = '',
    this.quantityUnit = '',
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
  final String userId;
  final String item;
  final String quantity;
  final String quantityUnit;
  final String description;
  final bool isCompleted;
  final DateTime dateCreated;

  ShoppingListItem copyWith({
    String? id,
    String? listId,
    String? userId,
    String? item,
    String? quantity,
    String? quantityUnit,
    String? description,
    bool? isCompleted,
    DateTime? dateCreated,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      userId: userId ?? this.userId,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  static ShoppingListItem fromJson(Map<String, dynamic> json) =>
      ShoppingListItem(
        item: json['item'] as String,
        id: json['id'] as String?,
        listId: json['listId'] as String,
        userId: json['userId'] as String,
        quantity: json['quantity'] as String? ?? '',
        quantityUnit: json['quantityUnit'] as String? ?? '',
        description: json['description'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
        dateCreated: json['dateCreated'].toDate(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'listId': listId,
        'userId': userId,
        'item': item,
        'quantity': quantity,
        'quantityUnit': quantityUnit,
        'description': description,
        'isCompleted': isCompleted,
        'dateCreated': dateCreated,
      };

  @override
  List<Object?> get props => [
        id,
        listId,
        userId,
        item,
        quantity,
        quantityUnit,
        description,
        isCompleted,
        dateCreated,
      ];
}
