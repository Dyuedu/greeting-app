import 'package:greeting_app/data/local/daos/contact_dao.dart';
import 'package:greeting_app/data/repositories/contact_repository.dart';
import 'package:greeting_app/data/repositories/greeting_export_repository.dart';
import 'package:greeting_app/data/repositories/impl/contact_repository_impl.dart';
import 'package:greeting_app/data/repositories/impl/greeting_export_repository_impl.dart';
import 'package:greeting_app/viewmodels/contact/contact_import_view_model.dart';
import 'package:greeting_app/viewmodels/contact/contact_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> getProviders() {
    final contactDao = ContactDao();
    return [
      Provider<ContactRepository>(
        create: (_) => ContactRepositoryImpl(contactDao),
      ),
      Provider<GreetingExportRepository>(
        create: (_) => GreetingExportRepositoryImpl(),
      ),
      ChangeNotifierProvider<ContactListViewModel>(
        create: (context) =>
            ContactListViewModel(context.read<ContactRepository>()),
      ),
      ChangeNotifierProvider<ContactImportViewModel>(
        create: (context) =>
            ContactImportViewModel(context.read<ContactRepository>()),
      ),
    ];
  }
}
