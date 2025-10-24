import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cubits/collaborateurs/collaborateurs_cubit.dart';
import '../../../../cubits/collaborateurs/collaborateurs_state.dart';


class SmartPaginationWidget extends StatelessWidget {
  final CollaborateursState state;

  const SmartPaginationWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Bouton Précédent
        if (state.currentPage > 1)
          InkWell(
            onTap: () {
              context.read<CollaborateursCubit>().goToPage(state.currentPage - 1);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isLight ? Colors.grey[100] : Colors.grey[800],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Icon(
                Icons.chevron_left,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ),
        
        const SizedBox(width: 8),
        
        // Numéros de page
        ..._buildPageNumbers(context, state, isLight),
        
        const SizedBox(width: 8),
        
        // Bouton Suivant
        if (state.currentPage < state.lastPage)
          InkWell(
            onTap: () {
              context.read<CollaborateursCubit>().goToPage(state.currentPage + 1);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isLight ? Colors.grey[100] : Colors.grey[800],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context, CollaborateursState state, bool isLight) {
    final List<Widget> pageNumbers = [];
    final int currentPage = state.currentPage;
    final int lastPage = state.lastPage;

    if (lastPage <= 5) {
      // Afficher toutes les pages si moins de 5
      for (int i = 1; i <= lastPage; i++) {
        pageNumbers.add(_buildPageNumber(context, i, currentPage, isLight));
        if (i < lastPage) pageNumbers.add(const SizedBox(width: 4));
      }
    } else {
      // Logique pour plus de 5 pages
      if (currentPage <= 3) {
        // Afficher 1, 2, 3, 4, ..., lastPage
        for (int i = 1; i <= 4; i++) {
          pageNumbers.add(_buildPageNumber(context, i, currentPage, isLight));
          pageNumbers.add(const SizedBox(width: 4));
        }
        pageNumbers.add(_buildEllipsis());
        pageNumbers.add(const SizedBox(width: 4));
        pageNumbers.add(_buildPageNumber(context, lastPage, currentPage, isLight));
      } else if (currentPage >= lastPage - 2) {
        // Afficher 1, ..., lastPage-3, lastPage-2, lastPage-1, lastPage
        pageNumbers.add(_buildPageNumber(context, 1, currentPage, isLight));
        pageNumbers.add(const SizedBox(width: 4));
        pageNumbers.add(_buildEllipsis());
        pageNumbers.add(const SizedBox(width: 4));
        for (int i = lastPage - 3; i <= lastPage; i++) {
          pageNumbers.add(_buildPageNumber(context, i, currentPage, isLight));
          if (i < lastPage) pageNumbers.add(const SizedBox(width: 4));
        }
      } else {
        // Afficher 1, ..., currentPage-1, currentPage, currentPage+1, ..., lastPage
        pageNumbers.add(_buildPageNumber(context, 1, currentPage, isLight));
        pageNumbers.add(const SizedBox(width: 4));
        pageNumbers.add(_buildEllipsis());
        pageNumbers.add(const SizedBox(width: 4));
        for (int i = currentPage - 1; i <= currentPage + 1; i++) {
          pageNumbers.add(_buildPageNumber(context, i, currentPage, isLight));
          pageNumbers.add(const SizedBox(width: 4));
        }
        pageNumbers.add(_buildEllipsis());
        pageNumbers.add(const SizedBox(width: 4));
        pageNumbers.add(_buildPageNumber(context, lastPage, currentPage, isLight));
      }
    }

    return pageNumbers;
  }

  Widget _buildPageNumber(BuildContext context, int pageNumber, int currentPage, bool isLight) {
    final isSelected = pageNumber == currentPage;
    
    return InkWell(
      onTap: () {
        context.read<CollaborateursCubit>().goToPage(pageNumber);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.black 
              : (isLight ? Colors.grey[100] : Colors.grey[800]),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected 
                ? Colors.black 
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          "$pageNumber",
          style: TextStyle(
            fontSize: 10,
            color: isSelected 
                ? Colors.white 
                : (isLight ? Colors.grey[700] : Colors.grey[300]),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        "...",
        style: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
