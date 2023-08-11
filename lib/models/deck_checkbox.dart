import 'package:flutter/material.dart';
import 'package:meu_flash/stores/selected_decks.dart';
import 'package:provider/provider.dart';

class DeckCheckbox extends StatefulWidget {
  final String deck;
  final bool initialValue;

  const DeckCheckbox({Key? key, required this.deck, required this.initialValue})
      : super(key: key);

  @override
  _DeckCheckboxState createState() => _DeckCheckboxState();
}

class _DeckCheckboxState extends State<DeckCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    SelectedDecks selectedDecks = Provider.of<SelectedDecks>(context);
    return CheckboxListTile(
      title: Text(widget.deck),
      value: _isChecked,
      onChanged: (value) {
        setState(() {
          _isChecked = value!;
        });
        if (_isChecked) {
          selectedDecks.addDeck(widget.deck);
        } else {
          selectedDecks.removeDeck(widget.deck);
        }
      },
    );
  }
}