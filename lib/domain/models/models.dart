class DataObject {
  double latitude;
  double longitude;
  String msg;

  DataObject(this.latitude, this.longitude, this.msg);

  @override
  bool operator ==(other) =>
      other is DataObject &&
      (other.latitude == latitude &&
          other.longitude == longitude &&
          other.msg == msg);

  @override
  int get hashCode => Object.hash(latitude, longitude, msg);
}

class PhoneID {
  String id;
  PhoneID(this.id);
  static String partnerID = "";
}

class MainData {
  final double latitude;
  final double longitude;
  final double distance;
  final double angle;
  final String partnerMsg;
  String localMsg;
  MainData({
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.angle,
    required this.partnerMsg,
    required this.localMsg,
  });
}
