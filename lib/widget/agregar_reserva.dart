import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotelreserva/modelos/modelos.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import 'dialogoconfirm.dart';
import 'snackbarmensajes.dart';
import 'values.dart';

class AgregarReserva extends StatefulWidget {
  final Function addItem;
  final Restaurante restaurante;
  @override
  const AgregarReserva(
      {super.key, required this.restaurante, required this.addItem});

  @override
  State<AgregarReserva> createState() => _AgregarReserva();
}

class _AgregarReserva extends State<AgregarReserva> {
  final cantInput = TextEditingController();
  final nomImput = TextEditingController();
  num comLength = 0;

  String tip = '2';

  final _key = GlobalKey<FormState>();
  Horario horario = Horario(id: 0, desripcion: '');

  Reserva reserva =
      Reserva(horario: Horario(id: 0, desripcion: ''), nombre: '', cantidad: 0);
  Restaurante restaurante =
      Restaurante(nombre: '', tipo: '', capacidad: 0, img: '', reservas: []);
  @override
  void initState() {
    restaurante = widget.restaurante;

    super.initState();
  }

  Horario? horarioSeleccionado;
  final List<Horario> horarios = [
    Horario(id: 1, desripcion: '6 a 8 PM'),
    Horario(id: 2, desripcion: '8 a 10 PM')
  ];

  @override
  Widget build(BuildContext context) {
    final reservaProvider =
        Provider.of<ReservaProvider>(context, listen: false);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      backgroundColor: Colors.white, // Light background color
      content: ConstrainedBox(
        constraints: const BoxConstraints(
            minWidth: 400, maxWidth: 400, minHeight: 300, maxHeight: 400),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // Title 'Agregar Reserva' with similar text style
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 0),
                  child: const Text(
                    'Agregar Reserva',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Restaurant name, similar to the list cards
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(
                    restaurante.nombre,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  alignment: Alignment.topLeft,
                  child: Text(
                    restaurante.tipo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Agregar Nombre';
                            }
                            return null;
                          },
                          controller: nomImput,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nombre',
                          ),
                          autofocus: true,
                        ),
                      ),
                    ),
                    //const SizedBox(width: 5),
                    // Quantity input
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty || cantInput.text == '0') {
                              return 'Agregar Cantidad';
                            } else if (int.parse(cantInput.text) > intMax) {
                              return 'La cantidad excede el valor permitido.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          controller: cantInput,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Cant.',
                          ),
                          autofocus: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Center(
                  child: DropdownButton<Horario>(
                    value: horarioSeleccionado,
                    hint: const Text('Seleccione un horario'),
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    underline: Container(
                      height: 2,
                      color: _isDropdownValid
                          ? Colors.blueAccent
                          : Colors.red, // Cambia el color si no es válido
                    ),
                    onChanged: (Horario? newValue) {
                      setState(() {
                        horarioSeleccionado = newValue;
                        _isDropdownValid =
                            true; // Cambia el estado cuando se selecciona un valor
                      });
                    },
                    items: horarios
                        .map<DropdownMenuItem<Horario>>((Horario value) {
                      return DropdownMenuItem<Horario>(
                        value: value,
                        child: Text(value.desripcion),
                      );
                    }).toList(),
                  ),
                ),
                if (!_isDropdownValid)
                  const Text(
                    'Por favor seleccione un horario',
                    style: TextStyle(color: Colors.red), // Mensaje de error
                  ),
                const SizedBox(height: 10),
                // Buttons for 'Agregar' and 'Cancelar'
                Row(
                  children: [
                    // Cancelar button
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(4, 4),
                                blurRadius: 5,
                                spreadRadius: 1),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                mensaje: "Desea cancelar la acción?",
                                confirm: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CANCELAR',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Agregar button
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(4, 4),
                                blurRadius: 5,
                                spreadRadius: 1),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            botonAgregar(reservaProvider);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 5),
                              Text(
                                'AGREGAR',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isDropdownValid = true;
  void _validateDropdown() {
    setState(() {
      if (horarioSeleccionado == null) {
        _isDropdownValid = false;
      } else {
        _isDropdownValid = true;
      }
    });
  }

  Future<void> botonAgregar(ReservaProvider reservaProvider) async {
    _validateDropdown();

    if (_key.currentState!.validate() && _isDropdownValid) {
      setState(() {
        reserva.nombre = nomImput.text;
        reserva.cantidad = int.parse(cantInput.text);
        reserva.horario = horarioSeleccionado!;
      });
      await reservaProvider.seleccionarRestaurante(restaurante);
      reservaProvider.agregarReserva(reserva);
      if (!reservaProvider.res.contains('No hay disponibilidad')) {
        mensajes(
            'Reserva para ${reserva.cantidad} personas en ${restaurante.nombre}');
        salir();
      } else {
        mensajes(reservaProvider.res);
        salir();
      }
    }
  }

  mensajes(String mensaje) {
    Utils.showSnackBar(context, mensaje, 3);
  }

  salir() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home');
  }
}
