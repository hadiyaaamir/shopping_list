part of 'model.dart';

enum ListUserRoles { owner, editor, viewer }

extension ListUserRolesExtension on ListUserRoles {
  static ListUserRoles fromString(String role) {
    switch (role) {
      case 'owner':
        return ListUserRoles.owner;
      case 'editor':
        return ListUserRoles.editor;
      case 'viewer':
        return ListUserRoles.viewer;
      default:
        return ListUserRoles.editor;
    }
  }

  String toStringValue() {
    switch (this) {
      case ListUserRoles.owner:
        return 'owner';
      case ListUserRoles.editor:
        return 'editor';
      case ListUserRoles.viewer:
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
      case ListUserRoles.editor:
        return 'Can add items and edit/delete their own items';
      case ListUserRoles.viewer:
        return 'Can only check/uncheck items';
      default:
        return '';
    }
  }
}

class ListUser extends Equatable {
  const ListUser({
    required this.id,
    this.role = ListUserRoles.editor,
  });

  final String id;
  final ListUserRoles role;

  ListUser copyWith({String? id, ListUserRoles? role}) {
    return ListUser(
      id: id ?? this.id,
      role: role ?? this.role,
    );
  }

  static ListUser fromJson(Map<String, dynamic> json) => ListUser(
        id: json['id'] as String,
        role: ListUserRolesExtension.fromString(json['role'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'role': role.toStringValue(),
      };

  static const empty = ListUser(id: '');

  @override
  List<Object> get props => [id, role];
}
