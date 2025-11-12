extension StringExtension on String {
  String toCapitalize() {
    if (isEmpty) {
      return this;
    }
    return split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }

  /// Remove espaços extras no início, fim e entre palavras
  String trim() {
    return this.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
