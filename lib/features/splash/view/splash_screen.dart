import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almirtech_ecommerce/localization/language_constrants.dart';
import 'package:flutter_almirtech_ecommerce/push_notification/model/notification_body.dart';
import 'package:flutter_almirtech_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_almirtech_ecommerce/features/splash/provider/splash_provider.dart';
import 'package:flutter_almirtech_ecommerce/utill/app_constants.dart';
import 'package:flutter_almirtech_ecommerce/utill/color_resources.dart';
import 'package:flutter_almirtech_ecommerce/utill/custom_themes.dart';
import 'package:flutter_almirtech_ecommerce/utill/dimensions.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/no_internet_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/chat/view/inbox_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/dashboard/dashboard_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/maintenance/maintenance_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/notification/view/notification_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/onboarding/view/onboarding_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/order/view/order_details_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({super.key, this.body});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  late AnimationController _animationController;
  late Animation<double> _animation;

  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation =
        Tween<double>(begin: 0.0, end: .8).animate(_animationController);
    _animationController.forward();
    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: isNotConnected ? Colors.red : Colors.green,
            duration: Duration(seconds: isNotConnected ? 6000 : 3),
            content: Text(
                isNotConnected
                    ? getTranslated('no_connection', context)!
                    : getTranslated('connected', context)!,
                textAlign: TextAlign.center)));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
    _animationController.dispose();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        Provider.of<SplashProvider>(context, listen: false)
            .initSharedPrefData();
        Timer(const Duration(seconds: 3), () {
          if (Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .maintenanceMode!) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const MaintenanceScreen()));
          } else if (Provider.of<AuthController>(context, listen: false)
              .isLoggedIn()) {
            Provider.of<AuthController>(context, listen: false)
                .updateToken(context);
            if (widget.body != null) {
              if (widget.body!.type == 'order') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        OrderDetailsScreen(orderId: widget.body!.orderId)));
              } else if (widget.body!.type == 'notification') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const NotificationScreen()));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const InboxScreen(
                          isBackButtonExist: true,
                        )));
              }
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            }
          } else if (Provider.of<SplashProvider>(context, listen: false)
              .showIntro()!) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => OnBoardingScreen(
                    indicatorColor: ColorResources.grey,
                    selectedIndicatorColor: Theme.of(context).primaryColor)));
          } else {
            if (Provider.of<AuthController>(context, listen: false)
                        .getGuestToken() !=
                    null &&
                Provider.of<AuthController>(context, listen: false)
                        .getGuestToken() !=
                    '1') {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Provider.of<SplashProvider>(context).hasConnection
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                        width: 700,
                        child: Column(
                          children: [
                            Center(
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return ClipRect(
                                    child: Align(
                                      alignment: Alignment.center,
                                      widthFactor: _animation.value,
                                      child: Image.asset(
                                        "assets/images/logo_splash.png",
                                        width: 600,
                                      ), // replace with your logo
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            LoadingAnimationWidget.hexagonDots(
                              color: Colors.black,
                              size: 30,
                            ),
                          ],
                        )),
                    Text(AppConstants.appName,
                        style: textRegular.copyWith(
                            fontSize: 35, color: Colors.white)),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: Dimensions.paddingSizeSmall),
                        child: Text(AppConstants.slogan,
                            style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Colors.white)))
                  ]),
                )
              : const NoInternetOrDataScreen(
                  isNoInternet: true, child: SplashScreen()),
        ],
      ),
    );
  }
}
