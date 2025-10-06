enum LoadState {
  idle("Idle"),
  loading("Loading"),
  success("Success"),
  error("Error");

  final String label;
  const LoadState(this.label);

  // 🔎 Quick check getters
  bool get isIdle => this == LoadState.idle;
  bool get isLoading => this == LoadState.loading;
  bool get isSuccess => this == LoadState.success;
  bool get isError => this == LoadState.error;

  // 🔄 Parse from string (safe)
  static LoadState fromString(String value) {
    return LoadState.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => LoadState.idle,
    );
  }

  // 🎯 Maybe useful: pretty print
  @override
  String toString() => label;
}
