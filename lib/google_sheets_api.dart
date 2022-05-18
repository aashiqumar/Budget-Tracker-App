
import 'package:gsheets/gsheets.dart';

class GoogleSheetsAPI {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "misttapp",
  "private_key_id": "2b35dc5c23404381aed12f39fea50d45bf075803",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDC/VkOzIri3Fx6\nJ0veQXtXdarusctyDfeqRTqm4mZCpxZ3btQ+YGa/6iSpCO/7yaVlD/XTXe5DnMKa\nvrCq/pKUMpPGj77OeSQMcGzo+mRQo+hNsDJK2LC7LdU42ecnN/Kc1dyUtsUXlfoS\nC6dZfR6DNBNeBqVNJ9w6Y8wfW40R4GVrTgWK6TQNKd8AKfwcLe7nLoGYa8kNDJSx\nATyqsf0ghlgDnRWrN1WG1X97vWfx7KKVYKSb2UQjLB1kWgJ977kc12N0hmp8PwvN\n7SsZocCtRFNehG8P3ZbOCTtTaJFo/O1d1xoVdOHEI3aBMLiQWLgU3qABO1FmC5sG\nu5DukbaTAgMBAAECggEAAXYDvM/jJrVWEugLhIeQsZg10xfWhB3IMv4GXwzJUIH2\n2YLQB1nnqCMhv2D2t41kwoad/j9w+TSG6eW4cn1Cxc4QixsvegySIJNygIG4KiD9\n/DiOg1cmNcDUEO0seULxrIUQv2BRfYtetK9WPXmaheBiNAECpffTD7/8oRNUP3SB\nVDJE9f1wHDJr6+aK3SyzHspiBSVi3yME5qLRDufAju8iF4yW4+VoTN8T+EdUTuiV\nai6PmZOucDyCZ5ZkxMpvP6bZqGTpNGIs2gRb1cgWCGH5Tno49fiMzKjU4N2T9fj2\n92XDhBSprsUFAR3C1v/sExRu2t0/bo1Iur7xondUwQKBgQDwL40BmczlNm27jDXX\n8zV51maEG1Dr4kkszcS2rTsuxrZA+L/7HEhJguEGj8ZhJi24BHsTf6mMWKMLXGbP\n4GKlXD4ADN7FKCMdDowteuDnRqCAtilFBZn9IG9fn4489YfX8B6PxNBSFkK+SqbR\n92A3XQ9YYht038Xu6PiOJXf5tQKBgQDP0/6TMsoVYmxvzApu4hkSuYF147H99j1t\nlCQOU9TTmoUUJ43hTlTtbyC4NufstFeSu0+vbLKW9xMdAMgDrHbpjcE4gNRK4oiF\nScU2sfWs3jIiqICYj7uAt/jIi9g2AEgB+adU7A5kLtovJ8pe2kL3HAnaKQBHLgRP\nJ3cLlVt8JwKBgQCG15tJL8hpUqJObYv4/fCiwyxwtEk89KByR99NU3nra+H8Heri\nFmG664Bbx7Hu7pkyO0nBi6VrRoPap/iMcgPPpDamnpMeiscT1Av8qITFMtB/EkWf\nG2L1ShVc0N3w+UNXhtYRjsQJobe8z3pSXJgm3Nb1nradadfcpeyNGRn/FQKBgQCg\nsSjIxd+M01JGyvxSKg369WZNMeYhGHD8tit+zIDlsDcvkznXuIpgH6mr5gBDfFmu\nAZimaiRYJ+gmZ8E/Xe1/vnRk7O+4ixnF/Xk4RjdQF2mqdKEh1RjEePsqjT562pLS\nvCcOuYqTGcrn5RtLZfWbPZm8jjFB2CnKzhf04+IdxwKBgQC9o55QC2fviJ8gQ8SR\nfIhV6kuanorgZjbj4vjXlpULiquICpBKun8j/vS6YJBJL2lQ5ZXiwxKx1x70PuaO\nzNSg13k7xh3IwKHIa2giPa1GygNGpys3N4lVoHgi/KBhvasuCzBL47+jjDhv0wBR\nhG71ujDLvQ7jd/pBqyPyW+E73A==\n-----END PRIVATE KEY-----\n",
  "client_email": "misttapp@misttapp.iam.gserviceaccount.com",
  "client_id": "107774659351603811858",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/misttapp%40misttapp.iam.gserviceaccount.com"
}

''';

  static final _spreedSheetId = "1EtAGfZcwvy9kya4GvZ9oXq6xXNlL5iDqtc9_Q8SEQnE";
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreedSheetId);
    _worksheet = ss.worksheetByTitle("mistt");
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