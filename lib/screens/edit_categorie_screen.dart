import 'package:flutter/material.dart';
import 'package:meine_essens_app/models/category.dart';
import 'package:meine_essens_app/provider/categories.dart';
import 'package:provider/provider.dart';

class EditCategoriesScreen extends StatefulWidget {
  static const routeName = '/edit-Categories';

  @override
  _EditCategoriesScreenState createState() => _EditCategoriesScreenState();
}

class _EditCategoriesScreenState extends State<EditCategoriesScreen> {
  final _form = GlobalKey<FormState>();
  var _editedCat = Category(
    id: null,
    title: '',
  );
  var _initValues = {
    'title': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final catId = ModalRoute.of(context).settings.arguments as String;
      if (catId != null) {
        _editedCat =
            Provider.of<Categories>(context, listen: false).findByIdd(catId);
        _initValues = {
          'title': _editedCat.title,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
    if (_editedCat.id != null) {
      await Provider.of<Categories>(context, listen: false)
          .updateCatgories(_editedCat.id, _editedCat);
    } else {
      try {
        await Provider.of<Categories>(context, listen: false)
            .addCategories(_editedCat);
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
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Categories'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCat = Category(
                          title: value,
                          id: _editedCat.id,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
