import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// Input Fields Widget - Source and Destination input with autocomplete
class InputFields extends StatelessWidget {
  final HomeController controller;

  const InputFields({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Source field with autocomplete
          Obx(() => _AutocompleteTextField(
                label: 'Source',
                hint: 'Enter source location',
                icon: Icons.location_on,
                iconColor: Colors.green,
                value: controller.sourceAddress.value,
                suggestions: controller.sourceSuggestions,
                onChanged: (value) {
                  controller.setSourceAddress(value);
                  controller.getSourceSuggestions(value);
                },
                onSuggestionSelected: (suggestion) {
                  controller.setSourceAddress(suggestion);
                  controller.sourceSuggestions.clear();
                },
              )),
          const SizedBox(height: 16),
          // Destination field with autocomplete
          Obx(() => _AutocompleteTextField(
                label: 'Destination',
                hint: 'Enter destination location',
                icon: Icons.location_on,
                iconColor: Colors.red,
                value: controller.destinationAddress.value,
                suggestions: controller.destinationSuggestions,
                onChanged: (value) {
                  controller.setDestinationAddress(value);
                  controller.getDestinationSuggestions(value);
                },
                onSuggestionSelected: (suggestion) {
                  controller.setDestinationAddress(suggestion);
                  controller.destinationSuggestions.clear();
                },
              )),
          const SizedBox(height: 16),
          // Get Route button
          Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.getRoute(),
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.directions),
                  label: Text(controller.isLoading.value
                      ? 'Getting Route...'
                      : 'Get Route'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

/// Autocomplete Text Field Widget
class _AutocompleteTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final String value;
  final List<String> suggestions;
  final Function(String) onChanged;
  final Function(String) onSuggestionSelected;

  const _AutocompleteTextField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.suggestions,
    required this.onChanged,
    required this.onSuggestionSelected,
  });

  @override
  State<_AutocompleteTextField> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<_AutocompleteTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_AutocompleteTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: Icon(widget.icon, color: widget.iconColor),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: widget.onChanged,
        ),
        if (widget.suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.suggestions.length > 5 ? 5 : widget.suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = widget.suggestions[index];
                return ListTile(
                  leading: const Icon(Icons.place, size: 20),
                  title: Text(suggestion),
                  onTap: () => widget.onSuggestionSelected(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }
}

