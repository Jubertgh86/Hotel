import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final Function confirm;
  final String mensaje;

  const ConfirmDialog(
      {super.key,
      required this.confirm,
      this.mensaje = "Desea realizar esta acción?"});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Favor Confirmar"),
      content: Text(mensaje),
      actions: [
        TextButton(
            onPressed: () {
              confirm();
              Navigator.of(context).pop();
            },
            child: const Text("Sí")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"))
      ],
    );
  }
}
