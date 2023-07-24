import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'custom_from_cubit_state.dart';

class CustomFromCubitCubit extends Cubit<CustomFromCubitState> {
  CustomFromCubitCubit() : super(CustomFromCubitInitial());

  PageController pageController = PageController();
  int currentPage = 0;

  void goToNextPage({required List<Widget> widgetGroup}) {
    if (currentPage < widgetGroup.length - 1) {
      currentPage++;
      emit(GoToNextPageState());
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      currentPage--;
      emit(GoToNextPageState());
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    
    }
  }
}
