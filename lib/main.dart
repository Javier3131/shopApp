import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/cart.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: Products()),
        // ChangeNotifierProvider.value(value: Cart()),
        // ChangeNotifierProvider.value(value: Orders())

        // this is the recommenden approach
        ChangeNotifierProvider(create: (ctx) => Auth()),
        // ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        // ChangeNotifierProvider(create: (ctx) => Orders()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrder) => Orders(
            auth.token,
            auth.userId,
            previousOrder == null ? [] : previousOrder.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              fontFamily: 'Lato',
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange),
          home: authData.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        ),
        // child: ,
      ),
    );
  }
}
