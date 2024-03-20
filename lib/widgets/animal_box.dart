// ignore_for_file: must_be_immutable

import 'package:aumigos_da_vizinhanca/exports/widgets.dart';
import 'package:aumigos_da_vizinhanca/widgets/text_styles.dart';
import 'package:flutter/material.dart';

class AnimalBox extends StatelessWidget {
  String image, animalName, ownerName, street;
  bool wasFed;

  AnimalBox({
    required this.image,
    required this.animalName,
    required this.ownerName,
    required this.street,
    required this.wasFed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 200,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Image.network(
              image,
              width: 50,
              height: 50,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      animalName,
                      style: TextStyles.textStyle(
                        fontColor: ComponentColors.mainBlack,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: wasFed ? Colors.green : Colors.red,
                    )
                  ],
                ),
                Text(
                  ownerName,
                  style: TextStyles.textStyle(
                    fontColor: ComponentColors.mainGray,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  street,
                  style: TextStyles.textStyle(
                    fontColor: ComponentColors.mainGray,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
