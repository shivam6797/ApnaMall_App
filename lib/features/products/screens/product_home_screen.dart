import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"image": "assets/images/shoes_category.png", "name": "Shoes"},
    {"image": "assets/images/beauty_category.png", "name": "Beauty"},
    {
      "image": "assets/images/women_fashion_category.png",
      "name": "Women's Fashion",
    },
    {"image": "assets/images/jwellery_category.png", "name": "Jewelry"},
    {
      "image": "assets/images/men_fashion_category.png",
      "name": "Men's Fashion",
    },
  ];

  final List<Map<String, dynamic>> products = [
    {
      "name": "Wireless Headphones",
      "price": "₹1200.00",
      "image": "assets/images/boat_ear_burds.png",
    },
    {
      "name": "Men Cotton Hudded/SweatShirt",
      "price": "₹550.00",
      "image": "assets/images/men_cotton_hudded_sweter.png",
    },
    {
      "name": "Men's Mexico-11 Casual Sneakar Shoes",
      "price": "₹734.00",
      "image": "assets/images/shoes_product.png",
    },
    {
      "name": "Just Herbs Makup Kit",
      "price": "₹734.00",
      "image": "assets/images/makup_kit.png",
    },
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: Icon(Icons.grid_view_outlined, color: Colors.black87),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            child: Icon(FontAwesomeIcons.bell, size: 22, color: Colors.black87),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 12, right: 12, top: 10),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: "Poppins",
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    suffixIcon: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 5,
                      runSpacing: 15,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 1,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 5),
                        Icon(FontAwesomeIcons.sliders, color: Colors.black87),
                        SizedBox(width: 15),
                      ],
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          CarouselSlider(
            items: [_buildBanner(context)],
            options: CarouselOptions(
              height: 160,
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 0.9,
            ),
          ),

          SizedBox(height: 20),

          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: EdgeInsets.symmetric(horizontal: 5),
              itemBuilder: (context, index) {
                return Container(
                  width: 70,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 25,
                        backgroundImage: AssetImage(categories[index]['image']),
                      ),
                      SizedBox(height: 6),
                      SizedBox(
                        height: 30,
                        child: Text(
                          categories[index]['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Special For You",
                style: TextStyle(fontSize: 16,fontFamily:"Poppins", fontWeight: FontWeight.w600),
              ),
              Text(
                "See all",
                style: TextStyle(color: Color(0xffff650e),fontFamily:"Poppins", fontSize: 12.5, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 10),

          GridView.extent(
            physics:
                NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
            padding: EdgeInsets.symmetric(horizontal: 12),
            children: List.generate(products.length, (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.routeProductDetail);
                },
                child: _buildProductCard(products[index], width));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade200,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/shoes_image.jpg", fit: BoxFit.cover),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),

          Positioned(
            left: 16,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Super Sale\nDiscount",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "up to ",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: "50% off",
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffff650e),
                    minimumSize: Size(80, 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Shop Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    '${product['image']}',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "${product['name']}",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${product['price']}",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildColorDot(Colors.black),
                            _buildColorDot(Colors.blue),
                            _buildColorDot(Color(0xffff650e)),
                            SizedBox(width: 2),
                            Container(
                              height: 14,
                              width: 14,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                              color: Colors.grey.shade300,

                                shape: BoxShape.circle,
                               ),
                              child: Text(
                                "+2",
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffff650e),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.favorite_border, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      height: 14,
      width: 14,
      margin: EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }
}
