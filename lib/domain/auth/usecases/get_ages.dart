class GetAgesUseCase {
  Future<List<String>> call() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const ['18-24', '25-34', '35-44', '45+'];
  }
}
