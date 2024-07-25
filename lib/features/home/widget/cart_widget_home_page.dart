import 'package:flutter/material.dart';
import 'package:flutter_almirtech_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_almirtech_ecommerce/features/category/view/all_category_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/notification/provider/notification_provider.dart';
import 'package:flutter_almirtech_ecommerce/utill/color_resources.dart';
import 'package:flutter_almirtech_ecommerce/utill/custom_themes.dart';
import 'package:flutter_almirtech_ecommerce/utill/dimensions.dart';
import 'package:flutter_almirtech_ecommerce/utill/images.dart';
import 'package:flutter_almirtech_ecommerce/features/cart/views/cart_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/notification/view/notification_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CartWidgetHomePage extends StatelessWidget {
  const CartWidgetHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Consumer<NotificationProvider>(
            builder: (context, notificationProvider, _) {
          return InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationScreen())),
            child: Stack(clipBehavior: Clip.none, children: [
              Image.asset(Images.notification,
                  height: Dimensions.iconSizeDefault,
                  width: Dimensions.iconSizeDefault,
                  color: ColorResources.getPrimary(context)),
              Positioned(
                top: -4,
                right: -4,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: ColorResources.red,
                  child: Text(
                      notificationProvider
                              .notificationModel?.newNotificationItem
                              .toString() ??
                          '0',
                      style: titilliumSemiBold.copyWith(
                        color: ColorResources.white,
                        fontSize: Dimensions.fontSizeExtraSmall,
                      )),
                ),
              ),
            ]),
          );
        }),
        IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          icon: Stack(clipBehavior: Clip.none, children: [
            Image.asset(Images.cartArrowDownImage,
                height: Dimensions.iconSizeDefault,
                width: Dimensions.iconSizeDefault,
                color: ColorResources.getPrimary(context)),
            Positioned(
              top: -4,
              right: -4,
              child:
              Consumer<CartController>(builder: (context, cart, child) {
                return CircleAvatar(
                  radius: 7,
                  backgroundColor: ColorResources.red,
                  child: Text(cart.cartList.length.toString(),
                      style: titilliumSemiBold.copyWith(
                        color: ColorResources.white,
                        fontSize: Dimensions.fontSizeExtraSmall,
                      )),
                );
              }),
            ),
          ]),
        ),

        InkWell(
          onTap: () => facebook("https://www.instagram.com/ozcan_brands?utm_source=qr&igsh=a3pvZW1mMmlzajdm"),
          child: Image.asset(
            Images.instagramImage,
            height: Dimensions.iconSizeDefault,
            width: Dimensions.iconSizeDefault,
          ),
        ),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          onPressed: () =>  whatsapp('+9647744555500'),
          icon: Image.asset(
            Images.whatsappImage,
            height: Dimensions.iconSizeDefault,
            width: Dimensions.iconSizeDefault,
          ),
        ),
      ],
    );
  }
  whatsapp(String phone) async {
    await launchUrlString("whatsapp://send?phone=$phone");
  }

  facebook(url) async {
    await launchUrlString(url);
  }
}
