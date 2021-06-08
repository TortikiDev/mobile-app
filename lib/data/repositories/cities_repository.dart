// TODO: inject secret local storage client and make real data requests
class CitiesRepository {
  Future<List<String>> getCities() async =>
      Future.delayed(Duration(seconds: 2)).then(
        (value) => [
          'Санкт-Петербург',
          'Москва',
          'Рязань',
        ],
      );
}
