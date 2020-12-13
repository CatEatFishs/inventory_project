import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/provider/default_provider.dart';

class TestProvider extends DefaultProvider {
  final String tableName = 'TestDateBaseTable';

  init() async {
    setTableName(tableName);
    super.init();
  }
}
