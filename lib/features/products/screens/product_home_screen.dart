import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:apnamall_ecommerce_app/features/products/bloc/product_bloc.dart';
import 'package:apnamall_ecommerce_app/features/products/bloc/product_event.dart';
import 'package:apnamall_ecommerce_app/features/products/bloc/product_state.dart';
import 'package:apnamall_ecommerce_app/features/products/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;

  @override
  void initState() {
    super.initState();
    // first API hit
    context.read<ProductBloc>().add(LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<ProductBloc, ProductState>(
      listener: (_, state) {
        if (state is ProductFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (_, state) {
        if (state is ProductFailure) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text(state.message)),
          );
        }

        // Show full screen loader only during initial loading
        if (state is ProductLoading || state is ProductInitial) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final loaded = state as ProductLoaded;
        final categories = loaded.categories;
        final products = loaded.products;
        final banners = loaded.banners;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            children: [
              _buildSearchBar(),

              const SizedBox(height: 20),

              // ───────────── Banner Carousel ─────────────
              Stack(
                children: [
                  CarouselSlider(
                    items: banners
                        .map((path) => _buildBanner(context, path))
                        .toList(),
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      viewportFraction: .9,
                      enlargeCenterPage: true,
                      onPageChanged: (i, _) =>
                          setState(() => _currentBanner = i),
                    ),
                  ),
                  // indicator
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        banners.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 8,
                          width: _currentBanner == i ? 13 : 8,
                          decoration: BoxDecoration(
                            color: _currentBanner == i
                                ? Colors.black
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _currentBanner == i
                                  ? Colors.black
                                  : Colors.black54,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ───────────── Categories ─────────────
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final selected = cat.id == loaded.selectedCategoryId;
                    return GestureDetector(
                      onTap: () {
                        context.read<ProductBloc>().add(ChangeCategory(cat.id));
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: selected
                                  ? const Color(0xffff650e)
                                  : Colors.grey.shade200,
                              child: Text(
                                cat.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 30,
                              child: Text(
                                cat.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ───────────── Product Grid ─────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Special For You",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(
                      color: Color(0xffff650e),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              loaded.isProductLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemBuilder: (_, i) {
                        final p = products[i];
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.routeProductDetail,
                            arguments: p,
                          ),
                          child: _buildProductCard(p, width),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  // ───────────────────────────────────────── Widgets
  PreferredSizeWidget _buildAppBar() => AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    elevation: 0,
    leading: Container(
      margin: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: const Icon(Icons.grid_view_outlined, color: Colors.black87),
    ),
    actions: [
      Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: const Icon(
          FontAwesomeIcons.bell,
          size: 22,
          color: Colors.black87,
        ),
      ),
    ],
  );

  Widget _buildSearchBar() => Row(
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
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.black87,
                  margin: const EdgeInsets.only(right: 5),
                ),
                const Icon(FontAwesomeIcons.sliders, color: Colors.black87),
                const SizedBox(width: 15),
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
          ),
        ),
      ),
    ],
  );

  // ───────── Banner Widget ─────────
  Widget _buildBanner(BuildContext context, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade200,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          // हल्का gradient ताकि text उभरे
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
          // static promo‑text
          Positioned(
            left: 16,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Super Sale\nDiscount",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                RichText(
                  text: const TextSpan(
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
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffff650e),
                    minimumSize: const Size(60, 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                  ),
                  child: const Text(
                    "Shop Now",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
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

  // ───────── Product Card Widget ─────────
  Widget _buildProductCard(Product product, double width) {
    // print("🖼 Product Image URL: ${product.image}");
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
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product image
                Center(
                  child: Image.network(
                    product.image.replaceAll(r'\/', '/'),
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${product.price}",
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // colour dots – static demo
                    Row(
                      children: [
                        _buildColorDot(Colors.black),
                        _buildColorDot(Colors.blue),
                        _buildColorDot(const Color(0xffff650e)),
                        const SizedBox(width: 2),
                        Container(
                          height: 14,
                          width: 14,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "+2",
                            style: TextStyle(fontSize: 8, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // favourite icon
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xffff650e),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.favorite_border,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── Re‑usable small colour dot ─────────
  Widget _buildColorDot(Color color) {
    return Container(
      height: 14,
      width: 14,
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }
}
