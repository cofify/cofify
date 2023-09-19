import 'package:flutter/material.dart';

abstract class PageTrackProviders extends ChangeNotifier {
  /// Vraca selektovani index
  int get selectedIndex;

  /// Postavi predji na odredjenu tacku
  void setCurrentPage(int pageNumber);
  void setCurrentPageDontNotifySelf(int pageNumber);
}

class PageTracker extends PageTrackProviders {
  int _selectedIndex = 0;
  final _pageController = PageController();

  @override
  int get selectedIndex => _selectedIndex;

  get pageController => _pageController;

  @override
  setCurrentPage(int pageNumber) {
    if (_selectedIndex == pageNumber) return;
    _selectedIndex = pageNumber;
    _animateToPage(_selectedIndex);
    notifyListeners();
  }

  @override
  setCurrentPageDontNotifySelf(int pageNumber) {
    if (_selectedIndex == pageNumber) return;
    _selectedIndex = pageNumber;
    notifyListeners();
  }

  // inner methods
  _animateToPage(int pageNumber) {
    _pageController.animateToPage(
      _selectedIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}

class PillButtonPageTracker extends PageTrackProviders {
  int _selectedIndex = 1;
  final _pageController = PageController(initialPage: 1);

  @override
  int get selectedIndex => _selectedIndex;

  get pageController => _pageController;

  @override
  setCurrentPage(int pageNumber) {
    if (_selectedIndex == pageNumber) return;
    _selectedIndex = pageNumber;
    _animateToPage(_selectedIndex);
    notifyListeners();
  }

  @override
  setCurrentPageDontNotifySelf(int pageNumber) {
    if (_selectedIndex == pageNumber) return;
    _selectedIndex = pageNumber;
    notifyListeners();
  }

  // inner methods
  _animateToPage(int pageNumber) {
    _pageController.animateToPage(_selectedIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
