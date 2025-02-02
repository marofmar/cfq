import 'package:flutter/material.dart';

class RecordInputForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController recordController;
  final String selectedGender;
  final String selectedLevel;
  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<String?> onLevelChanged;
  final VoidCallback onSubmit;

  const RecordInputForm({
    Key? key,
    required this.nameController,
    required this.recordController,
    required this.selectedGender,
    required this.selectedLevel,
    required this.onGenderChanged,
    required this.onLevelChanged,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedGender,
            items: ['male', 'female']
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            onChanged: onGenderChanged,
            decoration: const InputDecoration(labelText: 'Gender'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedLevel,
            items: ['rxd', 'a', 'b', 'c']
                .map((level) => DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    ))
                .toList(),
            onChanged: onLevelChanged,
            decoration: const InputDecoration(labelText: 'Level'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: recordController,
            decoration: const InputDecoration(labelText: 'Record'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Submit Record'),
          ),
        ],
      ),
    );
  }
}
