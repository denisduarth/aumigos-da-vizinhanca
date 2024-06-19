import 'package:aumigos_da_vizinhanca/src/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:flutter/material.dart';

const mainTextStyle = TextStyle(
  color: ComponentColors.mainBlack,
  fontFamily: "Poppins",
  wordSpacing: -1,
  fontSize: 29,
  fontWeight: FontWeight.w900,
);

class LocationErrorPage extends StatefulWidget {
  const LocationErrorPage({super.key});

  @override
  State<LocationErrorPage> createState() => _LocationErrorPageState();
}

class _LocationErrorPageState extends State<LocationErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 75.0),
          child: Center(
            child: Container(
              alignment: AlignmentDirectional.center,
              width: context.screenWidth,
              height: 350,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off_rounded,
                    color: Colors.red,
                    size: 100.0,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.spaceEvenly,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      Text("Erro de Localização",
                          textAlign: TextAlign.center, style: mainTextStyle),
                    ],
                  ),
                  Text(
                    "Sua localização está desativada. Verifique se seu servico de localização está ligado",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: ComponentColors.mainGray,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
