import 'package:flutter/material.dart';

enum MessageType { reminder, cancellation }

class MessageTypeSelector extends StatelessWidget {
  final MessageType selectedType;
  final ValueChanged<MessageType> onChanged;

  const MessageTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onChanged(MessageType.reminder),
          child: Row(
            children: [
              Radio<MessageType>(
                value: MessageType.reminder,
                groupValue: selectedType,
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
              const Text('Reminder'),
            ],
          ),
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () => onChanged(MessageType.cancellation),
          child: Row(
            children: [
              Radio<MessageType>(
                value: MessageType.cancellation,
                groupValue: selectedType,
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
              const Text('Cancellation'),
            ],
          ),
        ),
      ],
    );
  }
} 