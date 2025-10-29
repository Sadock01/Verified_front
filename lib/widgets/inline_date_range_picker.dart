import 'package:flutter/material.dart';

class InlineDateRangePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onDateRangeChanged;

  const InlineDateRangePicker({
    Key? key,
    this.startDate,
    this.endDate,
    required this.onDateRangeChanged,
  }) : super(key: key);

  @override
  State<InlineDateRangePicker> createState() => _InlineDateRangePickerState();
}

class _InlineDateRangePickerState extends State<InlineDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _currentMonth = DateTime.now();
  
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _currentMonth = _startDate != null ? DateTime(_startDate!.year, _startDate!.month) : DateTime.now();
  }

  @override
  void didUpdateWidget(InlineDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startDate != oldWidget.startDate) {
      _startDate = widget.startDate;
    }
    if (widget.endDate != oldWidget.endDate) {
      _endDate = widget.endDate;
    }
    if (_startDate != null) {
      _currentMonth = DateTime(_startDate!.year, _startDate!.month);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleCalendar() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _closeOverlay();
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Overlay invisible pour fermer quand on clique en dehors
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Le calendrier, positionné relativement au champ
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0.0, 45.0 + 8.0), // 45 (hauteur du champ) + 8 (padding)
            child: Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () {}, // Empêche la fermeture quand on clique sur le calendrier
                child: SizedBox(
                  width: 300, // Largeur fixe pour le calendrier
                  child: _buildInlineCalendar(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _closeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {}); // Rebuild pour mettre à jour l'icône
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleCalendar,
        child: Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getDisplayText(),
                  style: Theme.of(context).textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                _overlayEntry == null ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (_startDate == null && _endDate == null) {
      return "Sélectionner la période";
    } else if (_startDate != null && _endDate != null) {
      return "${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}";
    } else if (_startDate != null) {
      return "À partir du ${_formatDate(_startDate!)}";
    } else {
      return "Jusqu'au ${_formatDate(_endDate!)}";
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return "${date.day} ${months[date.month - 1]}";
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = selectedDay;
        _endDate = null;
      } else if (_startDate != null && selectedDay.isBefore(_startDate!)) {
        _startDate = selectedDay;
      } else {
        _endDate = selectedDay;
      }
    });
  }

  List<DateTime?> _getDaysInMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = <DateTime?>[];

    int weekdayOfFirstDay = firstDayOfMonth.weekday;
    if (weekdayOfFirstDay == 7) weekdayOfFirstDay = 0; // Sunday = 0

    for (int i = 0; i < weekdayOfFirstDay; i++) {
      daysInMonth.add(null);
    }

    for (int i = 0; i < DateTime(month.year, month.month + 1, 0).day; i++) {
      daysInMonth.add(DateTime(month.year, month.month, i + 1));
    }
    return daysInMonth;
  }

  Widget _buildInlineCalendar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Navigation du mois
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                  });
                  _overlayEntry?.markNeedsBuild();
                },
              ),
              Text(
                _getMonthYear(_currentMonth),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                  });
                  _overlayEntry?.markNeedsBuild();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          // En-têtes des jours de la semaine
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final weekdays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
              return SizedBox(
                width: 30,
                child: Text(
                  weekdays[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 5),
          // Grille des jours
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: _getDaysInMonth(_currentMonth).length,
            itemBuilder: (context, index) {
              final date = _getDaysInMonth(_currentMonth)[index];
              return _buildDayCell(date);
            },
          ),
          const SizedBox(height: 10),
          // Boutons d'action
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                  });
                  widget.onDateRangeChanged(null, null);
                  _closeOverlay();
                },
                child: const Text("Effacer"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  widget.onDateRangeChanged(_startDate, _endDate);
                  _closeOverlay();
                },
                child: const Text("Appliquer"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime? date) {
    final isSelected = date != null &&
        ((_startDate != null && _isSameDay(date, _startDate!)) ||
         (_endDate != null && _isSameDay(date, _endDate!)));
    final isInRange = date != null &&
        _startDate != null && _endDate != null &&
        date.isAfter(_startDate!) && date.isBefore(_endDate!);
    final isToday = date != null && _isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: date != null ? () => _onDaySelected(date) : null,
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : isInRange
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                  : isToday
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: isToday && !isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1) : null,
        ),
        child: Center(
          child: Text(
            date != null ? date.day.toString() : '',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : date == null
                          ? Colors.transparent
                          : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ),
      ),
    );
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return "${months[date.month - 1]} ${date.year}";
  }
}
