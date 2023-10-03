import 'package:livin_task/model/invoice_item.dart';
import 'package:livin_task/model/menu_item.dart';
import 'package:livin_task/utils/app_const.dart';

final menuRepository = MenuRepo.instance;

class MenuRepo {
  MenuRepo._();

  static final MenuRepo _instance = MenuRepo._();

  static MenuRepo get instance => _instance;

  MenuItem bigBrekkie = MenuItem(appConst.bigBrekkie, 16);
  MenuItem bruchetta = MenuItem(appConst.bruchetta, 8);
  MenuItem poachedEggs = MenuItem(appConst.poachedEggs, 12);
  MenuItem coffee = MenuItem(appConst.coffee, 5);
  MenuItem tea = MenuItem(appConst.tea, 3);
  MenuItem soda = MenuItem(appConst.soda, 4);
  MenuItem gardenSalad = MenuItem(appConst.gardenSalad, 10);

  /// Getter to mock the menu item list
  List<InvoiceDetails> get menuItems => List.unmodifiable([bigBrekkie, bruchetta, poachedEggs, coffee, tea, soda, gardenSalad]);
}
