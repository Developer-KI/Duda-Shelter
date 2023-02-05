// ignore_for_file: file_names

import 'dart:convert';

import 'package:duda_shelter/pages/Main/CongratulationsPage.dart';
import 'package:duda_shelter/pages/Main/ProfilePage.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:duda_shelter/widgets/our_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

enum DonationSum { ten, twenty, fifty, hundred, thousand }

class OurDonatePage extends StatefulWidget {
  final VoidCallback openDrawer;

  const OurDonatePage({
    super.key,
    required this.openDrawer,
  });

  @override
  State<OurDonatePage> createState() => _OurDonatePageState();
}

class _OurDonatePageState extends State<OurDonatePage> {
  DonationSum selectedSum = DonationSum.ten;

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(String amount, String currency) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);

      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Colors.white,
              primary: ourPrimaryColor,
              componentBorder: Colors.black,
            ),
            shapes: PaymentSheetShape(
              borderRadius: 15,
              borderWidth: 2,
              shadow: PaymentSheetShadowParams(color: Colors.black),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: ourPrimaryColor,
                  text: Colors.white,
                  border: ourPrimaryColor,
                ),
              ),
            ),
          ),
          customFlow: true,
          merchantDisplayName: "DUDA_SHELTER",
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralkey'],
        ));
      }

      displayPaymentSheet();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Error during payment!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51MYDhoHkiOfBM7yo1gjfS7Zf9dvpwjabtAsSvCPXC3pRmMnJB4efht4tOrHBXqvYAU23XuV4jKNQfRh0s89B7xue00h0ctWbtr',
            'Content_Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Error during payment!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await Stripe.instance.confirmPaymentSheetPayment().then((value) {
        Navigator.of(context).pop();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const OurCongratulations(),
          ),
        );
      });
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Error during payment!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget customRadioButton(String text, DonationSum type) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          selectedSum = type;
        });
      }),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width * 0.275,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                selectedSum == type ? Colors.blue.shade600 : Colors.transparent,
          ),
          color: selectedSum == type ? Colors.blue[100] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 7,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedSum == type ? Colors.blue[600] : Colors.grey,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeigth = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            elevation: 2,
            forceElevated: true,
            backgroundColor: Colors.white,
            leading: OurDrawerMenuWidget(
              onClicked: widget.openDrawer,
            ),
            centerTitle: true,
            title: const Text(
              "D U D A   S H E L T E R",
              style: TextStyle(color: Colors.black),
            ),
            expandedHeight: deviceHeigth * 0.25,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: deviceHeigth * 0.075,
                    width: deviceHeigth * 0.075,
                    decoration: BoxDecoration(
                      color: ourPrimaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Icon(
                      FontAwesomeIcons.shieldDog,
                      color: Colors.white,
                      size: deviceHeigth * 0.04,
                    ),
                  ),
                  SizedBox(height: deviceHeigth * 0.03),
                  const Text(
                    "Make a Secure Donation",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: deviceHeigth * 0.03),
                ],
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OurProfilePage(),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromRGBO(223, 190, 140, 1),
                        border: Border.all(color: Colors.black, width: 1.3)),
                    child: const Icon(
                      FontAwesomeIcons.solidUser,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.05,
                vertical: deviceHeigth * 0.075,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: customRadioButton("10 лв", DonationSum.ten),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: customRadioButton("20 лв", DonationSum.twenty),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceHeigth * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: customRadioButton("50 лв", DonationSum.fifty),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: customRadioButton("100 лв", DonationSum.hundred),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceHeigth * 0.03),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSum = DonationSum.thousand;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: deviceHeigth * 0.1,
                      decoration: BoxDecoration(
                        color: selectedSum == DonationSum.thousand
                            ? Colors.blue[100]
                            : Colors.white,
                        border: Border.all(
                          color: selectedSum == DonationSum.thousand
                              ? Colors.blue.shade600
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                        "1000 лв",
                        style: TextStyle(
                          color: selectedSum == DonationSum.thousand
                              ? Colors.blue[600]
                              : Colors.grey,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeigth * 0.075),
                  GestureDetector(
                    onTap: (() async {
                      String sumAmount;

                      switch (selectedSum) {
                        case DonationSum.ten:
                          sumAmount = "1000";
                          break;
                        case DonationSum.twenty:
                          sumAmount = "2000";
                          break;
                        case DonationSum.fifty:
                          sumAmount = "5000";
                          break;
                        case DonationSum.hundred:
                          sumAmount = "10000";
                          break;
                        case DonationSum.thousand:
                          sumAmount = "100000";
                          break;
                      }

                      await makePayment(sumAmount, 'BGN');
                    }),
                    child: Container(
                      alignment: Alignment.center,
                      height: deviceHeigth * 0.125,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Text(
                        "Donate",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeigth * 0.04),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: deviceHeigth * 0.075,
                    color: Colors.transparent,
                    child: const Text(
                      "We are a self-funded organisation of dog enthusiasts and we would very much appreciate your support!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
