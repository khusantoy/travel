import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travel/controllers/travels_controller.dart';
import 'package:travel/models/travel.dart';
import 'package:travel/views/widgets/add_travel_bottom_modal.dart';
import 'package:travel/views/widgets/travel_card.dart';
import 'package:travel/views/widgets/travel_manage_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _travelsController = TravelsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Travels"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _travelsController.list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No travels"),
            );
          }

          final travels = snapshot.data!.docs;

          return travels.isEmpty
              ? const Center(
                  child: Center(
                    child: Text("No travels"),
                  ),
                )
              : MasonryGridView.builder(
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  itemCount: travels.length,
                  itemBuilder: (context, index) {
                    final travel = Travel.fromQuerySnapshot(travels[index]);

                    return GestureDetector(
                      onLongPress: () async {
                        final data = await showDialog(
                          context: context,
                          builder: (context) {
                            return TravelManageDialog(
                              travel: travel,
                            );
                          },
                        );
                        if (data) {
                          Future.delayed(const Duration(seconds: 1), () {
                            return ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("Applied the changes."),
                              ),
                            );
                          });
                        }
                      },
                      child: TravelCard(travel: travel),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final data = await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return const AddTravelBottomModal();
            },
          );

          if (data) {
            Future.delayed(const Duration(seconds: 1), () {
              return ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("New travel added successfully"),
                ),
              );
            });
          }
        },
        label: const Text("New travel"),
        icon: const Icon(Icons.add_location_alt),
      ),
    );
  }
}
