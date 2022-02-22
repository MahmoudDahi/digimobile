import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class RangeDate extends StatefulWidget {
  final Function(DateTime start, DateTime end, int doucmentId) rangeConfirm;
  final bool isLoading;
  final bool hasDoucment;

  RangeDate(this.rangeConfirm, this.isLoading, [bool this.hasDoucment = true]);

  @override
  _RangeDateState createState() => _RangeDateState();
}

class _RangeDateState extends State<RangeDate> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int _doucmentId = 1;
  final _doucmentControl = TextEditingController();
  String _errorRange;
  String _errorDocumentType;

  @override
  void dispose() {
    _doucmentControl.dispose();
    super.dispose();
  }

  void _chooseRangeDate() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(
        Duration(days: 30),
      ),
    );
    if (range == null) return;
    setState(() {
      _startDate = range.start;
      _endDate = range.end;
    });
  }

  void _onSubmitSearch() {
    bool valid = true;
    setState(() {
      if (_startDate == null) {
        _errorRange = AppLocalizations.of(context).error_choose_range_date;
        valid = false;
      } else {
        _errorRange = null;
      }
      if (_doucmentId == null) {
        _errorDocumentType = AppLocalizations.of(context).error_choose_document;
        valid = false;
      } else {
        _errorDocumentType = null;
      }
    });

    if (valid) {
      widget.rangeConfirm(_startDate, _endDate, _doucmentId);
    }
  }

  Widget _columnField(String hint, DateTime value) {
    return InkWell(
      onTap: () => _chooseRangeDate(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              hint,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            width: 140,
            height: 40,
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value != null ? DateFormat('dd-MM-yyyy').format(value) : '',
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _columnField(AppLocalizations.of(context).from, _startDate),
              _columnField(AppLocalizations.of(context).to, _endDate),
            ],
          ),
          if (_errorRange != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorRange,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hasDoucment)
                Flexible(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: 1,
                    decoration: InputDecoration(
                      errorText: _errorDocumentType,
                      label: Text(AppLocalizations.of(context).doucment_type),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          AppLocalizations.of(context).invoice,
                        ),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text(AppLocalizations.of(context).credit),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text(AppLocalizations.of(context).debit),
                        value: 3,
                      ),
                    ],
                    onChanged: (value) => _doucmentId = value,
                  ),
                ),
              SizedBox(width: 16),
              ElevatedButton(
                child: widget.isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(AppLocalizations.of(context).search),
                onPressed: _onSubmitSearch,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
