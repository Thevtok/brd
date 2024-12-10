import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/address.dart';

class AddressItem extends StatelessWidget {
  final Address address;
  final bool isLoading;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetPrimary;

  const AddressItem({
    super.key,
    required this.address,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
    required this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Shimmer effect while loading
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 80,
        ),
      );
    }

    // Regular address item display
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: address.primary ? Colors.orange.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: address.primary ? Colors.orange : Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.addressLabel ?? 'Unknown Address',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  address.address ?? 'No Address',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  address.phoneNumber ?? 'No Phone Number',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
              IconButton(
                icon: Icon(
                  address.primary ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                ),
                onPressed: onSetPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
