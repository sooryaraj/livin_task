final appConst = AppConst.instance;

class AppConst {
  AppConst._();
  static final AppConst _instance = AppConst._();
  static AppConst get instance => _instance;

  final double gstPercentage = 10.0;
  final double sgrtPercentage = 2.0;
  final bool isSgrtApplicable = false;

  final String bigBrekkie = 'Big Brekkie';
  final String bruchetta = 'Bruchetta';
  final String poachedEggs = 'Poached Eggs';
  final String coffee = 'Coffee';
  final String tea = 'Tea';
  final String soda = 'Soda';
  final String gardenSalad = 'Garden Salad';
}
