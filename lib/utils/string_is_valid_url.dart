extension StringIsValidUrl on String {
  bool isValidUrl() {
    final urlPattern =
        r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    final match = RegExp(urlPattern, caseSensitive: false).firstMatch(this);
    return match != null;
  }
}
