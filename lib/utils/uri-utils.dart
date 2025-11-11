Uri buildUri(String baseUrl, String endpoint, [Map<String, dynamic>? params]) {
  return Uri.parse(baseUrl).replace(
    path: endpoint,
    queryParameters: params?.map((key, value) => MapEntry(key, value.toString())),
  );
}
