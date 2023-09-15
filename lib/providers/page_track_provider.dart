import 'package:flutter/material.dart';

abstract class PageTrackProvider extends ChangeNotifier {
  /// Vraca selektovani index
  int get selectedIndex;

  /// Postavi predji na odredjenu tacku
  void setCurrentPage(int pageNumber);
}

class PageTracker extends PageTrackProvider {
  int _selectedIndex = 0;
  final _pageController = PageController();

  @override
  int get selectedIndex => _selectedIndex;

  get pageController => _pageController;

  @override
  setCurrentPage(int pageNumber) {
    _selectedIndex = pageNumber;
    _animateToPage(_selectedIndex);
    notifyListeners();
  }

  // inner methods
  _animateToPage(int pageNumber) {
    _pageController.animateToPage(_selectedIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
