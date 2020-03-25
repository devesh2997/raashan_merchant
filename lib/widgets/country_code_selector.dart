library country_code_picker;

import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_codes.dart';
import './country_selection_dialog.dart';
import 'package:flutter/material.dart';


class CountryCodeSelector extends StatefulWidget {
  final ValueChanged<CountryCode> onChanged;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;

  CountryCodeSelector({
    this.onChanged,
    this.initialSelection,
    this.favorite = const [],
    this.textStyle,
    this.padding = const EdgeInsets.all(0.0),
  });

  @override
  State<StatefulWidget> createState() {
    List<Map> jsonList = codes;

    List<CountryCode> elements = jsonList
        .map((s) => new CountryCode(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: 'flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();

    return new _CountryCodeSelectorState(elements);
  }
}

class _CountryCodeSelectorState extends State<CountryCodeSelector> {
  CountryCode selectedItem;
  List<CountryCode> elements = [];
  List<CountryCode> favoriteElements = [];

  _CountryCodeSelectorState(this.elements);

  @override
  Widget build(BuildContext context) => new FlatButton(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Flexible(
            //   child: Padding(
            //     padding: const EdgeInsets.only(right: 8.0),
            //     child: Image.asset(
            //       selectedItem.flagUri,
            //       package: 'country_code_picker',
            //       width: 25.0,
            //     ),
            //   ),
            // ),
            Flexible(
              child: Text(
                selectedItem.toString(),
                style: widget.textStyle ?? Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(0),
        onPressed: _showSelectionDialog,
      );

  @override
  initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    favoriteElements = elements
        .where((e) =>
            widget.favorite.firstWhere(
                (f) => e.code == f.toUpperCase() || e.dialCode == f.toString(),
                orElse: () => null) !=
            null)
        .toList();
    super.initState();

    if (mounted) {
      _publishSelection(selectedItem);
    }
  }

  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (_) => new SelectionDialog(elements, favoriteElements),
    ).then((e) {
      if (e != null) {
        setState(() {
          selectedItem = e;
        });

        _publishSelection(e);
      }
    });
  }

  void _publishSelection(CountryCode e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }
}
