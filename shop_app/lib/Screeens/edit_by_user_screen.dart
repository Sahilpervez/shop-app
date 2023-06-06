import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:color_picker_field/color_picker_field.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/AppUtils/styles.dart';
import 'package:shop_app/Model/product.dart';
import 'package:shop_app/Model/providers/products_provider.dart';

import '../Widgets/attribute_list_viewer.dart';
import '../Widgets/attribute_map_colors_viewer.dart';

enum filterOptions {
  list,
  map,
}

class EditByUserProductScreen extends StatefulWidget {
  EditByUserProductScreen({Key? key}) : super(key: key);
  static const routeName = "/EditByUserProduct";
  @override
  State<EditByUserProductScreen> createState() => _EditByUserProductScreen();
}

class _EditByUserProductScreen extends State<EditByUserProductScreen> {
  var _editedProduct = Product(
      rating: 0,
      attributes: {},
      id: DateTime.now().toString(),
      title: "",
      description: "",
      price: 0,
      imageURL: "");
  // TODO: Implement pushing the product to the main database

  String _hereTitle = "";
  var _herePrice;
  var _hereDiscount;

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  var _descriptionController;
  var _titleController;
  var _ratingController;
  var _discountController;
  var _priceController;
  var _controller;
  var _tempStrController;
  var _dynamicController;
  var _listKeyController;
  var _mapColorsKeyController;
  final _colorController = CircleColorPickerController(
    initialColor: Colors.lightBlueAccent,
  );
  var _imageURLController;
  var _selectedtype = null;
  List<String> _details = [];
  Map<String, dynamic> _attributes = {};
  List<String> _list = [];
  Map<String, dynamic> _mapColors = {};
  Color currColor = Colors.grey;
  Color? pickerColor;
  final _imageURLFocusNode = FocusNode();
  var isListExpanded = false;
  var isMapExpanded = false;
  var _form = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _imageURLFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _listKeyController.dispose();
    _mapColorsKeyController.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    _tempStrController.dispose();
    _controller.dispose();
    _colorController.dispose();
    _dynamicController.dispose();
    _imageURLFocusNode.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    _titleController.dispose();
    _discountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  var _isInit = true;
  late String ID;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      ID = ModalRoute.of(context)!.settings.arguments as String;
      print(ID);
      _editedProduct = Provider.of<ProductsProvider>(context).findById(ID);
      _details = [...?_editedProduct.details];
      _attributes = {..._editedProduct.attributes};
      print(_attributes);
      _list = [
        ..._attributes.values.firstWhere((element) => element is List<String>,orElse: ()=>[])
      ];
      if(_list.isEmpty){
    _list = [..._attributes.values.firstWhere((element) => element is List<dynamic>,orElse: ()=>[])];
      }
      _mapColors = {
        ..._attributes.values
            .firstWhere((element) => element is Map<String, dynamic>,orElse: ()=> {})
      };
      if(_mapColors.isEmpty){
        _mapColors = {
          ..._attributes.values
              .firstWhere((element) => element is Map<dynamic, dynamic>,orElse: ()=> {})
        };
      }
      _hereTitle = _editedProduct.title;
      _hereDiscount = _editedProduct.discount;
      String templistkeyText = _attributes.keys.firstWhere((element) => _attributes[element] is List<String> ,orElse: ()=>"");
      _listKeyController = TextEditingController(
        text: (templistkeyText.isNotEmpty) ? templistkeyText:_attributes.keys.firstWhere((element) => _attributes[element] is List<dynamic> ,orElse: ()=>"")
      );
      String tempmapkeyText = _attributes.keys.firstWhere((element) => _attributes[element] is Map<String,dynamic>,orElse: ()=> " ");
      _mapColorsKeyController = TextEditingController(
        text: (tempmapkeyText.isNotEmpty) ? tempmapkeyText:_attributes.keys.firstWhere((element) => _attributes[element] is Map<String,dynamic>,orElse: ()=> " ")
      );
      // print('${_list}\n${_mapColors}');
      _descriptionController =
          TextEditingController(text: _editedProduct.description);
      _titleController = TextEditingController(text: _editedProduct.title);
      _ratingController =
          TextEditingController(text: _editedProduct.rating.toString());
      _discountController =
          TextEditingController(text: _editedProduct.discount.toString());
      _priceController =
          TextEditingController(text: _editedProduct.price.toString());
      _controller = TextEditingController();
      _tempStrController = TextEditingController();
      _dynamicController = TextEditingController();
      _imageURLController =
          TextEditingController(text: _editedProduct.imageURL);
    }
    super.didChangeDependencies();
  }
  @override
  void initState() {
    // TODO: implement initState
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  void _updateImageURL() {
    if ((!_imageURLController.text!.startsWith("http") &&
            !_imageURLController.text!.startsWith("https")) ||
        (!_imageURLController.text!.endsWith('.png') &&
            !_imageURLController.text!.endsWith(".jpg") &&
            !_imageURLController.text!.endsWith('.jpeg') &&
            !_imageURLController.text!.endsWith('.webp'))) {
      return;
    }
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    Save();
  }

  Future<void> Save() async {
    setState(() {
      _isLoading = true;
    });
    _editedProduct = Product(
      rating: _editedProduct.rating,
      attributes: _attributes,
      id: ID,
      title: _editedProduct.title,
      description: _editedProduct.description,
      price: _editedProduct.price,
      imageURL: _editedProduct.imageURL,
      discount: _hereDiscount,
      details: _details,
    );
    var prdct = Product(
      rating: _editedProduct.rating,
      attributes: _attributes,
      id: _editedProduct.id,
      title: _hereTitle,
      description: _editedProduct.description,
      price: _editedProduct.price,
      imageURL: _editedProduct.imageURL,
      discount: _hereDiscount,
      details: _details,
    );
    try{
      await Provider.of<ProductsProvider>(context,listen: false).updateProduct(prdct);
    } catch(error){
      await showDialog(context: context, builder: (ctx)=> AlertDialog(
        title: Text("An Error Occured"),
        content: Text("Someting went wrong"),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
            },
            child: Text("Okay"),
          ),
        ],
      ));
    } finally{
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Products",
          style: TextStyle(
            fontFamily: AppStyle.defaultText,
            fontWeight: FontWeight.w900,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: const Icon(Icons.save)),
        ],
        centerTitle: true,
      ),
      body: (_isLoading)?Center(child: CircularProgressIndicator()):Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  controller: _titleController,
                  onFieldSubmitted: (value) {
                    _hereTitle = value;
                    print(_hereTitle);
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onTapOutside: (_) {
                    if (_titleController.text.isNotEmpty) {
                      _hereTitle = _titleController.text;
                      _editedProduct = Product(
                        rating: _editedProduct.rating,
                        attributes: _editedProduct.attributes,
                        id: _editedProduct.id,
                        title: _titleController.text,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageURL: _editedProduct.imageURL,
                      );
                    }
                  },
                  onSaved: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide a title";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  controller: _priceController,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onTapOutside: (_) {
                    if (_priceController.text.isNotEmpty) {
                      _herePrice = double.parse(_priceController.text);
                      _editedProduct = Product(
                        rating: _editedProduct.rating,
                        attributes: _editedProduct.attributes,
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _herePrice,
                        imageURL: _editedProduct.imageURL,
                      );
                    }
                  },
                  onSaved: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide a price value";
                    }
                    if (double.tryParse(value) == null) {
                      return "Enter a valid price value";
                    }
                    if (double.parse(value) < 0) {
                      return "Enter a positive value of price";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  controller: _descriptionController,
                  onTapOutside: (_) {
                    _editedProduct = Product(
                      rating: _editedProduct.rating,
                      attributes: _editedProduct.attributes,
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _descriptionController.text,
                      price: _editedProduct.price,
                      imageURL: _editedProduct.imageURL,
                    );
                  },
                  onFieldSubmitted: (value) {
                    // _editedProduct = Product(
                    //   rating: _editedProduct.rating,
                    //   attributes: _editedProduct.attributes,
                    //   id: _editedProduct.id,
                    //   title: _editedProduct.title,
                    //   description: value,
                    //   price: _editedProduct.price,
                    //   imageURL: _editedProduct.imageURL,
                    // );
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      rating: _editedProduct.rating,
                      attributes: _editedProduct.attributes,
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value!,
                      price: _editedProduct.price,
                      imageURL: _editedProduct.imageURL,
                    );
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide a Value";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please provide a number";
                    }
                    if (double.parse(value) >= 100 || double.parse(value) < 0) {
                      return "Please provide a valid amount of discount";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Discount",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  onTapOutside: (_) {
                    print(_discountController.text);
                    if (_discountController.text.isNotEmpty) {
                      _hereDiscount = double.parse(_discountController.text);
                      print(_hereDiscount.runtimeType);
                      _editedProduct = Product(
                        rating: _editedProduct.rating,
                        attributes: _editedProduct.attributes,
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageURL: _editedProduct.imageURL,
                        discount: _hereDiscount,
                      );
                    }
                  },
                  onSaved: (value) {},
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, right: 8),
                      width: constraints.maxWidth * 0.3 - 10,
                      height: constraints.maxWidth * 0.3 * 4 / 3.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          // color: Colors.lightBlueAccent,
                          border: Border.all(
                            color: Colors.grey.shade700,
                            width: 1.5,
                          ),
                          image: DecorationImage(
                              image: NetworkImage(
                                (_imageURLController.text.isNotEmpty)
                                    ? _imageURLController.text
                                    : "https://thumbs.dreamstime.com/b/blank-blue-high-details-paper-sheet-texture-blank-blue-high-details-paper-sheet-texture-background-material-185545926.jpg",
                              ),
                              fit: BoxFit.cover)),
                      child: (_imageURLController.text.isEmpty)
                          ? const Center(
                              child: Text("Enter a URL"),
                            )
                          : Container(),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.7,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter an image URL";
                          }
                          if (!value.startsWith("http") &&
                              !value.startsWith("https")) {
                            return "Please enter a valid URL";
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith(".jpg") &&
                              !value.endsWith('.jpeg') &&
                              !value.endsWith('.webp') && !value.endsWith('.JPG')) {
                            return "Please enter URL of an image";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Image URL"),
                        ),
                        maxLines: 2,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageURLController,
                        focusNode: _imageURLFocusNode,
                        onTapOutside: (_) {
                          if (_imageURLController.text.isNotEmpty) {
                            _editedProduct = Product(
                              rating: _editedProduct.rating,
                              attributes: _editedProduct.attributes,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageURL: _imageURLController.text,
                            );
                          }
                        },
                        onSaved: (value) {
                          // _editedProduct = Product(
                          //   rating: _editedProduct.rating,
                          //   attributes: _editedProduct.attributes,
                          //   id: _editedProduct.id,
                          //   title: _editedProduct.title,
                          //   description: _editedProduct.description,
                          //   price: _editedProduct.price,
                          //   imageURL: value!,
                          // );
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide a Value";
                    }
                    if (double.tryParse(value) == null) {
                      return "Enter a valid number";
                    }
                    if (double.parse(value) >= 5 || double.parse(value) < 0) {
                      return "Enter a value between 0 and 5";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Rating",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  controller: _ratingController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onTapOutside: (_) {
                    var _rating = _ratingController.text;
                    if (_rating.isNotEmpty) {
                      _editedProduct = Product(
                        rating: double.parse(_rating),
                        attributes: _editedProduct.attributes,
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageURL: _editedProduct.imageURL,
                      );
                    }
                  },
                  onSaved: (value) {
                    print(value);
                    if (value!.isNotEmpty) {
                      _editedProduct = Product(
                        rating: double.parse(value!),
                        attributes: _editedProduct.attributes,
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageURL: _editedProduct.imageURL,
                      );
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: const Text(
                    "Product Details :",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth - 50,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: "Product Details"),
                              controller: _controller,
                              onFieldSubmitted: (str) {
                                setState(() {
                                  if (_controller.text.isNotEmpty) {
                                    setState(() {
                                      _details.add(_controller.text);
                                      if (kDebugMode) {
                                        print(_details);
                                      }
                                      _controller.clear();
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                          if (_details.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(15),
                              height: min(50 * _details.length + 80, 170),
                              width: constraints.maxWidth * 0.80,
                              child: ListView(
                                children: [
                                  const Text(
                                    "Details: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                  ..._details.map((e) {
                                    if (e.isEmpty) {
                                      setState(() {
                                        _details.remove(e);
                                      });
                                    }
                                    var ctrl0 = TextEditingController(
                                      text: e,
                                    );
                                    String currStr = e;
                                    return SizedBox(
                                      width: constraints.maxWidth * 0.70 - 50,
                                      child: TextFormField(
                                        // initialValue: e,
                                        controller: ctrl0,
                                        onEditingComplete: () {
                                          if (kDebugMode) {
                                            print("OnEditingComplete");
                                            print(ctrl0.text);
                                          }
                                          if (ctrl0.text.isNotEmpty) {
                                            setState(() {
                                              int id =
                                                  _details.indexOf(currStr);
                                              _details.replaceRange(
                                                  id, id, [ctrl0.text]);
                                              _details.remove(currStr);
                                              if (!_details
                                                  .contains(ctrl0.text)) {
                                                _details.add(ctrl0.text);
                                              }
                                              // _details = [...{..._details}];
                                            });
                                          }
                                          if (ctrl0.text.isEmpty) {
                                            _details.remove(currStr);
                                          }
                                          if (kDebugMode) {
                                            print(_details);
                                          }
                                        },
                                        onTapOutside: (_) {
                                          if (kDebugMode) {
                                            print("OnTapOutside");
                                            print(ctrl0.text);
                                          }
                                          if (ctrl0.text.isNotEmpty) {
                                            setState(() {
                                              int id =
                                                  _details.indexOf(currStr);
                                              _details.replaceRange(
                                                  id, id, [ctrl0.text]);
                                              _details.remove(currStr);
                                              if (!_details
                                                  .contains(ctrl0.text)) {
                                                _details.add(ctrl0.text);
                                              }
                                              // _details = [...{..._details}];
                                            });
                                          }
                                          if (ctrl0.text.isEmpty) {
                                            _details.remove(currStr);
                                          }
                                          if (kDebugMode) {
                                            print(_details);
                                          }
                                        },
                                        onFieldSubmitted: (str) {
                                          if (kDebugMode) {
                                            print(currStr);
                                            print(str);
                                          }
                                          if (str.isNotEmpty &&
                                              !_details.contains(str)) {
                                            setState(() {
                                              int id =
                                                  _details.indexOf(currStr);
                                              if (kDebugMode) {
                                                print(id);
                                              }
                                              if (!_details.contains(str)) {
                                                _details.add(str);
                                                if (kDebugMode) {
                                                  print("added");
                                                }
                                              }
                                              // _details = [...{..._details}];
                                            });
                                          }
                                          if (str.isEmpty) {
                                            _details.remove(currStr);
                                          }
                                          if (kDebugMode) {
                                            print(_details);
                                          }
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: IconButton(
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              setState(() {
                                _details.add(_controller.text);
                                if (kDebugMode) {
                                  print(_details);
                                }
                                _controller.clear();
                              });
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: const Text(
                    "Product Attributes :",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            width: constraints.maxWidth - 50,
                            child: Row(
                              children: [
                                const Text(
                                  "Select Value Type:",
                                  style: TextStyle(fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                PopupMenuButton(
                                  onSelected: (filterOptions selectedValue) {
                                    if (selectedValue == filterOptions.list) {
                                      setState(() {
                                        _selectedtype = 0;
                                      });
                                    }
                                    if (selectedValue == filterOptions.map) {
                                      setState(() {
                                        _selectedtype = 1;
                                      });
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem(
                                          value: filterOptions.list,
                                          child: Text("List")),
                                      const PopupMenuItem(
                                          value: filterOptions.map,
                                          child: Text("Map Colors")),
                                    ];
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        (_selectedtype == null)
                                            ? "Type : "
                                            : (_selectedtype == 0)
                                                ? "List"
                                                : "Map Colors",
                                        style: const TextStyle(fontSize: 17),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Icon(Icons.arrow_drop_down_rounded)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_selectedtype == 0)
                  Column(
                    children: [
                      SizedBox(
                        width: constraints.maxWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth - 50,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: "Enter the Key: ",
                                        labelStyle: TextStyle(fontSize: 20)),
                                    // initialValue: "Colors",
                                    controller: _listKeyController,
                                    onFieldSubmitted: (str) {},
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth - 50,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: "Values for Attributes"),
                                    controller: _dynamicController,
                                    onFieldSubmitted: (str) {
                                      setState(() {
                                        if (_dynamicController
                                            .text.isNotEmpty) {
                                          setState(() {
                                            _list.add(_dynamicController.text);
                                            if (kDebugMode) {
                                              print(_list);
                                            }
                                            _dynamicController.clear();
                                          });
                                        }
                                      });
                                    },
                                  ),
                                ),
                                if (_list.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.5,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    height: min(50 * _list.length + 80, 170),
                                    width: constraints.maxWidth * 0.80,
                                    child: ListView(
                                      children: [
                                        Text(
                                          "${_listKeyController.text} : ",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        ..._list.map((e) {
                                          if (e.isEmpty) {
                                            setState(() {
                                              _list.remove(e);
                                            });
                                          }
                                          var ctrl = TextEditingController(
                                            text: e,
                                          );
                                          String currStr = e;
                                          return SizedBox(
                                            width: constraints.maxWidth * 0.70 -
                                                50,
                                            child: TextFormField(
                                              controller: ctrl,
                                              onEditingComplete: () {
                                                if (kDebugMode) {
                                                  print("OnEditingComplete");
                                                  print("OnTapOutside");
                                                  print(ctrl.text);
                                                }
                                                if (ctrl.text.isNotEmpty) {
                                                  setState(() {
                                                    int id =
                                                        _list.indexOf(currStr);
                                                    _list.replaceRange(
                                                        id, id, [ctrl.text]);
                                                    _list.remove(currStr);
                                                    if (!_list
                                                        .contains(ctrl.text)) {
                                                      _list.add(ctrl.text);
                                                    }
                                                  });
                                                }
                                                if (ctrl.text.isEmpty) {
                                                  _list.remove(currStr);
                                                }
                                                if (kDebugMode) {
                                                  print(_list);
                                                }
                                              },
                                              onTapOutside: (_) {
                                                if (kDebugMode) {
                                                  print("OnTapOutside");
                                                  print(ctrl.text);
                                                }
                                                if (ctrl.text.isNotEmpty) {
                                                  setState(() {
                                                    int id =
                                                        _list.indexOf(currStr);
                                                    _list.replaceRange(
                                                        id, id, [ctrl.text]);
                                                    _list.remove(currStr);
                                                    if (!_list
                                                        .contains(ctrl.text)) {
                                                      _list.add(ctrl.text);
                                                    }
                                                  });
                                                }
                                                if (ctrl.text.isEmpty) {
                                                  _list.remove(currStr);
                                                }
                                                if (kDebugMode) {
                                                  print(_list);
                                                }
                                              },
                                              onFieldSubmitted: (str) {
                                                if (kDebugMode) {
                                                  print(currStr);
                                                  print(str);
                                                }
                                                if (str.isNotEmpty &&
                                                    !_list.contains(str)) {
                                                  setState(() {
                                                    int id =
                                                        _list.indexOf(currStr);
                                                    if (kDebugMode) {
                                                      print(id);
                                                    }
                                                    if (!_list.contains(str)) {
                                                      _list.add(str);
                                                      if (kDebugMode) {
                                                        print("added");
                                                      }
                                                    }
                                                    // _details = [...{..._details}];
                                                  });
                                                }
                                                if (str.isEmpty) {
                                                  _list.remove(currStr);
                                                }
                                                if (kDebugMode) {
                                                  print(_list);
                                                }
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 80.0),
                              child: IconButton(
                                onPressed: () {
                                  if (_dynamicController.text.isNotEmpty) {
                                    setState(() {
                                      _list.add(_dynamicController.text);
                                      if (kDebugMode) {
                                        print(_list);
                                      }
                                      _dynamicController.clear();
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_listKeyController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Key cannot be empty"),
                              ));
                              return;
                            }
                            var tempString = _listKeyController.text;
                            setState(() {
                              // if(_tempStrController.text.isNotEmpty){
                              _attributes.update(_listKeyController.text, (value) => [..._list]);
                              _selectedtype = null;
                              // }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Attributes named $tempString updated"),
                              ),
                            );
                            if (kDebugMode) {
                              print(_attributes);
                            }
                          },
                          child: const Text(
                            "Add to Product Attributes",
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_selectedtype == 1)
                  Column(
                    children: [
                      SizedBox(
                        width: constraints.maxWidth ,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Enter the Key: ",
                              labelStyle: TextStyle(fontSize: 20)),
                          // initialValue: "Colors",
                          controller: _mapColorsKeyController,
                          onFieldSubmitted: (str) {},
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: (constraints.maxWidth * 5 / 10) - 30,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Enter Color Name"),
                                controller: _dynamicController,
                                onFieldSubmitted: (str) {
                                  setState(() {
                                    if (_dynamicController.text.isNotEmpty) {
                                      setState(() {
                                        _list.add(_dynamicController.text);
                                        if (kDebugMode) {
                                          print(_list);
                                        }
                                        _dynamicController.clear();
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                            const Spacer(),
                            const Text(":"),
                            const Spacer(),
                            SizedBox(
                              width:
                                  (constraints.maxWidth * (2 / 3) * (2 / 3)) -
                                      30,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: const Text("Pick a Color"),
                                          content: SingleChildScrollView(
                                            child: Center(
                                              child: CircleColorPicker(
                                                controller: _colorController,
                                                onChanged: (clr) {
                                                  setState(() {
                                                    pickerColor = clr;
                                                  });
                                                },
                                                onEnded: (clr) {
                                                  setState(() {
                                                    currColor = clr;
                                                    pickerColor = clr;
                                                  });
                                                },
                                                strokeWidth: 10,
                                              ),
                                            ),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          actions: [
                                            SizedBox(
                                              width: constraints.maxWidth * 0.3,
                                              child: TextFormField(
                                                initialValue: pickerColor
                                                    .hashCode
                                                    .toString(),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  currColor = pickerColor!;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Confirm"),
                                            )
                                          ],
                                        );
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currColor,
                                ),
                                child: const Text("Select Color"),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _mapColors.addAll(
                                      {_dynamicController.text: currColor});
                                  _dynamicController.clear();
                                  currColor = Theme.of(context).buttonColor;
                                });
                                if (kDebugMode) {
                                  print(_mapColors);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      if (_mapColors.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(15),
                          height: min(70 * _mapColors.length + 50, 200),
                          width: min(constraints.maxWidth * 0.80, 425),
                          child: ListView(
                            children: [
                              Text(
                                "${_mapColorsKeyController.text} :",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              ..._mapColors.entries.map((e) {
                                Color idxClr = e.value;
                                Color pickedClr = e.value;
                                final mapColorTextController =
                                    TextEditingController(text: e.key);
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  width: constraints.maxWidth * 0.70 - 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: min(
                                            constraints.maxWidth * 0.5 - 30,
                                            260),
                                        child: TextFormField(
                                          controller: mapColorTextController,
                                          onEditingComplete: () {
                                            if (kDebugMode) {
                                              print("OnEditingComplete");
                                              print(
                                                  mapColorTextController.text);
                                            }
                                            if (mapColorTextController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                String newKey =
                                                    mapColorTextController.text;
                                                var newValue = e.value;
                                                _mapColors.remove(e.key);
                                                _mapColors
                                                    .addAll({newKey: newValue});
                                              });
                                            }
                                            if (mapColorTextController
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "The key cannot be empty",
                                                  ),
                                                ),
                                              );
                                            }
                                            if (kDebugMode) {
                                              print(_mapColors);
                                            }
                                          },
                                          onTapOutside: (_) {
                                            if (kDebugMode) {
                                              print("onTapOutside");
                                              print(
                                                  mapColorTextController.text);
                                            }
                                            if (mapColorTextController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                String newKey =
                                                    mapColorTextController.text;
                                                var newValue = e.value;
                                                _mapColors.remove(e.key);
                                                _mapColors
                                                    .addAll({newKey: newValue});
                                              });
                                            }
                                            if (mapColorTextController
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "The key cannot be empty",
                                                  ),
                                                ),
                                              );
                                            }
                                            if (kDebugMode) {
                                              print(_mapColors);
                                            }
                                          },
                                          onFieldSubmitted: (str) {
                                            if (kDebugMode) {
                                              print("OnEditingComplete");
                                              print(
                                                  mapColorTextController.text);
                                            }
                                            if (mapColorTextController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                var newValue = e.value;
                                                _mapColors.remove(e.key);
                                                _mapColors
                                                    .addAll({str: newValue});
                                              });
                                            }
                                            if (mapColorTextController
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "The key cannot be empty",
                                                  ),
                                                ),
                                              );
                                            }
                                            if (kDebugMode) {
                                              print(_mapColors);
                                            }
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Pick a Color"),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ColorPicker(
                                                      currentColor: idxClr,
                                                      onChange: (clr) {
                                                        setState(() {
                                                          // currColor = clr;
                                                          pickedClr = clr;
                                                        });
                                                        if (kDebugMode) {
                                                          print(
                                                              "Current Color: $idxClr");
                                                          print(
                                                              "Picked Color: $pickedClr");
                                                        }
                                                      },
                                                      onSave: (clr) {
                                                        setState(() {
                                                          idxClr = clr;
                                                          pickedClr = clr;
                                                          _mapColors.update(
                                                              e.key, (value) {
                                                            return clr;
                                                          });
                                                        });
                                                        if (kDebugMode) {
                                                          print(_mapColors);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          idxClr = pickedClr;
                                                          _mapColors.update(
                                                              e.key, (value) {
                                                            return pickedClr;
                                                          });
                                                        });
                                                        if (kDebugMode) {
                                                          print(_mapColors);
                                                        }
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Confirm"),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            color: idxClr,
                                            shape: BoxShape.circle,
                                          ),
                                          height: constraints.maxHeight * 0.07,
                                          width: constraints.maxHeight * 0.07,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialog(
                                                  title: Column(
                                                    children: [
                                                      const Text(
                                                        "Do you really want to delete :",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            e.key,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: idxClr,
                                                            ),
                                                            height: constraints
                                                                    .maxHeight *
                                                                0.04,
                                                            width: constraints
                                                                    .maxHeight *
                                                                0.04,
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  actions: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child:
                                                              TextButton.icon(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            label: const Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child:
                                                              TextButton.icon(
                                                            onPressed: () {
                                                              setState(() {
                                                                _mapColors
                                                                    .remove(
                                                                        e.key);
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color: Colors.red,
                                                            ),
                                                            label: const Text(
                                                              "Delete",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_mapColorsKeyController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Key cannot be empty"),
                              ));
                              return;
                            }
                            var tempString = _mapColorsKeyController.text;
                            setState(() {
                              // if(_tempStrController.text.isNotEmpty){
                              _attributes.update(_mapColorsKeyController.text, (value) => {..._mapColors});
                              if (kDebugMode) {
                                print(_mapColors);
                              }
                              _selectedtype = null;
                              // }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Attributes named $tempString updated"),
                              ),
                            );
                            if (kDebugMode) {
                              print(_attributes);
                            }
                          },
                          child: const Text(
                            "Add Colors to Attributes",
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_attributes.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Attributes: ", style: TextStyle(fontSize: 20)),
                  ),
                ..._attributes.entries.map(
                  (e) {
                    return Column(
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0, left: 20, top: 10, bottom: 5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.key,
                                        style: const TextStyle(fontSize: 20)),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (kDebugMode) {
                                            print("Expanded Pressed");
                                            print(e.value);
                                            print(e.value.runtimeType);
                                          }
                                          if (e.value is List<String> || e.value is List<dynamic>) {
                                            isListExpanded = !isListExpanded;
                                            if (kDebugMode) {
                                              print(isListExpanded);
                                            }
                                          } else if (e.value
                                              is Map<String, dynamic> || e.value is Map<dynamic,dynamic>) {
                                            isMapExpanded = !isMapExpanded;
                                            if (kDebugMode) {
                                              print(isMapExpanded);
                                            }
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isListExpanded == true &&
                                    ((e.value.runtimeType == List<String>) || (e.value.runtimeType == List<dynamic>)))
                                  AttributeListViewer(
                                      e: e, constraints: constraints),
                                if (isMapExpanded == true &&
                                    e.value is Map<String, dynamic>)
                                  AttributeMapColorsViewer(
                                      e: e, constraints: constraints),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _saveForm();
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
// https://assets.winni.in/product/primary/2014/8/46107.jpeg