import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final RxString selectedValue; // selected value reactive
  final List<String> items; // category list or any item list
  final String hint; // placeholder text
  final Function(String) onChanged; // callback when item selected

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.hint = "Select",
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => _showDialog(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFE5E5FF)),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedValue.value.isEmpty ? hint : selectedValue.value,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded),
            ],
          ),
        ),
      );
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
          title: Text(hint),
          content: Obx(() => SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              shrinkWrap: true,
              children: items.map((item) {
                return GestureDetector(
                  onTap: () {
                    selectedValue.value = item;
                    onChanged(item);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E5FF)),
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              item,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              selectedValue.value == item
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )),
        );
      },
    );
  }
}
