import 'package:flutter/material.dart';
import 'package:travel/controllers/travels_controller.dart';
import 'package:travel/models/travel.dart';
import 'package:travel/views/widgets/edit_travel_bottom_modal.dart';

class TravelManageDialog extends StatefulWidget {
  final Travel travel;
  const TravelManageDialog({required this.travel, super.key});

  @override
  State<TravelManageDialog> createState() => _TravelManageDialogState();
}

class _TravelManageDialogState extends State<TravelManageDialog> {
  final _travelController = TravelsController();
  bool isSinglePress = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
      ],
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(children: [
              const TextSpan(
                text: "Manage ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: widget.travel.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return EditTravelBottomModal(
                        travel: widget.travel,
                      );
                    },
                  );
                },
                child: const Text("Edit"),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onLongPress: () async {
                  await _travelController.deleteTravel(widget.travel.id);
                  Navigator.pop(context, true);
                },
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isSinglePress = true;
                    });

                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        isSinglePress = false;
                      });
                    });
                  },
                  // onLongPress: ,
                  child: const Text("Delete"),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (isSinglePress)
            const Text(
              "Long press to delete",
              style: TextStyle(color: Colors.red),
            )
        ],
      ),
    );
    ;
  }
}
