import 'package:digimobile/providers/customers.dart';
import 'package:digimobile/providers/document.dart';
import 'package:digimobile/widgets/digi_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/services.dart';

// ignore: must_be_immutable
class NewDoucmentScreen extends StatelessWidget {
  static const routeName = '/new-doucment';

  final _formKey = GlobalKey<FormState>();
  String _error;

  int _doucmentInternalId;
  final _dateController = TextEditingController();
  int _customerId;
  int _serviceId;
  DateTime _dateTime;
  double _cost;

  void _showDialogWithMessage(
      BuildContext context, String title, String error) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor:
            error == null ? Colors.green[400] : Theme.of(context).errorColor,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              error == null ? AppLocalizations.of(context).success : error,
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).confirm,
                style: TextStyle(
                  color: error == null
                      ? Colors.green[400]
                      : Theme.of(context).errorColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchData(BuildContext context, String title) async {
    try {
      await Provider.of<Customers>(context, listen: false)
          .fetchAndSetCustomerList();
      await Provider.of<Services>(context, listen: false)
          .fetchAndSetServicesList();
    } catch (error) {
      _showDialogWithMessage(context, title, error);
    }
  }

  Future<bool> _showDialogLoading(
      BuildContext context, String title, int documentType) async {
    return await showDialog<bool>(
        context: context,
        builder: (ctx) => SimpleDialog(
              children: [
                FutureBuilder<bool>(
                  future: Provider.of<Document>(context, listen: false)
                      .createNewDocument(_customerId, _dateTime,
                          _doucmentInternalId, documentType, _serviceId, _cost),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done)
                      Navigator.of(ctx).pop(snapshot.data);
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text(AppLocalizations.of(context).loading,
                              style: Theme.of(context).textTheme.headline1),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ));
  }

  void _showDateAndTime(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (date == null) return;
    final time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    _dateTime = date.add(Duration(hours: time.hour, minutes: time.minute));

    _dateController.text = DateFormat('yyyy/MM/dd hh:mm aa').format(_dateTime);
  }

  Future<void> _submitNewDoucment(
      BuildContext context, String title, int documentType) async {
    bool valid = _formKey.currentState.validate();
    if (!valid) return;
    _formKey.currentState.save();

    try {
      final result = await _showDialogLoading(context, title, documentType);

      if (result) return _showDialogWithMessage(context, title, null);
      _showDialogWithMessage(
        context,
        title,
        AppLocalizations.of(context).failed,
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final argment =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final title = argment['title'];
    final documentType = argment['id'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: FutureBuilder(
        future: _fetchData(context, title),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (snapshot.connectionState == ConnectionState.waiting)
                      Center(child: CircularProgressIndicator()),
                    SizedBox(height: 16),
                    if (_error != null)
                      Text(
                        _error,
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _showDateAndTime(context);
                      },
                      decoration: InputDecoration(
                        label: Text(
                            AppLocalizations.of(context).document_internal_id),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context)
                              .error_document_internal;
                        return null;
                      },
                      onSaved: (value) =>
                          _doucmentInternalId = int.parse(value.trim()),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        _showDateAndTime(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context)
                                .document_issue_date),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return AppLocalizations.of(context)
                                  .error_doucment_date;
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Consumer<Customers>(
                      builder: (ctx, data, _) => DropdownButtonFormField(
                        isExpanded: true,
                        menuMaxHeight: 300,
                        validator: (value) {
                          if (value == null)
                            return AppLocalizations.of(context)
                                .error_choose_customer;
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            label:
                                Text(AppLocalizations.of(context).document_to),
                            border: OutlineInputBorder()),
                        items: data.customerList.isNotEmpty
                            ? data.customerList
                                .map((e) => DropdownMenuItem(
                                      child: Text(e.name),
                                      value: e.id,
                                    ))
                                .toList()
                            : [],
                        onChanged: (value) {
                          _customerId = value;
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Consumer<Services>(
                      builder: (ctx, data, _) => DropdownButtonFormField<int>(
                        isExpanded: true,
                        menuMaxHeight: 300,
                        validator: (value) {
                          if (value == null)
                            return AppLocalizations.of(context)
                                .error_choose_service;
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            label: Text(AppLocalizations.of(context).services),
                            border: OutlineInputBorder()),
                        items: data.services.isNotEmpty
                            ? data.services
                                .map((e) => DropdownMenuItem(
                                      child: Text(e.name),
                                      value: e.id,
                                    ))
                                .toList()
                            : [],
                        onChanged: (value) {
                          _serviceId = value;
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context).cost),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context).error_cost;
                        return null;
                      },
                      onSaved: (value) => _cost = double.parse(value.trim()),
                    ),
                    SizedBox(height: 24),
                    DigiButton(
                      onPressed: () =>
                          _submitNewDoucment(context, title, documentType),
                      child: Text(title),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
