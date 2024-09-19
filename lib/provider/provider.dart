import 'package:flutter/material.dart';
import 'package:hotelreserva/modelos/modelos.dart';

class ReservaProvider extends ChangeNotifier {
  Restaurante? _restaurante;
  final List<Restaurante> _restaurantesConReserva = [];
  final List<Restaurante> _restaurantes = [
    Restaurante(
        nombre: 'Ember',
        tipo: 'Restaurante de carne',
        capacidad: 3,
        img: 'carnes.png',
        reservas: []),
    Restaurante(
        nombre: 'Zao',
        tipo: 'Restaurante japonés',
        capacidad: 4,
        img: 'japones.jpeg',
        reservas: []),
    Restaurante(
        nombre: 'Grappa',
        tipo: 'Restaurante italiano',
        capacidad: 2,
        img: 'italiano.jpeg',
        reservas: []),
    Restaurante(
        nombre: 'Larimar',
        tipo: 'Restaurante de mariscos',
        capacidad: 3,
        img: 'mariscos.png',
        reservas: []),
  ];

  Restaurante? get restaurante => _restaurante;
  List<Restaurante> get restaurantes => _restaurantes;
  List<Restaurante> get restaurantesConReserva => _restaurantesConReserva;
  String res = '';
  seleccionarRestaurante(Restaurante restaurante) {
    _restaurante = restaurante;
    notifyListeners();
  }

  agregarReserva(Reserva reserva) {
    res = '';
    var h6 = _restaurante?.reservas.where((r) => r.horario.id == 1).length ?? 0;
    var h8 = _restaurante?.reservas.where((r) => r.horario.id == 2).length ?? 0;
    if (_restaurantesConReserva
        .where((rr) => rr.nombre == _restaurante!.nombre)
        .isEmpty) {
      if (h6 < _restaurante!.capacidad && reserva.horario.id == 1) {
        _restaurante?.reservas.add(reserva);
        _restaurantesConReserva.add(_restaurante!);
      } else if (h8 < _restaurante!.capacidad && reserva.horario.id == 2) {
        _restaurante?.reservas.add(reserva);
        _restaurantesConReserva.add(_restaurante!);
      } else {
        res =
            'No hay disponibilidad en ${_restaurante!.nombre} para el horario ${reserva.horario.desripcion} ';
      }
    } else {
      if (h6 <
              _restaurantesConReserva
                  .where((rr) => rr.nombre == _restaurante!.nombre)
                  .first
                  .capacidad &&
          reserva.horario.id == 1) {
        _restaurantesConReserva
            .where((rr) => rr.nombre == _restaurante!.nombre)
            .first
            .reservas
            .add(reserva);
        res = '';
      } else if (h8 <
              _restaurantesConReserva
                  .where((rr) => rr.nombre == _restaurante!.nombre)
                  .first
                  .capacidad &&
          reserva.horario.id == 2) {
        _restaurantesConReserva
            .where((rr) => rr.nombre == _restaurante!.nombre)
            .first
            .reservas
            .add(reserva);
        res = '';
      } else {
        res =
            'No hay disponibilidad en ${_restaurantesConReserva.where((rr) => rr.nombre == _restaurante!.nombre).first.nombre} para el horario ${reserva.horario.desripcion} ';
      }
    }

    notifyListeners();
  }
}
