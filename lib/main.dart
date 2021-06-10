import 'package:meine_essens_app/provider/meals.dart';
import 'package:meine_essens_app/screens/meal_detail_screen.dart';
import './provider/authentication.dart';
import './provider/categories.dart';
import './screens/categories_screen.dart';
import 'screens/category_meals_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'screens/edit_categorie_screen.dart';
import 'screens/edit_meal_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Authentication(),
          ),
          ChangeNotifierProxyProvider<Authentication, Categories>(
            create: (_) {},
            update: (_, auth, previousProducts) => Categories(
                auth.token,
                previousProducts == null
                    ? []
                    : previousProducts.DUMMY_CATEGORIES),
          ),
          ChangeNotifierProxyProvider<Authentication, Meals>(
            create: (_) {},
            update: (_, auth, previousProducts) => Meals(auth.token,
                previousProducts == null ? [] : previousProducts.DUMMY_MEALS),
          ),
        ],
        child: Consumer<Authentication>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Laborutensilien',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.amber,
              canvasColor: Color.fromRGBO(255, 254, 229, 1),
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  headline5: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  subtitle1: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            //home: auth.isAuth ? CategoriesScreen() : LoginScreen(),
            home: CategoriesScreen(),
            routes: {
              SignupScreen.routeName: (ctx) => SignupScreen(),
              LoginScreen.routeName: (ctx) => LoginScreen(),
              CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
              CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
              EditCategoriesScreen.routeName: (ctx) => EditCategoriesScreen(),
              MealDetailScreen.routeName: (ctx) => MealDetailScreen(),
              EditMealssScreen.routeName: (ctx) => EditMealssScreen(),
            },
          ),
        ));
  }
}
