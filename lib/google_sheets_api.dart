
import 'package:gsheets/gsheets.dart';

class GoogleSheetsAPI {
  static const _credentials = r'''

  // Copy Your GoogleSheet API Code from json file Over Here
''';

  static final _spreedSheetId = " Your Spread Sheed ID ";
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreedSheetId);
    _worksheet = ss.worksheetByTitle("Title Of the Work Sheet");
    countRows();
  }

  static Future countRows () async {
    while ((await _worksheet!.values
      .value(column: 1, row: numberOfTransactions + 1)) !=
    '') {
      numberOfTransactions++;
    }

    loadTransactions();
  }

  static Future loadTransactions() async {
    if(_worksheet == null) return;

    for (int i=1; i< numberOfTransactions; i++)
    {
      final String transactionName = 
        await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount = 
        await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType = 
        await _worksheet!.values.value(column: 3, row: i + 1);

      if(currentTransactions.length < numberOfTransactions)
      {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);

    loading = false;
  }

  static Future insert (String name, String amount, bool _isIncome) async {
    if(_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense'
    ]);
  }

  static double calculateIncome ()
  {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++)
    {
      if(currentTransactions[i][2] == 'income')
      {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }

    return totalIncome;
  }

  static double calculateExpense ()
  {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++)
    {
      if(currentTransactions[i][2] == 'expense')
      {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }

    return totalExpense;
  }


}
