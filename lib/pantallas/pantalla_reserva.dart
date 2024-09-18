import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/modelos.dart';
import '../provider/provider.dart';
import '../widget/agregar_reserva.dart';
import '../widget/imprimir_pdf.dart';
import '../widget/snackbarmensajes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Obtienes el provider con los datos de los restaurantes
    final reservaProvider =
        Provider.of<ReservaProvider>(context, listen: false);

    // Obtienes la lista de restaurantes del provider
    List<Restaurante> restaurante = reservaProvider.restaurantes;
    List<Restaurante> restaurantesConReserva =
        reservaProvider.restaurantesConReserva;

    setState(() {
      restaurante = reservaProvider.restaurantes;
      restaurantesConReserva = reservaProvider.restaurantesConReserva;
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: const Color.fromARGB(255, 30, 119, 85),
        title: Column(
          children: [
            const SizedBox(height: 30),
            Image.asset(
              'assets/logohotel.png',
              height: 100,
              width: 100,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Jubert Hotel',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          // Lista de restaurantes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: restaurante.length,
              itemBuilder: (context, index) {
                final rest = restaurante[index];
                return InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AgregarReserva(
                              restaurante: rest,
                              addItem: () {},
                            ));
                  },
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Información del restaurante
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rest.nombre, // Nombre del restaurante
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text('Tipo: ${rest.tipo}'),
                                const SizedBox(height: 5),
                                const SizedBox(height: 10),
                                Text(
                                    'Disponibilidad de 6 a 8:    ${rest.capacidad - (restaurantesConReserva.where((rr) => rr.nombre == rest.nombre).isNotEmpty ? restaurantesConReserva.where((rr) => rr.nombre == rest.nombre).first.reservas.where((r) => r.horario.id == 1).length : 0)}'),
                                Text(
                                    'Disponibilidad de 8 a 10:  ${rest.capacidad - (restaurantesConReserva.where((rr) => rr.nombre == rest.nombre).isNotEmpty ? restaurantesConReserva.where((rr) => rr.nombre == rest.nombre).first.reservas.where((r) => r.horario.id == 2).length : 0)}'),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          // Imagen del restaurante a la derecha
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8.0), // Borde redondeado para la imagen
                            child: Image.asset(
                              'assets/${rest.img}',
                              height: 80,
                              width: 80,
                              fit: BoxFit
                                  .cover, // Ajuste de la imagen dentro del contenedor
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Botón de imprimir al final
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 30, 119, 85),
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
                  if (restaurantesConReserva.isNotEmpty) {
                    generarReportePdf(context, restaurantesConReserva);
                  } else {
                    mensajes('No hay reservas para mostrar');
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5),
                    Text(
                      'IMPRIMIR',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  mensajes(String mensaje) {
    Utils.showSnackBar(context, mensaje, 3);
  }

  void generarReportePdf(BuildContext context, List<Restaurante> restaurantes) {
    final pdfService = PdfService();
    pdfService.generarPdf(restaurantes);
  }
}
