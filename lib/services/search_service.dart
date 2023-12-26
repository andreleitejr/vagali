import 'package:vagali/utils/extensions.dart';

class SearchService {
  String clean(String text) => text.clean;

  List<T> filterBySearchText<T>(
      List<T> items, String searchText, List<String> Function(T) properties) {
    final cleanSearchText = clean(searchText);
    if (searchText.isEmpty) {
      return items;
    } else {
      return items.where((item) {
        return properties(item).any((property) {
          return clean(property).contains(cleanSearchText);
        });
      }).toList();
    }
  }
}
