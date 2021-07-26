extension IpString on String {
  bool hasThreePartEqual(String other) {
    final List<String> serverAddressList = split('.');
    final List<String> localAddressList = other.split('.');
    if (serverAddressList[0] == localAddressList[0] &&
        serverAddressList[1] == localAddressList[1] &&
        serverAddressList[2] == localAddressList[2]) {
      return true;
    }
    return false;
  }

  bool hasTwoPartEqual(String other) {
    final List<String> serverAddressList = split('.');
    final List<String> localAddressList = other.split('.');
    if (serverAddressList[0] == localAddressList[0] &&
        serverAddressList[1] == localAddressList[1]) {
      return true;
    }
    return false;
  }
}
