
import 'package:livin_task/model/invoice_item.dart';
import 'package:livin_task/repository/menu_repo.dart';

final Bill bill = Bill.instance;

class Bill {
  Bill._();
  static final Bill _instance = Bill._();
  static Bill get instance => _instance;
  
  List<String> _groupOneInvoice = [];
  List<String> _groupTwoInvoice = [];
  List<String> _groupThreeInvoice = [];

  List<String> get groupOneInvoice {
    if (_groupOneInvoice.isEmpty) {
      _groupOneInvoice = List.from(_getGroupOneInvoices());
    }
    return _groupOneInvoice;
  }

  List<String> get groupTwoInvoice {
    if (_groupTwoInvoice.isEmpty) {
      _groupTwoInvoice = List.from(_getGroupTwoInvoices());
    }
    return _groupTwoInvoice;
  }

  List<String> get groupThreeInvoice {
    if (_groupThreeInvoice.isEmpty) {
      _groupThreeInvoice = List.from(_getGroupThreeInvoices());
    }
    return _groupThreeInvoice;
  }

  /// Generate Invoice for Group One
  List<String> _getGroupOneInvoices() {
    List<InvoiceItem> items = [
      InvoiceItem(menuRepository.bigBrekkie, 2),
      InvoiceItem(menuRepository.bruchetta, 1),
      InvoiceItem(menuRepository.poachedEggs, 1),
      InvoiceItem(menuRepository.coffee, 1),
      InvoiceItem(menuRepository.tea, 1),
      InvoiceItem(menuRepository.soda, 1),
    ];
    Invoice invoice = Invoice('Group 1', items, splitBy: 3);
    List<InvoiceDetails> splitInvoices = invoice.createSplitInvoices();
    for (InvoiceDetails id in splitInvoices) {
      id.pay(id.total, PaymentMethod.cash);
    }
    return splitInvoices.map((e) => '${_convertToPrintableInvoice(e)}\n').toList();
  }

  /// Generate Invoice for Group Two
  List<String> _getGroupTwoInvoices() {
    List<InvoiceItem> items = [
      InvoiceItem(menuRepository.bigBrekkie, 3),
      InvoiceItem(menuRepository.gardenSalad, 1),
      InvoiceItem(menuRepository.poachedEggs, 1),
      InvoiceItem(menuRepository.coffee, 3),
      InvoiceItem(menuRepository.tea, 1),
      InvoiceItem(menuRepository.soda, 1),
    ];
    Invoice invoice =
    Invoice('Group 2', items, discount: const Discount(10, DiscountType.percentage));
    InvoiceDetails invoiceDetails = invoice.createInvoice();
    invoiceDetails.pay(invoiceDetails.total, PaymentMethod.creditCard);
    return ['${_convertToPrintableInvoice(invoiceDetails)}\n'];
  }

  /// Generate Invoice for Group Three
  List<String> _getGroupThreeInvoices() {
    List<InvoiceItem> items = [
      InvoiceItem(menuRepository.tea, 2),
      InvoiceItem(menuRepository.coffee, 3),
      InvoiceItem(menuRepository.soda, 2),
      InvoiceItem(menuRepository.bruchetta, 5),
      InvoiceItem(menuRepository.bigBrekkie, 5),
      InvoiceItem(menuRepository.poachedEggs, 2),
      InvoiceItem(menuRepository.gardenSalad, 3),
    ];
    Invoice invoice =
    Invoice('Group 3', items, splitBy: 7, discount: const Discount(25, DiscountType.amount));
    List<InvoiceDetails> splitInvoices = invoice.createSplitInvoices();
    for (InvoiceDetails id in splitInvoices) {
      id.pay(id.total, PaymentMethod.cash);
    }
    return splitInvoices.map((e) => '${_convertToPrintableInvoice(e)}\n').toList();
  }

  // convert invoice to string
  String _convertToPrintableInvoice(InvoiceDetails details) {
    String itemsDetails = '';
    for (InvoiceItem item in details.items) {
      itemsDetails =
      '$itemsDetails ${item.menuItem.name} ${item.quantity.toStringAsFixed(2)} ${item.menuItem.price.toStringAsFixed(2)}';
    }
    return 'Invoice no: ${details.invoiceNumber}\nItems: $itemsDetails\nDiscount: ${details.discount}\nGST: ${details.gst.toStringAsFixed(2)}\nSGRT: ${details.sgrt.toStringAsFixed(2)}\nSubtotal: ${details.subTotal.toStringAsFixed(2)}\nTotal: ${details.total.toStringAsFixed(2)}\nPayment details\nCollected: ${details.transaction.collected.toStringAsFixed(2)}\nPaid via: ${details.transaction.paymentMethod.name}';
  }
}
