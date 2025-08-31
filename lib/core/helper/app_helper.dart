/* 

class AppHelper{
  AppHelper._();

 static Future<void> customSuccessDialog({isDismissible = false, String? topImage, Function()? onRoute, String? title,}) async{
   await Get.dialog(PopScope(
     canPop: isDismissible,
     child: SuccessDialogView(title: title,onRoute: onRoute,topImage: topImage,)),
       barrierDismissible: isDismissible);
  }

  static ColorFilter? svgIconColor([Color? color]){
    if(color == null){return null;}
    return ColorFilter.mode(color, BlendMode.srcIn);
 }

  static SystemUiOverlayStyle homeUiOverlayStyle(){
   return const SystemUiOverlayStyle(
       statusBarColor: Colors.transparent,
       statusBarIconBrightness: Brightness.light,systemNavigationBarColor: Colors.white, systemNavigationBarIconBrightness: Brightness.dark
   );
  }

}


class SuccessDialogView extends StatefulWidget {
  final String? topImage;
  final Function()? onRoute;
  final String? title;
  const SuccessDialogView({super.key, this.topImage, this.onRoute, this.title});

  @override
  State<SuccessDialogView> createState() => _SuccessDialogViewState();
}

class _SuccessDialogViewState extends State<SuccessDialogView> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2),() {
      Get.back();
      widget.onRoute?.call();
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Get.theme.cardColor,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
            SvgPicture.asset(widget.topImage?? Images.loginSuccessImageSvg, width: Get.width*0.4,),

            const SizedBox(height: Dimensions.paddingSize,),
            Text(widget.title??"", textAlign: TextAlign.center, style: textBold.copyWith(color: Get.theme.primaryColor,fontSize: Dimensions.fontSizeOverLarge)),

            const SizedBox(height: Dimensions.paddingSize,),
            Text("pleaseWait".tr, style: textRegular.copyWith(color: Get.theme.colorScheme.onSecondary)),

            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Text("youWillDirectlyHomepage".tr, style: textRegular.copyWith(color: Get.theme.colorScheme.onSecondary)),

            const SizedBox(height: Dimensions.paddingSizeSmall,),

            CircularProgressIndicator(color: Get.theme.primaryColor,strokeCap: StrokeCap.square,strokeWidth: 5,),

            const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
          ],
        ),
      ),
    );
  }
}
 */