import 'package:flutter/material.dart';
import 'package:pagination_example/api.dart';

enum UiState {
  fetching,
  fetched,
  error,
  noData,
}

enum PaginationState {
  fetching,
  fetched,
  noDataLeft,
}

class StateProvider extends ChangeNotifier {
  final ApiManager _apiManager = ApiManager();
  final List<int> _myList = [];
  int maxPages = 5;
  int count = 1;
  List<int> get list => _myList;
  UiState uiState = UiState.fetching;
  PaginationState paginationState = PaginationState.fetched;

  Future<void> fetchData(bool initialFetch) async {
    if (!initialFetch) {
      count++;
      if (count >= maxPages) {
        paginationState = PaginationState.noDataLeft;
      } else {
        paginationState = PaginationState.fetching;
      }
      notifyListeners();
    }
    _apiManager
        .fetchNumbers()
        .then((value) {
          _myList.addAll(value);
          uiState = UiState.fetched;
          if (count < maxPages) {
            paginationState = PaginationState.fetched;
          } else {
            paginationState = PaginationState.noDataLeft;
          }
        })
        .onError((error, stackTrace) => null)
        .whenComplete(() {
          notifyListeners();
        });
  }
}
