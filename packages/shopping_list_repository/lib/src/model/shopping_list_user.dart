part of 'model.dart';

enum ShoppingListUserRoles { owner, editor, viewer }

extension ShoppingListUserRolesExtension on ShoppingListUserRoles {
  static ShoppingListUserRoles fromString(String role) {
    switch (role) {
      case 'owner':
        return ShoppingListUserRoles.owner;
      case 'editor':
        return ShoppingListUserRoles.editor;
      case 'viewer':
        return ShoppingListUserRoles.viewer;
      default:
        return ShoppingListUserRoles.editor;
    }
  }

  String toStringValue() {
    switch (this) {
      case ShoppingListUserRoles.owner:
        return 'owner';
      case ShoppingListUserRoles.editor:
        return 'editor';
      case ShoppingListUserRoles.viewer:
        return 'viewer';
    }
  }

  String toTitleCaseString() {
    String strRole = toStringValue();
    if (strRole.length > 1)
      strRole = strRole[0].toUpperCase() + strRole.substring(1);
    return strRole;
  }

  String toStringInformation() {
    switch (this) {
      case ShoppingListUserRoles.editor:
        return 'Can add items and edit/delete their own items';
      case ShoppingListUserRoles.viewer:
        return 'Can only check/uncheck items';
      default:
        return '';
    }
  }
}

class ShoppingListUser extends Equatable {
  const ShoppingListUser({
    required this.id,
    this.role = ShoppingListUserRoles.editor,
  });

  final String id;
  final ShoppingListUserRoles role;

  ShoppingListUser copyWith({String? id, ShoppingListUserRoles? role}) {
    return ShoppingListUser(
      id: id ?? this.id,
      role: role ?? this.role,
    );
  }

  static ShoppingListUser fromJson(Map<String, dynamic> json) =>
      ShoppingListUser(
        id: json['id'] as String,
        role: ShoppingListUserRolesExtension.fromString(json['role'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'role': role.toStringValue(),
      };

  static const empty = ShoppingListUser(id: '');

  @override
  List<Object> get props => [id, role];
}
