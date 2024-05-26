import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name;
  double? _price;
  double? _mrp;
  String? _productCode;
  String? _category;
  int? _quantity;
  String? _imageURL;

  List<Widget> buildFormFields() {
    List<Widget> formFields = [];

    final nameController = TextEditingController(text: _name ?? "");
    final priceController =
        TextEditingController(text: _price?.toString() ?? "");
    final mrpController = TextEditingController(text: _mrp?.toString() ?? "");
    final productCodeController =
        TextEditingController(text: _productCode ?? "");
    final categoryController = TextEditingController(text: _category ?? "");
    final quantityController =
        TextEditingController(text: _quantity?.toString() ?? "");
    final imageURLController = TextEditingController(text: _imageURL ?? "");
    // Map each field to a TextFormField widget
    // Add more fields as needed
    for (var field in [
      {
        'label': 'Name',
        'value': _name,
        'onChanged': (value) => _name = value,
        'controller': nameController
      },
      {
        'label': 'Price',
        'value': _price,
        'onChanged': (value) => _price = double.tryParse(value),
        'controller': priceController
      },
      {
        'label': 'MRP',
        'value': _mrp,
        'onChanged': (value) => _mrp = double.tryParse(value),
        'controller': mrpController
      },
      {
        'label': 'Product Code',
        'value': _productCode,
        'onChanged': (value) => _productCode = value,
        'controller': productCodeController
      },
      {
        'label': 'Category',
        'value': _category,
        'onChanged': (value) => _category = value,
        'controller': categoryController
      },
      {
        'label': 'Quantity',
        'value': _quantity,
        'onChanged': (value) => _quantity = int.tryParse(value.toString()),
        'controller': quantityController
      },
      {
        'label': 'Image URL',
        'value': _imageURL,
        'onChanged': (value) => _imageURL = value,
        'controller': imageURLController
      },
    ]) {
      formFields.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            cursorColor: Theme.of(context).colorScheme.inversePrimary,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              labelText: field['label'] as String,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            // controller: field['controller'] as TextEditingController,
            onChanged: (value) {
              // Safely update the controller's text property
              (field['controller'] as TextEditingController).text = value;
              setState(() {
                (field['onChanged'] as void Function(String)).call(value);
              });
            },
          ),
        ),
      );
    }

    return formFields;
  }

  void _createProduct() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Check if all required fields are filled
    // if (_name == null ||
    //     _price == null ||
    //     _mrp == null ||
    //     _productCode == null ||
    //     // _category == null ||
    //     _quantity == null ||
    //     // _imageURL == null ||
    //     _name == '' ||
    //     _productCode == '') {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please fill all required fields!'),
    //     ),
    //   );
    //   return;
    // }

    // Validate format of numeric fields
    // if (_price! <= 0 || _mrp! <= 0 || _quantity! <= 0) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please enter valid prices and quantities!'),
    //     ),
    //   );
    //   return;
    // }

// Create a map with product data
    Map<String, dynamic> productData = {
      'name': _name,
      'price': _price,
      'mrp': _mrp,
      'productCode': _productCode,
      'category': _category,
      'quantity': _quantity,
      'imageURL': _imageURL,
    };

    // Add the product data to Firestore
    firestore.collection('products').add(productData).then((value) {
      // Product added successfully
      setState(() {
        // Clear all fields after successful addition
        _name = '';
        _price = null;
        _mrp = null;
        _productCode = '';
        _category = '';
        _quantity = null;
        _imageURL = '';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully!'),
          ),
        );
      }
    }).catchError((error) {
      // Error adding product 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding product: $error'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ...buildFormFields(),
              SizedBox(height: 16.0),
              // Add similar TextFormField widgets for other fields

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form fields are valid, proceed with product creation

                    _createProduct();
                  }
                },
                child: Text(
                  'Add Product',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
