extension IpString on String {
  bool isSameSegment(String other) {
    final List<String> serverAddressList = split('.');
    final List<String> localAddressList = other.split('.');
    if (serverAddressList[0] == localAddressList[0] &&
        serverAddressList[1] == localAddressList[1] &&
        serverAddressList[2] == localAddressList[2]) {
      // 默认为前三个ip段相同代表在同一个局域网，可能更复杂，涉及到网关之类的，由这学期学的计算机网路来看
      return true;
    }
    return false;
  }
}
