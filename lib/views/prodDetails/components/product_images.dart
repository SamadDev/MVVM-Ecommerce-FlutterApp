import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:ecommerce_app/utils/size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages>
    with TickerProviderStateMixin {
  int selectedImage = 0;
  final TransformationController _transformationController =
      TransformationController();
  Animation<Matrix4> _animationReset;
  AnimationController _controllerReset;

  void _onAnimateReset() {
    _transformationController.value = _animationReset.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_controllerReset);
    _animationReset.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    _animateResetInitialize();
  }

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(40)),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: UniqueKey(),
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                transformationController: _transformationController,
                onInteractionStart: _onInteractionStart,
                onInteractionEnd: _onInteractionEnd,
                child: CachedNetworkImage(
                  imageUrl: widget.product.images[selectedImage].toString(),
                  memCacheHeight: 800,
                  memCacheWidth: 800,
                  maxHeightDiskCache: 800,
                  maxWidthDiskCache: 800,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    width: getProportionateScreenWidth(6),
                    height: getProportionateScreenWidth(6),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        strokeWidth: 5,
                        color: PrimaryLightColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(15)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.product.images.length,
                (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(7),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Color(0xfff6f8f8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: PrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: CachedNetworkImage(
          imageUrl: widget.product.images[index].toString(),
          memCacheHeight: 200,
          memCacheWidth: 200,
          maxHeightDiskCache: 200,
          maxWidthDiskCache: 200,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              SizedBox(
            width: getProportionateScreenWidth(0.1),
            height: getProportionateScreenWidth(0.1),
            child: Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                strokeWidth: 3,
                color: PrimaryLightColor,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
