import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_flutter_hackathon/logic/search_bloc.dart';

class TypeFilterPicker extends StatelessWidget {
  final List<String> types;
  const TypeFilterPicker({super.key, required this.types});

  // Show the list of Pokemon types from the bottom of the screen
  void _showFilterSheet(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: searchBloc,
        child: _TypeSelectionSheet(types: types),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          
          // Ignore 'All' as a filter
          final activeFilters = state.selectedTypes.where((t) => t.toLowerCase() != 'all').toList();
          final count = activeFilters.length;
          final hasActiveFilters = count > 0;

          return ActionChip(
            avatar: Icon(Icons.filter_list, 
              size: 18, 
              color: hasActiveFilters ? Colors.red : Colors.grey
            ),
            label: Text(hasActiveFilters? "Types ($count)" : "Filter by Type"),
            onPressed: () => _showFilterSheet(context),
          );
        },
      ),
    );
  }
}

class _TypeSelectionSheet extends StatelessWidget {
  final List<String> types;
  const _TypeSelectionSheet({required this.types});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 4, width: 40, 
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))
            ),
          ),
          const Text("Filter by Type", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: types.map((type) {
                  final isSelected = state.selectedTypes.contains(type);
                  return FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (_) {
                      context.read<SearchBloc>().add(FilterByTypeEvent(type));
                    },
                    selectedColor: Colors.redAccent.withOpacity(0.2),
                    checkmarkColor: Colors.red,
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}