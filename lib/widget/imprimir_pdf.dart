import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

import '../modelos/modelos.dart';

class PdfService {
  // Función para crear el PDF
  Future<void> generarPdf(List<Restaurante> restaurantes) async {
    final pdf = pw.Document();

    // Cargar logo desde los assets
    final ByteData bytes = await rootBundle.load('assets/logohotel.png');
    final Uint8List logoData = bytes.buffer.asUint8List();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            // Logo y nombre de la empresa
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Image(pw.MemoryImage(logoData), height: 100, width: 100),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Jubert Hotel',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Listado de restaurantes y sus reservas
            ...restaurantes.map((restaurante) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Restaurante: ${restaurante.nombre}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text('Tipo: ${restaurante.tipo}'),
                  pw.Text('Capacidad: ${restaurante.capacidad}'),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Reservas:',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  if (restaurante.reservas.isEmpty)
                    pw.Text('No hay reservas.',
                        style: const pw.TextStyle(fontSize: 12)),
                  if (restaurante.reservas.isNotEmpty)
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: restaurante.reservas.map((reserva) {
                        return pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 10),
                          child: pw.Text(
                            'Horario: ${reserva.horario.desripcion}, Nombre: ${reserva.nombre}, Grupo de ${reserva.cantidad} personas',
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                ],
              );
            }),
          ];
        },
      ),
    );

    // Mostrar PDF en la pantalla para imprimir o compartir
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
