import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel/controllers/travels_controller.dart';
import 'package:travel/models/travel.dart';
import 'package:travel/services/location_service.dart';

class EditTravelBottomModal extends StatefulWidget {
  final Travel travel;
  const EditTravelBottomModal({required this.travel, super.key});

  @override
  State<EditTravelBottomModal> createState() => _EditTravelBottomModalState();
}

class _EditTravelBottomModalState extends State<EditTravelBottomModal> {
  final myLocation = LocationService.currentLocation;

  final _travelsController = TravelsController();

  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? imageFile;
  bool showNoImageText = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await LocationService.getCurrentLocation();
    }).then((_) => setState(() {}));

    _titleController.text = widget.travel.title;
  }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }

    if (imageFile == null) {
      setState(() {
        showNoImageText = true;
      });
    } else {
      setState(() {
        showNoImageText = false;
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }

    if (imageFile == null) {
      setState(() {
        showNoImageText = true;
      });
    } else {
      setState(() {
        showNoImageText = false;
      });
    }
  }

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate() && imageFile != null) {
      _travelsController.updateTravel(
          id: widget.travel.id,
          title: _titleController.text,
          location: myLocation.toString(),
          imageFile: imageFile!);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pop(context, true);
      });
    }

    if (_formKey.currentState!.validate()) {
      _travelsController.updateSomeTravelFields(
          id: widget.travel.id,
          title: _titleController.text,
          location: myLocation.toString());
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop(true);
        // Navigator.pop(context);
      });
    }

    if (imageFile == null) {
      setState(() {
        showNoImageText = true;
      });
    } else {
      setState(() {
        showNoImageText = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Image.asset("assets/images/tourist.png"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: openCamera,
                          label: const Text("Take a picture"),
                          icon: const Icon(Icons.camera),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.433,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: openGallery,
                          label: const Text("From gallery"),
                          icon: const Icon(Icons.photo),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  imageFile != null
                      ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(imageFile!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.travel.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title",
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Enter a title";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _validateAndSubmit,
                      child: const Text("Save"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
