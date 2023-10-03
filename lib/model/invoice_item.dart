import 'package:livin_task/model/menu_item.dart';
import 'package:livin_task/repository/invoice_repo.dart';
import 'package:livin_task/utils/app_const.dart';

enum PaymentMethod { cash, creditCard }
enum DiscountType { percentage, amount }

class InvoiceItem {
  final MenuItem menuItem;
  final double quantity;

  const InvoiceItem(this.menuItem, this.quantity);

  String getQuantityFraction(int splitBy) {
    return '$quantity/$splitBy';
  }

  InvoiceItem copyWith({MenuItem? menuItem, double? quantity}) {
    return InvoiceItem(menuItem ?? this.menuItem, quantity ?? this.quantity);
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(MenuItem.fromJson(json['menuItem']), json['quantity']);
  }

  @override
  String toString() {
    return 'Item name: ${menuItem.name}, Quantity: $quantity, Amount: \$${quantity * menuItem.price}';
  }
}

class Transaction {
  final PaymentMethod paymentMethod;
  final double collected;

  const Transaction({this.paymentMethod = PaymentMethod.cash, this.collected = 0.0});

  Transaction copyWith({PaymentMethod? paymentMethod, double? collected, double? returned}) {
    return Transaction(
        paymentMethod: paymentMethod ?? this.paymentMethod, collected: collected ?? this.collected);
  }
}

class TaxDetails {
  String description;
  double taxPercentage;

  TaxDetails(this.description, this.taxPercentage);
}

class InvoiceDetails {
  final int invoiceNumber;
  final String groupName;
  final int splitBy;
  final List<InvoiceItem> items;
  final double discount;
  final double gst;
  final double sgrt;
  final double subTotal;
  final List<TaxDetails> taxDetails;
  final double total;
  Transaction transaction;

  double get returned => transaction.collected - total;

  double get paid => transaction.collected;

  InvoiceDetails(this.invoiceNumber, this.groupName, this.splitBy, this.items, this.discount,
      this.gst, this.sgrt, this.subTotal, this.taxDetails, this.total,
      {this.transaction = const Transaction()});

  /// Used to pay the invoice
  void pay(double collectedAmount, PaymentMethod paymentMethod) {
    transaction = transaction.copyWith(paymentMethod: paymentMethod, collected: collectedAmount);
  }

  @override
  String toString() {
    return 'Invoice Number:$invoiceNumber\nGroupName:$groupName\nsplitBy:$splitBy\nItems:${items.join(',')}\nDiscount:$discount\nSubTotal:$subTotal\nGST:$gst\nSGRT:$sgrt\nTotal:$total\nPaid:$paid\nReturned:$returned\nPayment method:${transaction.paymentMethod}';
  }
}

class Invoice {
  final String groupName;
  final List<InvoiceItem> items;
  final int splitBy;
  final Discount discount;

  const Invoice(this.groupName, this.items,
      {this.splitBy = 1, this.discount = const Discount(0, DiscountType.amount)});

  /// Used to create the master invoice
  InvoiceDetails createInvoice() {
    InvoiceDetails details =
    _getInvoiceDetails(invoiceRepository.getNextInvoiceNumber(), items);
    invoiceRepository.saveInvoice(details);
    return details;
  }

  /// Used to create split invoices if the bill is split
  List<InvoiceDetails> createSplitInvoices() {
    List<InvoiceDetails> invoices = [];
    int i = 0;
    while (i < splitBy) {
      InvoiceDetails details = _getInvoiceDetails(
          invoiceRepository.getNextInvoiceNumber(), items,
          splitBy: splitBy);
      invoices.add(details);
      invoiceRepository.saveInvoice(details);
      i++;
    }
    return invoices;
  }

  InvoiceDetails _getInvoiceDetails(int invoiceNumber, List<InvoiceItem> items, {int splitBy = 1}) {
    if (splitBy < 1) {
      throw InvoiceException(message: 'Split value cannot be less than 1');
    }
    List<InvoiceItem> itemWithoutTaxes = List.from(items);
    itemWithoutTaxes = itemWithoutTaxes
        .map((e) => e.copyWith(
        quantity: e.quantity / splitBy,
        menuItem: e.menuItem
            .copyWith(name: e.menuItem.name, price: _reduceIncludingTax(e.menuItem.price))))
        .toList();

    double subTotal = _sumItemTotals(itemWithoutTaxes);

    double discountAmount = discount.value > 0
        ? discount.discountType == DiscountType.amount
        ? discount.value / splitBy
        : _calculateDiscountAmount(subTotal, discount.value)
        : 0.0;

    subTotal = subTotal - discountAmount;
    double gst = (subTotal * appConst.gstPercentage) / 100;
    double sgrt =
    appConst.isSgrtApplicable ? (subTotal * appConst.sgrtPercentage) / 100 : 0.0;

    List<TaxDetails> taxDetails = [];
    taxDetails.add(TaxDetails('GST ${appConst.gstPercentage}%', gst));
    if (appConst.isSgrtApplicable) {
      taxDetails.add(TaxDetails('SGRT ${appConst.sgrtPercentage}%', sgrt));
    }
    double total = (subTotal + gst + sgrt);
    return InvoiceDetails(invoiceNumber, groupName, splitBy, itemWithoutTaxes, discountAmount, gst,
        sgrt, subTotal, taxDetails, total);
  }

  double _sumItemTotals(List<InvoiceItem> items) {
    return items.fold(0.0,
            (previousValue, element) => previousValue + (element.menuItem.price * element.quantity));
  }

  double _calculateDiscountAmount(double amount, double discountPercentage) {
    if (amount <= 0.0 || discountPercentage < 0.0 || discountPercentage > 100.0) {
      return 0.0;
    }
    return amount * (discountPercentage / 100.0);
  }

  double _reduceIncludingTax(double price) {
    double taxPercentage = appConst.gstPercentage +
        (appConst.isSgrtApplicable ? appConst.sgrtPercentage : 0.0);
    return (price * 100.0) / (100.0 + taxPercentage);
  }
}

class InvoiceException implements Exception {
  String message;
  Object? error;

  InvoiceException({required this.message, this.error});
}

class Discount {
  final double value;
  final DiscountType discountType;

  const Discount(this.value, this.discountType);
}
