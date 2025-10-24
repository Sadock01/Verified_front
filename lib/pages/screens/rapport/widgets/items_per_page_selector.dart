import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cubits/rapports/report_cubit.dart';
import '../../../../cubits/rapports/report_state.dart';


class ItemsPerPageSelector extends StatelessWidget {
  final ReportState state;

  const ItemsPerPageSelector({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Nombre de documents : ",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "${state.listReports.length}",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //   decoration: BoxDecoration(
        //     border: Border.all(color: Colors.grey[300]!),
        //     borderRadius: BorderRadius.circular(5),
        //   ),
        //   child: DropdownButtonHideUnderline(
        //     child: DropdownButton<int>(
        //       value: state.itemsPerPage,
        //       isDense: true,
        //       style: Theme.of(context).textTheme.labelSmall,
        //       items: [5, 10, 20, 50].map((int value) {
        //         return DropdownMenuItem<int>(
        //           value: value,
        //           child: Text("$value"),
        //         );
        //       }).toList(),
        //       onChanged: (int? newValue) {
        //         if (newValue != null) {
        //           context.read<ReportCubit>().setItemsPerPage(newValue);
        //         }
        //       },
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
