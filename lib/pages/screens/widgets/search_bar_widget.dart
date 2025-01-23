import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    this.hintText,
    this.prefixIcon,
  });
  final String? hintText;
  final Widget? prefixIcon;
  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: false,
          fillColor: Colors.grey.withValues(alpha: 0.1),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          hintStyle: Theme.of(context).textTheme.displayMedium,
          hintText: widget.hintText,
          suffixIcon: const Icon(Icons.search),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
