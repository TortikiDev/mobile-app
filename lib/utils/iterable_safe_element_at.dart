extension SafeElementAt<E> on Iterable<E> {
  E? safeElementAt(int index) {
    try {
      return elementAt(index);
    // ignore: avoid_catching_errors
    } on RangeError catch (_) {
      return null;
    }
  }
}