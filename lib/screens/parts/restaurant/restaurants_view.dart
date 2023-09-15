// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // widgets
// import '../common/common_widget_imports.dart';

// // models
// import 'package:cofify/models/restaurants.dart';

// // other
// import 'package:cofify/services/restaurants_storage_service.dart';

// import 'restaurant_card.dart';

// // import '../../services/auth_service.dart';

// class RestaurantsList extends StatelessWidget {
//   const RestaurantsList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final AuthService auth = AuthService.firebase();
//     final restaurants = Provider.of<List<Restaurant>>(context);

//     final double listViewPadding = MediaQuery.of(context).size.width * 0.05;
//     const double imageHeight = 200;

//     print("Rebuilded Restaurants");

//     return Scaffold(
//       appBar: const CommonAppBar(text: "Lista Kafica"),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20.0),
//             const SearchBox(),
//             const SizedBox(height: 20.0),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: restaurants.length,
//                 itemBuilder: (context, index) {
//                   return FutureBuilder(
//                     future: RestaurantStorageService()
//                         .downloadMainImage(restaurants[index].uid),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.done) {
//                         return RestaurantCard(
//                           snapshot: snapshot,
//                           listViewPadding: listViewPadding,
//                           imageHeight: imageHeight,
//                           restaurant: restaurants[index],
//                         );
//                       } else if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Shimmer.fromColors(
//                           baseColor: Colors.grey[300]!,
//                           highlightColor: Colors.grey[500]!,
//                           child: RestaurantLoadingCard(
//                             listViewPadding: listViewPadding,
//                             imageHeight: imageHeight,
//                           ),
//                         );
//                       } else if (snapshot.hasError) {
//                         return Text("Error ${snapshot.error}");
//                       } else if (!snapshot.hasData) {
//                         return const Text('No image data');
//                       } else {
//                         return const Text('Waiting');
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
