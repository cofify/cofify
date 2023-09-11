import 'package:flutter/material.dart';

abstract class SearchProvider extends ChangeNotifier {
  /// Text po kome se filtrira
  String get searchQuery;

  // Index odabranog elementa u NEfiltriranoj listi
  int get selectedIndex;
  List<String> get filterItemsList;

  /// Vraca filtriranu listu
  List<String> get filteredList;

  /// Index odabranog elementa u filtriranoj podlisti
  int getCurrentIndex();

  /// Updatuje filtriranu listu
  void updateSearchQuery(String query);

  /// Brise sadrzaj searchQuerija
  void clearSearchQuery();

  /// Postavljanje odabranog indexa
  void setSelectedIndex(int index);
}

class ChooseCityDataProvider extends SearchProvider {
  String _searchQuery = '';
  List<String> _filteredList = [];
  int _selectedIndex = 0;
  final List<String> _filterItemsList = [
    'Beograd',
    'Bor',
    'Valjevo',
    'Vranje',
    'Vršac',
    'Zaječar',
    'Zrenjanin',
    'Jagodina',
    'Kikinda',
    'Kragujevac',
    'Kraljevo',
    'Kruševac',
    'Leskovac',
    'Loznica',
    'Niš',
    'Novi Pazar',
    'Novi Sad',
    'Pančevo',
    'Pirot',
    'Požarevac',
    'Priština',
    'Prokuplje',
    'Smederevo',
    'Sombor',
    'Sremska Mitrovica',
    'Subotica',
    'Užice',
    'Čačak',
    'Šabac',
  ];

  @override
  int get selectedIndex => _selectedIndex;

  @override
  String get searchQuery => _searchQuery;

  @override
  List<String> get filterItemsList => _filterItemsList;

  @override
  get filteredList {
    if (_searchQuery == '') {
      _filteredList = _filterItemsList;
    }

    return _filteredList;
  }

  @override
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterTheList();
    notifyListeners();
  }

  @override
  clearSearchQuery() {
    _searchQuery = '';
    _filterTheList();
    notifyListeners();
  }

  // dobijem index iz filterovanu listu, ali mi treba index u city listu
  @override
  void setSelectedIndex(int index) {
    _selectedIndex = _filterItemsList.indexOf(_filteredList[index]);
    notifyListeners();
  }

  @override
  int getCurrentIndex() {
    int index = _filteredList.indexOf(_filterItemsList[selectedIndex]);
    return index;
  }

  void _filterTheList() {
    _filteredList = _filterItemsList.where((element) {
      return element.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }
}
