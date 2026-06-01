import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/order_management_model.dart';

class PdfExportService {
  Future<void> exportOrdersToPdf(List<OrderManagementModel> orders) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.poppinsRegular();
    final fontBold = await PdfGoogleFonts.poppinsBold();

    final dateFormatted = DateFormat(
      'dd MMMM yyyy, HH:mm',
    ).format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),

        theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),

        build: (pw.Context context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Leaf & Loaf',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Laporan Manajemen Pesanan',
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                pw.Text(
                  'Dicetak pada: $dateFormatted',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
            pw.Divider(thickness: 2, color: PdfColors.black),
            pw.SizedBox(height: 20),

            _buildOrderTable(orders, fontRegular, fontBold),

            pw.SizedBox(height: 20),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Total Pesanan: ${orders.length}',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Leaf_And_Loaf_Orders_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  pw.Widget _buildOrderTable(
    List<OrderManagementModel> orders,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    final headers = ['Order ID', 'Tanggal', 'Produk', 'Qty', 'Total', 'Status'];

    final data = orders.map((order) {
      final orderId = order.id.length >= 8
          ? order.id.substring(0, 8).toUpperCase()
          : order.id.toUpperCase();
      final date = DateFormat(
        'dd/MM/yyyy HH:mm',
      ).format(order.createdAt.toLocal());

      final priceFormatted = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(order.totalPrice);

      return [
        orderId,
        date,
        order.productDesc,
        order.totalQty.toString(),
        priceFormatted,
        order.status,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),

      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 10,
        font: fontBold,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF3D5A4A),
      ),
      cellStyle: pw.TextStyle(fontSize: 9, font: fontRegular),

      cellPadding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.center,
      },
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
    );
  }
}
