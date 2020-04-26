import 'package:flutter/material.dart';

class DesignFunctions {
  static ShapeBorder selectedCardDesign() {
    return RoundedRectangleBorder(
        side: new BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(4.0));
  }

  static ShapeBorder unSelectedCardDesign() {
    return RoundedRectangleBorder(
        side: new BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(4.0));
  }

  static String getCompanyImage(int organizationId) {
    switch (organizationId) {
      case 1:
        return "images/company_logos/360logica_logo.png";
        break;
      case 2:
        return "images/company_logos/acuma_logo.png";
        break;
      case 3:
        return "images/company_logos/dreamorbit_logo.png";
        break;
      case 4:
        return "images/company_logos/edp_logo.png";
        break;
      case 5:
        return "images/company_logos/faich_logo.png";
        break;
      default:
        return "images/logo.png";
    }
  }

  static Container appBarBackground() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.green, Colors.greenAccent])),
    );
  }
}
