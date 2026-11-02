import 'package:Digibells/screens/ProductDetailsScreen/product_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../api_client/api_constans.dart';
import '../../app_screens/app_screens.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../widgets/loader_widget.dart';
import 'bloc/product_list_bloc.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductListBloc>(create: (_) => ProductListBloc()),
      ],
      child: const ProductListScreen(),
    );
  }

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Load products as soon as the screen is entered
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fetch all products initially
  void _fetchProducts() {
    BlocProvider.of<ProductListBloc>(context).add(
      PerformProductListEvent(
          page: 1, searchQuery: ""), // Empty searchQuery to fetch all products
    );
  }

  // Handle the search logic
  void _onSearchChanged() {
    final query = searchController.text.trim();
    BlocProvider.of<ProductListBloc>(context).add(
      PerformProductListEvent(page: 1, searchQuery: query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.white,
      body: BlocConsumer<ProductListBloc, ProductListState>(
        listener: (context, state) async {
          if (state.isCompleted) {
            state.productListModel?.message ?? "";
          } else if (state.isFailed) {
            AlertUtils.showManuallyCloseDialogue(
                context, state.errorMsg!, 4, 'Oops!');
          }
        },
        builder: (context, state) {
          // Display the filtered or complete product list
          final filteredProducts = state.productListModel?.data ?? [];

          return Stack(
            children: [
               Padding(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 30.h, bottom: 10.h),
                child: Column(
                  children: [
                    // Search field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: const [
                          BoxShadow(
                            color: AppStyles.bordercolor,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        cursorColor: AppStyles.black,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: AppStyles.black_17_w600
                              .copyWith(fontWeight: FontWeight.w500),
                          suffixIcon: const Icon(
                            Icons.search_sharp,
                            color: AppStyles.black,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppStyles.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    // Product grid
                    state.isLoading ? Expanded(child: LoaderWidget()) :  Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.95,
                          //mainAxisExtent: 185.0,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          var items = filteredProducts[index];
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context,  AppScreens.productDetailsScreen,arguments: {
                                'id':state.productListModel?.data?[index].id ??
                                    0
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: AppStyles.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppStyles.bordercolor,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9)),
                                    child: Image.network(
                                      "${APIConstants.imageUrl}${items.image ?? ""}",
                                      fit: BoxFit.contain,
                                      height: 110.h,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 18.h,
                                          width: 120.w,
                                          child: Text(
                                            items.productName ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: AppStyles.black_14_w500.copyWith(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        SizedBox(
                                          height: 18.h,
                                          child: Row(
                                            children: [
                                              Text(
                                                "Rs.",
                                                style: AppStyles.black_14_w500
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "${items.price?.toString() ?? ""}/-",
                                                style: AppStyles.black_14_w500
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            ],
          );
        },
      ),
    );
  }

// class _ProductListScreenState extends State<ProductListScreen> {
//   @override
//   void initState() {
//     // BlocProvider.of<ProductListBloc>(context).add(
//     //   PerformProductListEvent(page: 1, searchQuery: 10),
//     // );
//     searchController.addListener(_onSearchChanged);
//     _fetchProducts();
//     super.initState();
//   }
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   final TextEditingController searchController = TextEditingController();
//
//
//   void _onSearchChanged() {
//     final query = searchController.text.trim();
//     BlocProvider.of<ProductListBloc>(context).add(
//       PerformProductListEvent(page: 1, searchQuery: query),
//     );
//   }
//
//   void _fetchProducts() {
//     BlocProvider.of<ProductListBloc>(context).add(
//       PerformProductListEvent(page: 1, searchQuery: 10),
//     );
//   }
//   // List<ProductList> filteredProducts = [];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppStyles.white,
//       body: BlocConsumer<ProductListBloc, ProductListState>(
//         listener: (context, state) async {
//           if (state.isCompleted) {
//             state.productListModel?.message ?? "";
//           } else if (state.isFailed) {
//             AlertUtils.showManuallyCloseDialogue(
//                 context, state.errorMsg!, 4, 'Oops!');
//           }
//         },
//         builder: (context, state) {
//           final filteredProducts = state.productListModel?.data ?? [];
//
//           return Padding(
//             padding: EdgeInsets.only(
//                 left: 20.w, right: 20.w, top: 30.h, bottom: 10.h),
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(11),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: AppStyles.bordercolor,
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         offset: Offset(1, 1),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: searchController,
//                     cursorColor: AppStyles.black,
//                     decoration: InputDecoration(
//                       hintText: 'Search',
//                       hintStyle: AppStyles.black_17_w600
//                           .copyWith(fontWeight: FontWeight.w500),
//                       suffixIcon: const Icon(
//                         Icons.search_sharp,
//                         color: AppStyles.black,
//                         size: 20,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(11),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: AppStyles.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30.h,
//                 ),
//                 Expanded(
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10.0,
//                       mainAxisSpacing: 10.0,
//                       mainAxisExtent: 185.0,
//                       // childAspectRatio: 0.97,
//                     ),
//                     // itemCount: state.productListModel?.data?.length ?? 0,
//                     itemCount: filteredProducts.length,
//                     itemBuilder: (context, index) {
//                       var items = state.productListModel?.data?[index];
//                       return InkWell(
//                         onTap: () {
//                           Navigator.pushNamed(
//                             context,
//                             AppScreens.productDetailsScreen,
//                           );
//                         },
//                         child: Container(
//                           // height: 110.h,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(9),
//                             color: AppStyles.white,
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: AppStyles.bordercolor,
//                                 spreadRadius: 1,
//                                 blurRadius: 1,
//                                 offset: Offset(1, 1),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(9)),
//                                 child: Image.network(
//                                   "${APIConstants.imageUrl}${items?.image ?? ""}",
//                                   fit: BoxFit.fill,
//                                   height: 125,
//                                   width: double.infinity,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return const Icon(
//                                       Icons.error,
//                                       color: Colors.red,
//                                     );
//                                   },
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(
//                                       width: 120.w,
//                                       child: Text(
//                                         items?.productName ?? "",
//                                         // "Qr Code with Sticker",
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                         style: AppStyles.black_14_w500.copyWith(
//                                             fontWeight: FontWeight.w400),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           "Rs.",
//                                           style: AppStyles.black_14_w500
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w600),
//                                         ),
//                                         SizedBox(
//                                           width: 5.w,
//                                         ),
//                                         Text(
//                                           "${items?.price?.toString() ?? ""}/-",
//                                           // "200/-",
//                                           style: AppStyles.black_14_w500
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w600),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
}
