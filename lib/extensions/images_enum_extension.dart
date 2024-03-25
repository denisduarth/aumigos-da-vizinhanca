import 'package:aumigos_da_vizinhanca/enums/images_enum.dart';

extension ImagesEnumExtension on ImagesEnum {
  String get getImage {
    switch (this) {
      case ImagesEnum.catFed:
        return 'images/aumigos_da_vizinhanca_cat_fed.png';
      case ImagesEnum.catNotFed:
        return 'images/aumigos_da_vizinhanca_cat_not_fed.png';
      case ImagesEnum.catMainYellow:
       return 'images/aumigos_da_vizinhanca_cat_main_yellow.png';
      case ImagesEnum.catSweetBrown:
       return 'images/aumigos_da_vizinhanca_cat_sweet_brown.png';
      case ImagesEnum.fed:
       return 'images/aumigos_da_vizinhanca_fed.png';
      case ImagesEnum.notFed:
       return 'images/aumigos_da_vizinhanca_not_fed.png';
      case ImagesEnum.logoFed:
       return 'images/aumigos_da_vizinhanca_logo_fed.png';
      case ImagesEnum.logoNotFed:
       return 'images/aumigos_da_vizinhanca_logo_not_fed.png';
      case ImagesEnum.logoMainYellow:
       return 'images/aumigos_da_vizinhanca_logo_main_yellow.png';
      case ImagesEnum.logoSweetBrown:
       return 'images/aumigos_da_vizinhanca_logo_sweet_brown.png';
      case ImagesEnum.logoNetworkError:
       return 'images/aumigos_da_vizinhanca_logo_network_error.png';
      case ImagesEnum.logoWhite:
       return 'images/aumigos_da_vizinhanca_logo_white.png';
      default:
        return '';
    }
  }
}
