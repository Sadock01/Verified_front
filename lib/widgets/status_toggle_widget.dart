import 'package:flutter/material.dart';

class StatusToggleWidget extends StatelessWidget {
  final bool isActive;
  final Function(bool) onChanged;
  final String? activeText;
  final String? inactiveText;

  const StatusToggleWidget({
    Key? key,
    required this.isActive,
    required this.onChanged,
    this.activeText,
    this.inactiveText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => onChanged(!isActive),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isActive 
                    ? (activeText ?? "Actif") 
                    : (inactiveText ?? "Inactif"),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive ? Colors.green : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedStatusToggleWidget extends StatefulWidget {
  final bool isActive;
  final Function(bool) onChanged;
  final String? activeText;
  final String? inactiveText;

  const AnimatedStatusToggleWidget({
    Key? key,
    required this.isActive,
    required this.onChanged,
    this.activeText,
    this.inactiveText,
  }) : super(key: key);

  @override
  State<AnimatedStatusToggleWidget> createState() => _AnimatedStatusToggleWidgetState();
}

class _AnimatedStatusToggleWidgetState extends State<AnimatedStatusToggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.green,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isActive ? Colors.green : Colors.grey[300]!,
                width: 2,
              ),
              boxShadow: widget.isActive ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  _animationController.forward().then((_) {
                    _animationController.reverse();
                    widget.onChanged(!widget.isActive);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: widget.isActive ? Colors.green : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.isActive 
                          ? (widget.activeText ?? "Actif") 
                          : (widget.inactiveText ?? "Inactif"),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: widget.isActive ? Colors.green : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StatusSwitchWidget extends StatelessWidget {
  final bool isActive;
  final Function(bool) onChanged;
  final String? activeText;
  final String? inactiveText;

  const StatusSwitchWidget({
    Key? key,
    required this.isActive,
    required this.onChanged,
    this.activeText,
    this.inactiveText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Switch.adaptive(
        value: isActive,
        onChanged: onChanged,
        activeColor: Colors.green,
        activeTrackColor: Colors.green.withOpacity(0.3),
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[200],
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
