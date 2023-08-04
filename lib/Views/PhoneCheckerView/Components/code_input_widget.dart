import 'package:flutter/material.dart';

class CodeInputWidget extends StatefulWidget {
  const CodeInputWidget({super.key, required this.defaultCode});
  final String defaultCode;

  @override
  State<CodeInputWidget> createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Введите код',
            ),
            controller: TextEditingController(text: widget.defaultCode),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Подтвердить')),
        ],
      ),
    );
  }
}
