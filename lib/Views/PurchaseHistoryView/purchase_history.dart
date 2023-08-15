// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:sidebarx/sidebarx.dart';
// import 'package:ufo_food/Model/product.dart';
// import 'package:ufo_food/Views/MainViews/Components/error_state.dart';
// import 'package:ufo_food/Views/MainViews/Components/loading_bar.dart';
// import 'package:ufo_food/Views/MainViews/Components/sidebar.dart';
// import 'package:ufo_food/helper/product_data.dart';

// import '../../Model/purchase_history.dart';
// import '../../data/constants.dart';

// class PurchaseHistoryView extends StatefulWidget {
//   const PurchaseHistoryView({super.key, this.userId});
//   final int? userId;

//   @override
//   State<PurchaseHistoryView> createState() => _PurchaseHistoryViewState();
// }

// class _PurchaseHistoryViewState extends State<PurchaseHistoryView> {
//   final _controller = SidebarXController(selectedIndex: 0, extended: true);

//   Basket basket = Basket();

//   late Future<List<PurchaseHistoryResponse>> _futurePurchaseHistory;

//   @override
//   void initState() {
//     super.initState();
//     _futurePurchaseHistory = basket.getAllPurchaseHistory(widget.userId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPrimaryColor,
//       appBar: AppBar(
//         title: const AutoSizeText(
//           "UFOFOOD",
//           style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w900),
//         ),
//         centerTitle: true,
//       ),
//       drawer: SideBarExample(controller: _controller),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 15,
//           ),
//           const AutoSizeText(
//             "Корзина",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: _futurePurchaseHistory,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   if (snapshot.hasError) {
//                     return const ErrorState();
//                   } else {
//                     var purchaseHistory = snapshot.data!;
//                     return ListView.builder(
//                       itemCount: purchaseHistory.length,
//                       itemBuilder: (context, index) {
//                         if (widget.userId == purchaseHistory[index].userId) {
//                           PurchaseHistoryResponse purchase =
//                               purchaseHistory[index];
//                           return Column(
//                             children: <Widget>[
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 10),
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(6)),
//                                 child: ListTile(
//                                   title: AutoSizeText(
//                                     'код заказа: ${purchase.orderCode}',
//                                     style:
//                                         const TextStyle(color: kSecondaryColor),
//                                   ),
//                                   subtitle: AutoSizeText(
//                                     'дата заказа: ${purchase.createdAt}',
//                                     style:
//                                         const TextStyle(color: kSecondaryColor),
//                                   ),
//                                 ),
//                               ),
//                               ListView.builder(
//                                 itemCount: purchase.products.length,
//                                 shrinkWrap: true,
//                                 itemBuilder: (context, productIndex) {
//                                   PurchaseProduct product =
//                                       purchase.products[productIndex];
//                                   return Container(
//                                     margin: const EdgeInsets.symmetric(
//                                         horizontal: 20),
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(6)),
//                                     child: ListTile(
//                                       title: AutoSizeText(product.title),
//                                       subtitle: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           AutoSizeText(
//                                               'Цена: ${product.price} р'),
//                                           AutoSizeText(
//                                               'Количество: ${product.count}'),
//                                           const AutoSizeText('Ингредиенты:'),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: product.ingredientValues
//                                                 .map((ingredient) {
//                                               return AutoSizeText(
//                                                   '${ingredient.title}: ${ingredient.count}');
//                                             }).toList(),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             ],
//                           );
//                         } else {
//                           return Container();
//                         }
//                       },
//                     );
//                   }
//                 } else {
//                   return const LoadingWidget();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
