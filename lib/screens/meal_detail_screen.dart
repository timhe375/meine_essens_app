import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/meals.dart';
import '../models/meal.dart';

class MealDetailScreen extends StatefulWidget {
  static const routeName = '/meal-detail';

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 250,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadedMeals = Provider.of<Meals>(
      context,
      listen: false,
    );
    final mealTitel = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal =
        loadedMeals.DUMMY_MEALS.firstWhere((meal) => meal.id == mealTitel);
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedMeal.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                selectedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // buildSectionTitle(context, 'Ingredients'),
            // buildContainer(
            //   ListView.builder(
            //     itemBuilder: (ctx, index) => Card(
            //       color: Theme.of(context).accentColor,
            //       child: Padding(
            //           padding: EdgeInsets.symmetric(
            //             vertical: 5,
            //             horizontal: 10,
            //           ),
            //           child: Text(mealTitel[index])),
            //     ),
            //     itemCount: selectedMeal.ingredients.length,
            //   ),
            // ),
            buildSectionTitle(context, 'Zutaten'),
            buildContainer(
              ListView(
                children: [
                  ListTile(
                    title: Text(
                      selectedMeal.ingredients,
                    ),
                  ),
                ],
              ),
            ),
            buildSectionTitle(context, 'Steps'),
            buildContainer(
              ListView(
                children: [
                  ListTile(
                    title: Text(
                      selectedMeal.steps,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
