part of '../../messages.dart';

class ErrorResponse extends MandrillResponse {
  String? status;
  int? code;
  String? name;
  String? message;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    status = object.decode('status');
    code = object.decode('code');
    name = object.decode('name');
    message = object.decode('message');
  }
}
