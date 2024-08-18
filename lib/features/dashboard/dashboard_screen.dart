import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/custom_image.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/title_row.dart';
import 'package:flutter_almirtech_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_almirtech_ecommerce/features/category/view/all_category_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/category/widget/category_view.dart';
import 'package:flutter_almirtech_ecommerce/features/product/view/brand_and_category_product_screen.dart';
import 'package:flutter_almirtech_ecommerce/helper/network_info.dart';
import 'package:flutter_almirtech_ecommerce/features/splash/provider/splash_provider.dart';
import 'package:flutter_almirtech_ecommerce/utill/color_resources.dart';
import 'package:flutter_almirtech_ecommerce/utill/custom_themes.dart';
import 'package:flutter_almirtech_ecommerce/utill/dimensions.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/custom_exit_card.dart';
import 'package:flutter_almirtech_ecommerce/features/chat/view/inbox_screen.dart';
import 'package:flutter_almirtech_ecommerce/localization/language_constrants.dart';
import 'package:flutter_almirtech_ecommerce/utill/images.dart';
import 'package:flutter_almirtech_ecommerce/features/home/view/home_screens.dart';
import 'package:flutter_almirtech_ecommerce/features/more/more_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/order/view/order_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  int _pageIndex = 0;
  late List<NavigationModel> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .businessMode ==
        "single";

    _screens = [
      NavigationModel(
          name: 'home', icon: Images.homeImage, screen: const HomePageNew()),
      NavigationModel(
          name: 'Categories',
          icon: Images.category,
          screen: const CategoryView()),
      if (!singleVendor)
        NavigationModel(
            name: 'inbox',
            icon: Images.messageImage,
            screen: const InboxScreen(isBackButtonExist: false)),
      NavigationModel(
          name: 'orders',
          icon: Images.shoppingImage,
          screen: const OrderScreen(isBacButtonExist: false)),
      NavigationModel(
          name: 'more', icon: Images.moreImage, screen: const MoreScreen()),
    ];

    NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (val) async {
        if (_pageIndex != 0) {
          _setPage(0);
          return;
        } else {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (_) => const CustomExitCard());
        }
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: PageStorage(bucket: bucket, child: _screens[_pageIndex].screen),
        bottomNavigationBar: Container(
          height: 65,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Dimensions.paddingSizeLarge)),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                  spreadRadius: 1,
                  color: Theme.of(context).primaryColor.withOpacity(.125))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _getBottomWidget(singleVendor),
          ),
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  List<Widget> _getBottomWidget(bool isSingleVendor) {
    List<Widget> list = [];
    for (int index = 0; index < _screens.length; index++) {
      list.add(Expanded(
          child: CustomMenuItem(
        isSelected: _pageIndex == index,
        name: _screens[index].name,
        icon: _screens[index].icon,
        onTap: () => _setPage(index),
      )));
    }
    return list;
  }
}

class CustomMenuItem extends StatelessWidget {
  final bool isSelected;
  final String name;
  final String icon;
  final VoidCallback onTap;

  const CustomMenuItem({
    super.key,
    required this.isSelected,
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: SizedBox(
            width: isSelected ? 90 : 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(icon,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).hintColor,
                    width: Dimensions.menuIconSize,
                    height: Dimensions.menuIconSize),
                isSelected
                    ? Text(getTranslated(name, context)!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textBold.copyWith(
                            color: Theme.of(context).primaryColor))
                    : Text(getTranslated(name, context)!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textRegular.copyWith(
                            color: Theme.of(context).hintColor)),
                if (isSelected)
                  Container(
                    width: 5,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeDefault)),
                  )
              ],
            )),
      ),
    );
  }
}

class NavigationModel {
  String name;
  String icon;
  Widget screen;
  NavigationModel(
      {required this.name, required this.icon, required this.screen});
}

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<CategoryController>(
                builder: (context, categoryController, _) {
              return (categoryController.categoryList != null &&
                      categoryController.categoryList!.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge,
                            ),
                            child: Text(
                              getTranslated('choose_category', context)
                                  .toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .85,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount:
                                  categoryController.categoryList!.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BrandAndCategoryProductScreen(
                                                    isBrand: false,
                                                    category: categoryController
                                                        .categoryList![index]
                                                        .slug
                                                        .toString()
                                                        .toUpperCase(),
                                                    id: categoryController
                                                        .categoryList![index].id
                                                        .toString(),
                                                    name: categoryController
                                                        .categoryList![index]
                                                        .name,
                                                  )));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .17,
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].icon}'),
                                      ),
                                    ));
                              },
                            ),
                          )
                        ],
                      ))
                  : Shimmer.fromColors(
                      child: SizedBox(
                          height: 500,
                          child:
                              ListView.builder(itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * .35,
                            );
                          })),
                      baseColor: Theme.of(context).cardColor,
                      highlightColor: Colors.grey[300]!,
                      enabled: true,
                    );
            })
          ],
        ),
      )),
    );
  }
}
