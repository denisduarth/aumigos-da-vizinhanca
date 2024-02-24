import 'package:aumigos_da_vizinhanca/widgets/colors.dart';
import 'package:flutter/material.dart';

const mainTextStyle = TextStyle(
  color: ComponentColors.mainBlack,
  fontFamily: "Poppins",
  wordSpacing: -1,
  fontSize: 29,
  fontWeight: FontWeight.w900,
);

class NetworkErrorPage extends StatefulWidget {
  const NetworkErrorPage({super.key});

  @override
  State<NetworkErrorPage> createState() => _NetworkErrorPageState();
}

class _NetworkErrorPageState extends State<NetworkErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 75.0),
          child: Center(
            child: Container(
              alignment: AlignmentDirectional.center,
              width: MediaQuery.of(context).size.width,
              height: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/aumigos_da_vizinhanca_logo_network_error.png',
                    width: 100,
                    height: 100,
                  ),
                  const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.spaceEvenly,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      Text("Erro de Conexão",
                          textAlign: TextAlign.center, style: mainTextStyle),
                      Text("com a Internet  ",
                          textAlign: TextAlign.center, style: mainTextStyle),
                      Icon(
                        Icons.signal_wifi_off_rounded,
                        color: Colors.red,
                        size: 25,
                      ),
                    ],
                  ),
                  const Text(
                    "Parece que você está sem internet no momento. Verifique sua conexão ou tente novamente mais tarde",
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
