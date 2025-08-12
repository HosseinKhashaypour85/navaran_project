import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);
  int currentIndex = 0;

  changeIndex(int index) {
    emit(currentIndex = index);
  }
}
