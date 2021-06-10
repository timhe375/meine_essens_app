import 'package:flutter/material.dart';
import 'package:meine_essens_app/provider/categories.dart';
import 'package:meine_essens_app/provider/meals.dart';
import 'package:provider/provider.dart';
import '../screens/category_meals_screen.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;

  CategoryItem(this.id, this.title);
  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      CategoryMealsScreen.routeName,
      arguments: {'id': id, 'title': title},
    );
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedMeal.id != null) {
      await Provider.of<Meals>(context, listen: false)
          .updateMeals(_editedMeal.id, _editedMeal);
    } else {
      try {
        await Provider.of<Meals>(context, listen: false).addMeals(_editedMeal);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return InkWell(
      onLongPress: () async {
        try {
          await Provider.of<Categories>(context, listen: false)
              .deleteCategorie(id);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Deleting failed!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ]),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.5),
                Colors.orange[400].withOpacity(0.5)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
