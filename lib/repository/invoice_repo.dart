import 'package:livin_task/model/invoice_item.dart';

final invoiceRepository = InvoiceRepo.instance;

class InvoiceRepo {
  InvoiceRepo._();

  static final InvoiceRepo _instance = InvoiceRepo._();

  static InvoiceRepo get instance => _instance;

  final List<InvoiceDetails> _invoices = List.empty(growable: true);

  /// Getter to get the saved invoices
  List<InvoiceDetails> get invoices => List.unmodifiable(_invoices);

  /// function to save the Invoice details to Invoice repository
  void saveInvoice(InvoiceDetails invoiceDetails) {
    _invoices.add(invoiceDetails);
  }

  /// Gives the next invoice number
  int getNextInvoiceNumber() {
    if (_invoices.isEmpty) {
      return 1;
    }
    return _invoices.last.invoiceNumber + 1;
  }
}
