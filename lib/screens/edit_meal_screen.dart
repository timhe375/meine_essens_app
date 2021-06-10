import 'dart:io';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meine_essens_app/widgets/image_input.dart';
import '../models/meal.dart';
import '../provider/meals.dart';
import 'package:provider/provider.dart';

class EditMealssScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditMealssScreenState createState() => _EditMealssScreenState();
}

class _EditMealssScreenState extends State<EditMealssScreen> {
  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _preisFocusNode = FocusNode();
  final _durationFocusNode = FocusNode();
  final _stepsFocusNode = FocusNode();
  final _ingredientsFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _complexityFocusNode = FocusNode();
  final _catgorieFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  File _pickedImage;
  var _editedMeal = Meal(
    id: null,
    title: '',
    imageUrl: '',
    duration: 0,
    preis: '',
    complexity: '',
    steps: '',
    ingredients: '',
  );
  var _initValues = {
    'title': '',
    'categories': '',
    'imageUrl': '',
    'duration': '',
    'preis': '',
    'complexity': '',
    'steps': '',
    'Zutaten': '',
  };
  var _isInit = true;
  var _isLoading = false;
  var selectedValue = 'Leicht';
  var selectedValuee = 'Günstig';
  List _options = [
    'Leicht',
    'Mittel',
    'Schwer',
  ];
  List _options2 = [
    'Günstig',
    'Mittel',
    'Teuer',
  ];
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
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final toolId = ModalRoute.of(context).settings.arguments as String;
      if (toolId != null) {
        _editedMeal =
            Provider.of<Meals>(context, listen: false).findByIdd(toolId);
        _initValues = {
          'title': _editedMeal.title,
          'categories': _editedMeal.categories.toString(),
          'imageUrl': _editedMeal.imageUrl,
          'ingredients': _editedMeal.ingredients.toString(),
          'steps': _editedMeal.steps.toString(),
          'duration': _editedMeal.duration.toString(),
          'preis': _editedMeal.preis.toString(),
          'complexity': _editedMeal.complexity.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _titleFocusNode.dispose();
    _complexityFocusNode.dispose();
    _preisFocusNode.dispose();
    _catgorieFocusNode.dispose();
    _stepsFocusNode.dispose();
    _ingredientsFocusNode.dispose();
    _durationFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
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
        title: Text('Edit Product'),
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
              child: Scrollbar(
                child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Titel'),
                        textInputAction: TextInputAction.next,
                        focusNode: _titleFocusNode,
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
                          _editedMeal = Meal(
                            title: value,
                            categories: _editedMeal.categories,
                            imageUrl: _editedMeal.imageUrl,
                            preis: _editedMeal.preis,
                            complexity: _editedMeal.complexity,
                            duration: _editedMeal.duration,
                            id: _editedMeal.id,
                            steps: _editedMeal.steps,
                          );
                        },
                      ),
                      // buildContainer(
                      //   ListView.builder(
                      //     itemBuilder: (ctx, index) => Column(
                      //       children: [
                      //         ListTile(
                      //           leading: CircleAvatar(
                      //             child: Text('# ${(index + 1)}'),
                      //           ),
                      //           title:
                      TextFormField(
                        initialValue: _initValues['steps'],
                        decoration: InputDecoration(labelText: 'Steps'),
                        textInputAction: TextInputAction.next,
                        focusNode: _stepsFocusNode,
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
                          _editedMeal = Meal(
                            title: _editedMeal.title,
                            imageUrl: _editedMeal.imageUrl,
                            preis: _editedMeal.preis,
                            complexity: _editedMeal.complexity,
                            duration: _editedMeal.duration,
                            id: _editedMeal.id,
                            ingredients: _editedMeal.ingredients,
                            steps: value,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['Zutaten'],
                        decoration: InputDecoration(labelText: 'Zutaten'),
                        textInputAction: TextInputAction.next,
                        focusNode: _ingredientsFocusNode,
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
                          _editedMeal = Meal(
                            title: _editedMeal.title,
                            imageUrl: _editedMeal.imageUrl,
                            preis: _editedMeal.preis,
                            complexity: _editedMeal.complexity,
                            duration: _editedMeal.duration,
                            id: _editedMeal.id,
                            ingredients: value,
                            steps: _editedMeal.steps,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['duration'],
                        decoration: InputDecoration(labelText: 'Duration'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_durationFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedMeal = Meal(
                            title: _editedMeal.title,
                            duration: int.parse(value),
                            imageUrl: _editedMeal.imageUrl,
                            preis: _editedMeal.preis,
                            complexity: _editedMeal.complexity,
                            categories: _editedMeal.categories,
                            id: _editedMeal.id,
                            ingredients: _editedMeal.ingredients,
                            steps: _editedMeal.steps,
                          );
                        },
                      ),
                      // TextFormField(
                      //   initialValue: _initValues['ingredients'],
                      //   decoration: InputDecoration(labelText: 'Zutaten'),
                      //   textInputAction: TextInputAction.next,
                      //   maxLines: 3,
                      //   keyboardType: TextInputType.multiline,
                      //   onFieldSubmitted: (_) {
                      //     _saveForm();
                      //   },
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'Please provide a value.';
                      //     }
                      //     return null;
                      //   },
                      //   onSaved: (value) {
                      //     _editedMeal = Meal(
                      //       title: _editedMeal.title,
                      //       imageUrl: _editedMeal.imageUrl,
                      //       preis: _editedMeal.preis,
                      //       complexity: _editedMeal.complexity,
                      //       duration: _editedMeal.duration,
                      //       id: _editedMeal.id,
                      //       steps: _editedMeal.steps,
                      //     );
                      //   },
                      // ),
                      // Text('Schwierigkeit'),

                      // DropdownButtonFormField(
                      //   focusNode: _complexityFocusNode,
                      //   value: selectedValue,
                      //   items: [
                      //     DropdownMenuItem(child: Text("Leicht"), value: 1),
                      //     DropdownMenuItem(child: Text("Mittel"), value: 2),
                      //     DropdownMenuItem(child: Text("Schwer"), value: 3),
                      //   ],
                      //   onSaved: (value) {
                      //     _editedMeal = Meal(
                      //       title: _editedMeal.title,
                      //       imageUrl: _editedMeal.imageUrl,
                      //       affordability: _editedMeal.affordability,
                      //       complexity: value.toString(),
                      //       duration: _editedMeal.duration,
                      //       id: _editedMeal.id,
                      //       ingredients: _editedMeal.ingredients,
                      //     );
                      //   },
                      //   onChanged: (value) {
                      //     setState(() {
                      //       selectedValue = value;
                      //       _saveForm();
                      //     });
                      //   },
                      // ),
                      Text('Schwierigkeit'),
                      DropdownButtonFormField(
                        focusNode: _complexityFocusNode,
                        value: selectedValue,
                        items: _options
                            .map((schwierigkeit) => DropdownMenuItem(
                                  child: Text(schwierigkeit),
                                  value: schwierigkeit,
                                ))
                            .toList(),
                        onSaved: (value) {
                          _editedMeal = Meal(
                            title: _editedMeal.title,
                            imageUrl: _editedMeal.imageUrl,
                            preis: _editedMeal.preis,
                            complexity: value.toString(),
                            duration: _editedMeal.duration,
                            id: _editedMeal.id,
                            ingredients: _editedMeal.ingredients,
                            steps: _editedMeal.steps,
                          );
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                      Text('Kosten'),
                      DropdownButtonFormField(
                        focusNode: _preisFocusNode,
                        value: selectedValuee,
                        items: _options2
                            .map((kosten) => DropdownMenuItem(
                                  child: Text(kosten),
                                  value: kosten,
                                ))
                            .toList(),
                        onSaved: (value) {
                          _editedMeal = Meal(
                            title: _editedMeal.title,
                            imageUrl: _editedMeal.imageUrl,
                            preis: value.toString(),
                            complexity: _editedMeal.complexity,
                            duration: _editedMeal.duration,
                            id: _editedMeal.id,
                            ingredients: _editedMeal.ingredients,
                            steps: _editedMeal.steps,
                          );
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedValuee = value;
                          });
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          //ImageInput(_selectImage),
                          // Container(
                          //   height: 100,
                          //   width: 150,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(width: 1, color: Colors.grey),
                          //   ),
                          //   child: _image == null
                          //       ? Text('No image selected.')
                          //       : Image.file(
                          //           _image,
                          //           fit: BoxFit.cover,
                          //           width: double.infinity,
                          //         ),
                          // ),
                          // FloatingActionButton(
                          //   onPressed: getImage,
                          //   tooltip: 'Pick Image',
                          //   child: Icon(Icons.add_a_photo),
                          // ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an image URL.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL.';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid image URL.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedMeal = Meal(
                                  title: _editedMeal.title,
                                  steps: _editedMeal.steps,
                                  ingredients: _editedMeal.ingredients,
                                  categories: _editedMeal.categories,
                                  imageUrl: value,
                                  preis: _editedMeal.preis,
                                  complexity: _editedMeal.complexity,
                                  duration: _editedMeal.duration,
                                  id: _editedMeal.id,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
