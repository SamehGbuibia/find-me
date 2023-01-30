import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:independet/app/di.dart';
import 'package:independet/data/responses/responses.dart';
import 'package:independet/domain/models/models.dart';

class AppServiceClient {
  final String id = instance<PhoneID>().id;
  Future<DataResponse> getData() async {
    final collection = _getFireBaseCollection();
    final doc = await _getFireBasePartnerDoc(collection, id);
    final json = _getPartnerData(doc);
    return DataResponse.fromJson(json);
  }

  Future<DataResponse> setData(String msg) async {
    final collection = _getFireBaseCollection();
    final doc = _getFireBaseDirectionDoc(collection, id);
    final Position position = await _getPosition();
    final data = DataResponse(position.latitude, position.longitude, msg);
    await doc.set(data.toJson());
    return data;
  }

  Future<DataResponse> upDatePosition() async {
    final collection = _getFireBaseCollection();
    final doc = _getFireBaseDirectionDoc(collection, id);
    final Position position = await _getPosition();
    await doc.update({
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
    return DataResponse(position.latitude, position.longitude, "");
  }

  Future<bool> isIdExist(String id) async {
    final collection = _getFireBaseCollection();
    final docs = await collection.get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> element in docs.docs) {
      if (element.id == id) {
        return true;
      }
    }
    return false;
  }

  //private functions

  CollectionReference<Map<String, dynamic>> _getFireBaseCollection() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection('start');
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> _getFireBasePartnerDoc(
      CollectionReference<Map<String, dynamic>> collection, String id) async {
    final docs = await collection.get();
    final QueryDocumentSnapshot<Map<String, dynamic>> doc =
        docs.docs.firstWhere((element) {
      return element.id == PhoneID.partnerID;
    });
    return doc;
  }

  Map<String, dynamic> _getPartnerData(
          QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
      doc.data();

  DocumentReference<Map<String, dynamic>> _getFireBaseDirectionDoc(
          CollectionReference<Map<String, dynamic>> collection, String id) =>
      collection.doc(id);

  Future<Position> _getPosition() async =>
      await Geolocator.getCurrentPosition();
}
