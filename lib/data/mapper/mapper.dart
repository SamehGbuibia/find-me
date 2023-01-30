import 'package:independet/data/responses/responses.dart';
import 'package:independet/domain/models/models.dart';
import 'package:independet/app/extensions.dart';

extension DataResponseMapper on DataResponse? {
  DataObject toDomain() {
    return DataObject(
      this?.latitude.orZeroDouble() ?? 0.0,
      this?.longitude.orZeroDouble() ?? 0.0,
      this?.msg.orEmpty() ?? "",
    );
  }
}
