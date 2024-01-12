class ApiManager {
  Future<List<int>> fetchNumbers() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(10, (index) => index);
  }
}
