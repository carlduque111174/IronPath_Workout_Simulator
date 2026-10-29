import 'package:ironpath_workout_simulator/presentation/auth/bloc/age_selection_cubit.dart';
import 'package:ironpath_workout_simulator/presentation/auth/bloc/ages_display_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ages_display_states.dart';

class Ages extends StatelessWidget {
  const Ages({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.7,
      child: BlocBuilder<AgesDisplayCubit, AgesDisplayState>(
        builder: (context, state) {
          if (state is AgesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AgesLoaded) {
            return _ages(state.ages, context);
          }

          if (state is AgesLoadFailure) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _ages(List<String> ages, BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            context.read<AgeSelectionCubit>().selectAge(ages[index]);
          },
          child: Text(ages[index], style: const TextStyle(fontSize: 18)),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: ages.length,
    );
  }
}
