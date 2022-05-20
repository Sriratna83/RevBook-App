import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revbook_app/models/book.dart';
import 'package:revbook_app/viewModel/book_view_model.dart';

import 'package:revbook_app/utils/validator.dart' as validator;

class EditBookScreen extends StatefulWidget {
  static const String routeName = "EditBookScreen";

  const EditBookScreen({Key? key}) : super(key: key);

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late final FocusNode _ratingFocusNode;
  late final FocusNode _descriptionFocusNode;
  late final FocusNode _imageUrlFocusNode;

  final _form = GlobalKey<FormState>();

  late final TextEditingController _imageUrlController;

  late final Book _editBook;
  bool _isInit = false;

  bool _isLoading = false;

  @override
  void initState() {
    _ratingFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _imageUrlFocusNode = FocusNode();
    _imageUrlFocusNode.addListener(_updateImageUrl);

    _editBook = Book();

    _imageUrlController = TextEditingController();
    // _imageUrlController.text = _editBook.imageUrl;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final bookId = ModalRoute.of(context)!.settings.arguments;

    if (!_isInit && bookId != null) {
      Books findedBook = Provider.of<BookViewModel>(context, listen: false)
          .findById(bookId as String);

      _editBook.id = findedBook.id;
      _editBook.title = findedBook.title;
      _editBook.description = findedBook.description;
      _editBook.rating = findedBook.rating;
      _editBook.imageUrl = findedBook.imageUrl;
      _editBook.isBookmark = findedBook.isBookmark;

      _imageUrlController.text = _editBook.imageUrl;
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _ratingFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    _imageUrlController.dispose();

    super.dispose();
  }

  void _saveForm(BuildContext context) async {
    try {
      final isValid = _form.currentState!.validate();
      if (!isValid) return;

      _form.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      final booksProvider = Provider.of<BookViewModel>(context, listen: false);
      // edit old book
      if (_editBook.id != null) {
        await booksProvider.updateBook(_editBook);
      }
      // new Book
      else {
        await booksProvider.addBook(_editBook);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            _editBook.id != null ? "Error edit" : "Error create",
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          content: Text(
            'Error: ${e.toString()}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Okay"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
            ),
            onPressed: () => _saveForm(context),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(14),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_ratingFocusNode);
                      },
                      validator: (v) {
                        if (v!.isEmpty) return "This field empty!";
                        return null;
                      },
                      initialValue: _editBook.title,
                      onSaved: (v) {
                        _editBook.title = v!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Rating',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _ratingFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      initialValue: _editBook.rating.toString(),
                      validator: (v) {
                        if (v!.isEmpty) return "This field empty!";
                        if (double.tryParse(v) == null) {
                          return "It isn't rating!";
                        }
                        if (double.parse(v) <= 0) {
                          return "Please enter real number for Rating";
                        }
                        return null;
                      },
                      onSaved: (v) {
                        _editBook.rating = int.parse(v!);
                      },
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Review',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (v) {
                          if (v!.isEmpty) return "This field empty!";
                          if (v.length < 10) {
                            return "Please enter more 10 symbols";
                          }
                          return null;
                        },
                        initialValue: _editBook.description,
                        onSaved: (v) {
                          _editBook.description = v!;
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Center(
                                  child: Text("Enter a url"),
                                )
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlController,
                            // initialValue: _editBook.imageUrl,
                            focusNode: _imageUrlFocusNode,
                            decoration: const InputDecoration(
                              labelText: 'Image url',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            validator: (v) {
                              validator.validatorImage validResult =
                                  validator.isUrlImage(v!);

                              switch (validResult) {
                                case validator.validatorImage.fieldEmpty:
                                  return validator
                                      .errorString[validResult.index];
                                case validator.validatorImage.notUrl:
                                  return validator
                                      .errorString[validResult.index];
                                case validator.validatorImage.notImage:
                                  return validator
                                      .errorString[validResult.index];
                                default:
                                  return null;
                              }
                            },
                            onSaved: (v) {
                              _editBook.imageUrl = v!;
                            },
                            onEditingComplete: () {
                              validator.validatorImage validResult =
                                  validator.isUrlImage(_editBook.imageUrl);

                              if (validResult !=
                                  validator.validatorImage.valid) {
                                return;
                              }

                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _saveForm,
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
