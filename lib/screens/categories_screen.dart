import 'package:meine_essens_app/provider/categories.dart';
import 'package:meine_essens_app/widgets/categorie_item.dart';
import 'package:meine_essens_app/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'edit_categorie_screen.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categoryscreen';
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _isInit = true;
  @override
  void initState() {
    //Provider.of<Dummy>(context, listen: false).categoryList();
    //Future.delayed(Duration.zero).then((_) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Categories>(context).categoryList();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final loadedCategory = Provider.of<Categories>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lieblingsessen'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditCategoriesScreen.routeName);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: GridView(
        padding: EdgeInsets.all(25),
        children: loadedCategory.DUMMY_CATEGORIES
            .map(
              (catData) => CategoryItem(
                catData.id,
                catData.title,
              ),
            )
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
      ),
    );
  }
}
