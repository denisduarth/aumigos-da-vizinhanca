import 'package:aumigos_da_vizinhanca/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

import '../exports/widgets.dart';

class AppBarWidget {
  static PreferredSizeWidget showAppBar(BuildContext context, String title) {
    final hasConnection = context.hasConnection;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(
            50,
          ),
        ),
      ),
      shadowColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      elevation: 4.0,
      backgroundColor: !hasConnection ? Colors.red : ComponentColors.sweetBrown,
      centerTitle: true,
      title: !hasConnection
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Tentando reconectar",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$title    ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Image.asset(
                  'images/aumigos_da_vizinhanca_logo_white.png',
                  width: 40,
                  height: 40,
                )
              ],
            ),
    );
  }
}
