import 'package:get/get.dart';
import 'package:marocsie/app/data/models/delivery.dart';

class DeliveryItemSelection {
  final DeliveryItem item;
  RxBool selected;
  RxInt quantity;

  DeliveryItemSelection({
    required this.item,
    bool selected = true,
    int? quantity,
  })  : selected = RxBool(selected),
        quantity = RxInt(quantity ?? double.parse(item.quantity).toInt());
}

class DeliveryDetailController extends GetxController {
  final RxList<DeliveryItemSelection> itemSelections = <DeliveryItemSelection>[].obs;

  void initialize(List<DeliveryItem> items) {
    print("Allocated Items in initialize selection: ${items.map((item) => item.toJson())}");
    itemSelections.assignAll(items.map((item) => DeliveryItemSelection(item: item, quantity: double.parse(item.quantity).toInt())));
  }

  void selectItem(int index, bool value) {
    itemSelections[index].selected.value = value;
    if (!value) {
      itemSelections[index].quantity.value = 1;
    }
  }

  void changeQuantity(int index, int value) {
    final maxQty = double.parse(itemSelections[index].item.quantity).toInt();
    print("Quantity in change quantity: $value with maxQty: $maxQty");
    if (value >= 1 && value <= maxQty) {
      itemSelections[index].quantity.value = value;
    }
    update();
  }

  void removeItem(int index) {
    itemSelections.removeAt(index);
  }

  List<Map<String, dynamic>> get selectedItems => itemSelections
      .where((s) => s.selected.value)
      .map((s) => {'id': s.item.id, 'quantity': s.quantity.value})
      .toList();

  int get selectedCount => itemSelections.where((s) => s.selected.value).length;

  double get selectedTotal => itemSelections
      .where((s) => s.selected.value)
      .fold<double>(0, (sum, s) => sum + (double.tryParse(s.item.unitPrice) ?? 0) * s.quantity.value);
} 