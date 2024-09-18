class Restaurante {
  String nombre;
  String tipo;
  int capacidad;
  String img;
  List<Reserva> reservas;
  Restaurante(
      {required this.nombre,
      required this.tipo,
      required this.capacidad,
      required this.img,
      required this.reservas});
}

class Horario {
  int id;
  String desripcion;
  Horario({required this.id, required this.desripcion});
}

class Reserva {
  Horario horario;
  String nombre;
  int cantidad;
  Reserva({
    required this.horario,
    required this.nombre,
    required this.cantidad,
  });
}
