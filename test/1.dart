void main() {
  Future<dynamic> value = Future.value(true);
  // Future<bool> value2 = value;
  Future<bool> value2 = getW(value);
  print(value2.runtimeType);

}

Future<bool> getW(Future future) async {
  dynamic a = await future;
  return a as bool;
}
