import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HoverAnimatedStep extends StatefulWidget {
  final int number;
  final String title;
  final String desc;
  final Color color;
  final IconData icon;

  const HoverAnimatedStep({
    required this.number,
    required this.title,
    required this.desc,
    required this.color,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  State<HoverAnimatedStep> createState() => _HoverAnimatedStepState();
}

class _HoverAnimatedStepState extends State<HoverAnimatedStep> with SingleTickerProviderStateMixin {
  bool _hovering = false;
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scale = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _onEnter(PointerEvent details) {
    setState(() => _hovering = true);
    _controller.forward();
  }

  void _onExit(PointerEvent details) {
    setState(() => _hovering = false);
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 280,
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.2),
                blurRadius: 25,
                offset: Offset(0, 10),
              ),
            ],
            border: Border.all(color: widget.color.withOpacity(0.3), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: widget.color,
                radius: 30,
                child: Icon(widget.icon, size: 32, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "Étape ${widget.number}",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold, fontSize: 18, color: widget.color),
              ),
              SizedBox(height: 8),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(height: 6),
              Text(
                widget.desc,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey[700], fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
