part of 'models.dart';

class ProfileMenuItem {
  final String title;
  final String? leading;
  final Color? color;
  final IconData? trailing;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    required this.title,
    this.leading,
    this.color = Colors.transparent,
    this.trailing = Icons.keyboard_arrow_right,
    this.onTap,
  });

  @override
  String toString() {
    return '''ProfileMenuItem(
      title: $title,
      color: $color,
      leading: $leading,
      trailing: $trailing,
      onTap: $onTap,
    )''';
  }
}
