import 'package:flutter/material.dart';
import 'package:meine_essens_app/provider/meals.dart';
import 'package:meine_essens_app/widgets/meal_item.dart';
import 'package:provider/provider.dart';
import 'edit_meal_screen.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-tools';

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  var _isInit = true;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState() {
        _isLoading = true;
      }

      Provider.of<Meals>(context).mealsList().then((_) {
        setState() {
          _isLoading = false;
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final loadedTools = Provider.of<Meals>(
      context,
      listen: false,
    );
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    //final categoryId = routeArgs['id'];
    final categoryMeals = loadedTools.DUMMY_MEALS.where((meal) {
      return meal.title.contains(categoryTitle);
    }).toList();
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(EditMealssScreen.routeName);
          },
        ),
      ]),
      body: ListView.builder(
        padding: EdgeInsets.all(2),
        itemBuilder: (ctx, index) {
          return MealItem(
            id: categoryMeals[index].id,
            title: categoryMeals[index].title,
            imageUrl: categoryMeals[index].imageUrl,
            duration: categoryMeals[index].duration,
            preis: categoryMeals[index].preis,
            complexity: categoryMeals[index].complexity,
          );
        },
        itemCount: categoryMeals.length,
      ),
    );
  }
}
