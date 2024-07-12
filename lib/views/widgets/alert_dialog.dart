import 'package:dars9/cubits/restorant_cubit.dart';
import 'package:dars9/cubits/restorant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AlertDialogs extends StatefulWidget {
  final Point location;

  const AlertDialogs({
    super.key,
    required this.location,
  });

  @override
  State<AlertDialogs> createState() => _AlertDialogsState();
}

class _AlertDialogsState extends State<AlertDialogs> {
  final nameTextController = TextEditingController();
  final imageUrlController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: AlertDialog(
          title: const Text("Add Restorant"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: nameTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Phone Number",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Phone Number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "ImageUrl",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input ImageUrl";
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            ZoomTapAnimation(
              onTap: () {
                nameTextController.clear();
                imageUrlController.clear();
                phoneNumberController.clear();
                Navigator.pop(context);
              },
              child: Container(
                width: 75,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                    child: Text(
                  "Close",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
            BlocConsumer<RestorantCubit, RestorantState>(
              listener: (context, state) {
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is LoadingState) {
                  return const CircularProgressIndicator();
                }
                return ZoomTapAnimation(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<RestorantCubit>().addProducts(
                            id: DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                            name: nameTextController.text,
                            phoneNumber: phoneNumberController.text,
                            imageUrl: imageUrlController.text,
                            location: widget.location,
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 75,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.blue.shade400,
                    ),
                    child: const Center(
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
