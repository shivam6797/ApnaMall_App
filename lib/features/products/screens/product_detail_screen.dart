import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:apnamall_ecommerce_app/features/cart/bloc/cart_bloc.dart';
import 'package:apnamall_ecommerce_app/features/cart/bloc/cart_state.dart';
import 'package:apnamall_ecommerce_app/features/products/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentIndex = 0;
  int quantity = 1;
  late final CarouselSliderController _carouselController;
  Product? _product;
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_product == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Product) {
        _product = args;
        images = [_product!.image];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartSuccess && state.message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(state.message),
              ),
            );
            context.read<CartBloc>().add(ResetCartMessageEvent());
          }

          if (state is CartFailure && state.error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: Colors.red, content: Text(state.error)),
            );
            context.read<CartBloc>().add(ResetCartMessageEvent());
          }
        },

        child: Stack(
          children: [
            SizedBox(
              height: 340,
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.12,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        CarouselSlider.builder(
                          carouselController: _carouselController,
                          itemCount: images.length,
                          itemBuilder: (context, index, realIndex) {
                            return Image.network(
                              images[index],
                              height: 230,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    "assets/images/product_placeholder.png",
                                  ),
                            );
                          },
                          options: CarouselOptions(
                            height: 210,
                            viewportFraction: 1.1,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(
                              milliseconds: 800,
                            ),
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(images.length, (index) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: _currentIndex == index ? 18 : 8,
                              decoration: BoxDecoration(
                                color: _currentIndex == index
                                    ? Colors.black
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _currentIndex == index
                                      ? Colors.black
                                      : Colors.black54,
                                  width: 1.5,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 16,
                    child: _buildCircleIcon(FontAwesomeIcons.chevronLeft, () {
                      Navigator.pop(context);
                    }),
                  ),
                  Positioned(
                    top: 50,
                    right: 16,
                    child: Row(
                      children: [
                        _buildCircleIcon(Icons.share),
                        SizedBox(width: 10),
                        _buildCircleIcon(Icons.favorite_border),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.52,
              maxChildSize: 0.92,
              builder: (_, controller) {
                return Container(
                  padding: EdgeInsets.only(left: 13, right: 13, top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    controller: controller,
                    children: [
                      Text(
                        _product?.name ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            "₹${_product?.price ?? ''}",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Seller:",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: " Tariqual islam",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 22,
                            width: 55,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffff650e),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, size: 13, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  "4.8",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "(320 Reviews)",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Poppins",
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Color",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          _buildColorDot(Color(0xffff650e)),
                          _buildColorDot(Colors.black),
                          _buildColorDot(Colors.blue),
                          _buildColorDot(Colors.brown),
                          _buildColorDot(Colors.grey),
                        ],
                      ),
                      SizedBox(height: 5),
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 48,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TabBar(
                                indicator: BoxDecoration(
                                  color: Color(0xffff650e),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black87,
                                dividerColor: Colors.transparent,
                                labelStyle: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                ),
                                tabs: const [
                                  Tab(text: "Description"),
                                  Tab(text: "Specifications"),
                                  Tab(text: "Reviews"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 350,
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      "Experience immersive sound with our premium Wireless Headphones. "
                                      "Equipped with advanced noise cancellation, 40mm drivers, and high-fidelity audio. "
                                      "The ergonomic design ensures all-day comfort, while the 20-hour battery life "
                                      "keeps your music going. Whether for calls, gaming, or workouts, these headphones "
                                      "deliver crisp highs, rich mids, and deep bass. Built with durable materials, "
                                      "a foldable structure, and sleek matte finish — perfect for everyday use.",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSpecItem("Brand", "boAt"),
                                      _buildSpecItem("Model", "Rockerz 550"),
                                      _buildSpecItem(
                                        "Type",
                                        "Over-Ear Wireless Headphones",
                                      ),
                                      _buildSpecItem(
                                        "Battery Life",
                                        "Up to 20 Hours",
                                      ),
                                      _buildSpecItem(
                                        "Charging Port",
                                        "USB Type-C",
                                      ),
                                      _buildSpecItem(
                                        "Connectivity",
                                        "Bluetooth v5.2",
                                      ),
                                      _buildSpecItem(
                                        "Features",
                                        "Noise Cancellation, Voice Assistant",
                                      ),
                                      _buildSpecItem("Weight", "190g"),
                                      _buildSpecItem(
                                        "Water Resistance",
                                        "IPX4 Rated",
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildReviewItem(
                                        name: "Aman Sharma",
                                        rating: 5,
                                        comment:
                                            "Sound quality is amazing. Battery easily lasts a day.",
                                      ),
                                      SizedBox(height: 10),
                                      _buildReviewItem(
                                        name: "Priya Verma",
                                        rating: 4,
                                        comment:
                                            "Very comfortable. Mic could be better.",
                                      ),
                                      SizedBox(height: 10),
                                      _buildReviewItem(
                                        name: "Rahul Singh",
                                        rating: 5,
                                        comment:
                                            "Excellent bass and no issues in 3 months.",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            '$quantity',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        bool isLoading = state is CartLoading;
                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_product != null) {
                                    context.read<CartBloc>().add(
                                      AddToCartEvent(
                                        productId: _product!.id,
                                        quantity: quantity,
                                      ),
                                    );
                                    Future.delayed(
                                      Duration(milliseconds: 300),
                                      () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.routeCart,
                                        );
                                      },
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffff650e),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: isLoading
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Adding...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData iconData, [VoidCallback? ontap]) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(iconData, size: 20, color: Colors.black),
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
    );
  }

  Widget _buildSpecItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 14)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required int rating,
    required String comment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                fontSize: 13,
              ),
            ),
            SizedBox(width: 10),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 14,
                  color: Colors.orange,
                );
              }),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          comment,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }
}
