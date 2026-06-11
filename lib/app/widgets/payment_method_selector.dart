import 'package:flutter/material.dart';

enum PaymentMethod { cash, bank }

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onChanged;

  const PaymentMethodSelector({
    Key? key,
    required this.selectedMethod,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onChanged(PaymentMethod.cash),
          child: Row(
            children: [
              Radio<PaymentMethod>(
                value: PaymentMethod.cash,
                groupValue: selectedMethod,
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
              const Text('Cash'),
            ],
          ),
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () => onChanged(PaymentMethod.bank),
          child: Row(
            children: [
              Radio<PaymentMethod>(
                value: PaymentMethod.bank,
                groupValue: selectedMethod,
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
              const Text('Bank'),
            ],
          ),
        ),
      ],
    );
  }
} 