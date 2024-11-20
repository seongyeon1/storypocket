import 'package:flutter/material.dart';

class MeauBottonTile extends StatelessWidget {
  const MeauBottonTile({
    super.key,
    required this.onPressed,
    required TextStyle headerMeauStyle,
    required this.title,
  }) : _headerMeauStyle = headerMeauStyle;

  final TextStyle _headerMeauStyle;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        minimumSize: const Size(110, 90),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: _headerMeauStyle,
      ),
    );
  }
}
