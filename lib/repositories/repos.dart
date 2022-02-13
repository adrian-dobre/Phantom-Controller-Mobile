import 'package:phantom_controller/repositories/phantom_repository.dart';

class Repos {
  static PhantomRepository? phantomRepository;

  static init(String controllerAddress, String controllerAccessKey) {
    phantomRepository = PhantomRepository(
        address: controllerAddress, accessKey: controllerAccessKey);
  }

  static reset() {
    phantomRepository = null;
  }
}
