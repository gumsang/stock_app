abstract class Csvparser<T> {
  Future<List<T>> parse(String csvString);
}
