import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doc_authentificator/cubits/verification/verification_cubit.dart';
import 'package:doc_authentificator/cubits/verification/verification_state.dart';

class SmartPaginationWidget extends StatelessWidget {
  final VerificationState state;
  
  const SmartPaginationWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFirstPage = state.currentPage == 1;
    final isLastPage = state.currentPage == state.lastPage;
    
    return Row(
      children: [
        // Flèche précédente (cachée si première page)
        if (!isFirstPage) ...[
          InkWell(
            onTap: () => context.read<VerificationCubit>().goToPreviousPage(),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!), 
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.arrow_back, size: 18),
            ),
          ),
          SizedBox(width: 10),
        ],
        
        // Pages avec logique intelligente
        ..._buildPageNumbers(context, theme),
        
        // Flèche suivante (cachée si dernière page)
        if (!isLastPage) ...[
          SizedBox(width: 10),
          InkWell(
            onTap: () => context.read<VerificationCubit>().goToNextPage(),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!), 
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.arrow_forward, size: 18),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context, ThemeData theme) {
    final currentPage = state.currentPage;
    final lastPage = state.lastPage;
    final List<Widget> pageWidgets = [];

    if (lastPage <= 5) {
      // Si 5 pages ou moins, afficher toutes les pages
      for (int i = 1; i <= lastPage; i++) {
        pageWidgets.add(_buildPageButton(context, i, i == currentPage));
        if (i < lastPage) pageWidgets.add(SizedBox(width: 5));
      }
    } else {
      // Logique pour plus de 5 pages
      if (currentPage <= 3) {
        // Afficher les 3 premières + ... + dernière
        for (int i = 1; i <= 3; i++) {
          pageWidgets.add(_buildPageButton(context, i, i == currentPage));
          pageWidgets.add(SizedBox(width: 5));
        }
        pageWidgets.add(_buildDots());
        pageWidgets.add(SizedBox(width: 5));
        pageWidgets.add(_buildPageButton(context, lastPage, false));
      } else if (currentPage >= lastPage - 2) {
        // Afficher première + ... + 3 dernières
        pageWidgets.add(_buildPageButton(context, 1, false));
        pageWidgets.add(SizedBox(width: 5));
        pageWidgets.add(_buildDots());
        pageWidgets.add(SizedBox(width: 5));
        for (int i = lastPage - 2; i <= lastPage; i++) {
          pageWidgets.add(_buildPageButton(context, i, i == currentPage));
          if (i < lastPage) pageWidgets.add(SizedBox(width: 5));
        }
      } else {
        // Afficher première + ... + page actuelle + ... + dernière
        pageWidgets.add(_buildPageButton(context, 1, false));
        pageWidgets.add(SizedBox(width: 5));
        pageWidgets.add(_buildDots());
        pageWidgets.add(SizedBox(width: 5));
        pageWidgets.add(_buildPageButton(context, currentPage, true));
        pageWidgets.add(SizedBox(width: 5));
        pageWidgets.add(_buildDots());
        pageWidgets.add(SizedBox(width: 5));
        pageWidgets.add(_buildPageButton(context, lastPage, false));
      }
    }

    return pageWidgets;
  }

  Widget _buildPageButton(BuildContext context, int pageNumber, bool isSelected) {
    return InkWell(
      onTap: () => _goToPage(context, pageNumber),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          "$pageNumber",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text(
        "...",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _goToPage(BuildContext context, int pageNumber) {
    context.read<VerificationCubit>().getAllVerification(pageNumber);
  }
}
