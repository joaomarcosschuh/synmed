import 'package:flutter/material.dart';
import 'package:meu_flash/stores/selected_decks.dart';
import 'package:provider/provider.dart';

class DeckCheckbox extends StatefulWidget {
  final String deck;
  final bool initialValue;
  final ValueChanged<bool> onChanged; // Adicione esta linha

  const DeckCheckbox({
    Key? key,
    required this.deck,
    required this.initialValue,
    required this.onChanged, // Adicione esta linha
  }) : super(key: key);

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
    return CheckboxListTile(
      title: Text(widget.deck),
      value: _isChecked,
      onChanged: (value) {
        setState(() {
          _isChecked = value!;
        });
        widget.onChanged(_isChecked); // Atualize para usar o onChanged fornecido
      },
    );
  }
}
