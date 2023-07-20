part of 'model.dart';

class ShoppingListItem extends Equatable {
  ShoppingListItem({
    required this.item,
    required this.listId,
    String? id,
    this.quantity = '',
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
  final String item;
  final String quantity;
  final bool isCompleted;
  final DateTime dateCreated;

  ShoppingListItem copyWith({
    String? id,
    String? listId,
    String? item,
    String? quantity,
    bool? isCompleted,
    DateTime? dateCreated,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      isCompleted: isCompleted ?? this.isCompleted,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  static ShoppingListItem fromJson(Map<String, dynamic> json) =>
      ShoppingListItem(
        item: json['item'] as String,
        id: json['id'] as String?,
        listId: json['listId'] as String,
        quantity: json['quantity'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
        dateCreated: json['dateCreated'].toDate(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'listId': listId,
        'item': item,
        'quantity': quantity,
        'isCompleted': isCompleted,
        'dateCreated': dateCreated,
      };

  @override
  List<Object> get props =>
      [id, listId, item, quantity, isCompleted, dateCreated];
}
