import '../enums/images_enum.dart';

extension ImagesEnumExtension on ImagesEnum {
  static const imagesNames = {
      ImagesEnum.catFed: "images/aumigos_da_vizinhanca_cat_fed.png",
      ImagesEnum.catNotFed: "images/aumigos_da_vizinhanca_cat_not_fed.png",
      ImagesEnum.catMainYellow:
          "images/aumigos_da_vizinhanca_cat_main_yellow.png",
      ImagesEnum.catSweetBrown:
          "images/aumigos_da_vizinhanca_cat_sweet_brown.png",
      ImagesEnum.fed: "images/aumigos_da_vizinhanca_fed.png",
      ImagesEnum.notFed: "images/aumigos_da_vizinhanca_not_fed.png",
      ImagesEnum.logoFed: "images/aumigos_da_vizinhanca_logo_fed.png",
      ImagesEnum.logoNotFed: "images/aumigos_da_vizinhanca_logo_not_fed.png",
      ImagesEnum.logoMainYellow:
          "images/aumigos_da_vizinhanca_logo_main_yellow.png",
      ImagesEnum.logoSweetBrown:
          "images/aumigos_da_vizinhanca_logo_sweet_brown.png",
      ImagesEnum.logoNetworkError:
          "images/aumigos_da_vizinhanca_cat_network_error.png",
      ImagesEnum.logoWhite: "images/aumigos_da_vizinhanca_logo_white.png",
    };

  String get imageName => imagesNames[this] ?? '';
  
}
