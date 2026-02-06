import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_flutter_hackathon/logic/search_bloc.dart';

class TypeFilterPicker extends StatelessWidget {
  final List<String> types;

  const TypeFilterPicker({super.key, required this.types});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          return BlocBuilder<SearchBloc, SearchState>(
            buildWhen: (previous, current) =>
                previous.selectedType != current.selectedType,
            builder: (context, state) {
              final isSelected = state.selectedType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<SearchBloc>().add(FilterByTypeEvent(type));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
