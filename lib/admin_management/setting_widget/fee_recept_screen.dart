import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL  (apne collect-fee API response ke hisaab se fields bharo)
// ─────────────────────────────────────────────────────────────────────────────
class FeeReceiptData {
  final String receiptNo;
  final String studentName;
  final String admissionNo;
  final String classSection;
  final String schoolName;
  final String schoolAddress;
  final String academicYear;
  final String paymentDate;
  final String paymentTime;
  final String paymentMethod;
  final String feeDescription;
  final int installmentNo;
  final double amount;
  final String amountInWords;

  const FeeReceiptData({
    required this.receiptNo,
    required this.studentName,
    required this.admissionNo,
    required this.classSection,
    required this.schoolName,
    required this.schoolAddress,
    required this.academicYear,
    required this.paymentDate,
    required this.paymentTime,
    required this.paymentMethod,
    required this.feeDescription,
    required this.installmentNo,
    required this.amount,
    required this.amountInWords,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class FeeReceiptScreen extends StatefulWidget {
  final FeeReceiptData receipt;

  const FeeReceiptScreen({super.key, required this.receipt});

  @override
  State<FeeReceiptScreen> createState() => _FeeReceiptScreenState();
}

class _FeeReceiptScreenState extends State<FeeReceiptScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _receiptKey = GlobalKey();
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _printing = false;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Capture receipt widget as image bytes ──────────────────────
  Future<Uint8List> _captureReceipt() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final RenderRepaintBoundary boundary =
    _receiptKey.currentContext!.findRenderObject()
    as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // ── Build PDF ──────────────────────────────────────────────────
  Future<Uint8List> _buildPdf() async {
    final imgBytes = await _captureReceipt();
    final pdf = pw.Document();
    final image = pw.MemoryImage(imgBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (ctx) => pw.Center(child: pw.Image(image)),
      ),
    );
    return pdf.save();
  }

  // ── Print ──────────────────────────────────────────────────────
  Future<void> _printReceipt() async {
    setState(() => _printing = true);
    try {
      final pdfBytes = await _buildPdf();
      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
    } catch (e) {
      _showError('Print failed: $e');
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  // ── Download / Share PDF ───────────────────────────────────────
  // Future<void> _downloadPdf() async {
  //   setState(() => _downloading = true);
  //   try {
  //     final pdfBytes = await _buildPdf();
  //     final dir = await getApplicationDocumentsDirectory();
  //     final file = File(
  //         '${dir.path}/receipt_${widget.receipt.receiptNo.replaceAll('-', '_')}.pdf');
  //     await file.writeAsBytes(pdfBytes);
  //
  //     await Share.shareXFiles(
  //       [XFile(file.path, mimeType: 'application/pdf')],
  //       subject: 'Fee Receipt - ${widget.receipt.receiptNo}',
  //     );
  //   } catch (e) {
  //     _showError('Download failed: $e');
  //   } finally {
  //     if (mounted) setState(() => _downloading = false);
  //   }
  // }
  Future<void> _downloadPdf() async {
    setState(() => _downloading = true);
    try {
      final pdfBytes = await _buildPdf();

      // ✅ Android/iOS dono ke liye Downloads folder mein save karo
      Directory? dir;

      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      }

      final fileName =
          'Fee_Receipt_${widget.receipt.receiptNo.replaceAll('-', '_')}.pdf';
      final file = File('${dir!.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Downloaded: $fileName',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ]),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'OPEN',
            textColor: Colors.white,
            onPressed: () async {
              // ✅ file open karo
              await OpenFile.open(file.path);
            },
          ),
        ));
      }
    } catch (e) {
      _showError('Download failed: $e');
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
  }

  // ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final r = widget.receipt;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(children: [
        // ── Header ────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          child: Row(children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment Successful!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text("Fee receipt generated",
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ]),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade400,
                shape: BoxShape.circle,
              ),
              child:
              const Icon(Icons.check_rounded, color: Colors.white, size: 22),
            ),
          ]),
        ),

        // ── Body ──────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(children: [
                  // ── Receipt Card ─────────────────────────────
                  RepaintBoundary(
                    key: _receiptKey,
                    child: _ReceiptCard(receipt: r),
                  ),

                  const SizedBox(height: 20),

                  // ── Print Button ─────────────────────────────
                  _ActionButton(
                    label: 'Print Receipt',
                    icon: Icons.print_rounded,
                    color: Colors.white,
                    textColor: const Color(0xFF1565C0),
                    borderColor: const Color(0xFF1565C0),
                    loading: _printing,
                    onTap: _printReceipt,
                  ),

                  const SizedBox(height: 12),

                  // ── Download PDF Button ──────────────────────
                  _ActionButton(
                    label: 'Download PDF',
                    icon: Icons.download_rounded,
                    color: const Color(0xFFE53935),
                    textColor: Colors.white,
                    loading: _downloading,
                    onTap: _downloadPdf,
                  ),

                  const SizedBox(height: 12),

                  // ── Back to Fee List ─────────────────────────
                  _ActionButton(
                    label: 'Back to Fee List',
                    icon: Icons.list_alt_rounded,
                    color: const Color(0xFF1565C0),
                    textColor: Colors.white,
                    onTap: () => Navigator.pop(context),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RECEIPT CARD WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _ReceiptCard extends StatelessWidget {
  final FeeReceiptData receipt;
  const _ReceiptCard({required this.receipt});

  @override
  Widget build(BuildContext context) {
    final r = receipt;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // ── School Header ──────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school_rounded,
                  color: Color(0xFF1565C0), size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.schoolName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1565C0))),
                    Text("FEE RECEIPT",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600)),
                  ]),
            ),
          ]),
        ),

        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── OFFICIAL FEE RECEIPT title ───────────────
                Center(
                  child: Column(children: [
                    const Text("OFFICIAL FEE RECEIPT",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE53935),
                            letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(r.schoolName,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(r.schoolAddress,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "ACADEMIC YEAR ${r.academicYear}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ]),
                ),

                const SizedBox(height: 20),

                // ── Student & Receipt details ─────────────────
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _InfoBlock(title: "STUDENT DETAILS", rows: [
                          _InfoRow("Student Name", r.studentName),
                          _InfoRow("Admission No.", r.admissionNo),
                          _InfoRow("Class & Section", r.classSection),
                        ]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _InfoBlock(title: "RECEIPT DETAILS", rows: [
                          _InfoRow("Receipt No.", r.receiptNo,
                              valueColor: const Color(0xFFE53935)),
                          _InfoRow("Payment Date", r.paymentDate),
                          _InfoRow("Payment Time", r.paymentTime),
                          _InfoRow("Payment Method", r.paymentMethod),
                        ]),
                      ),
                    ]),

                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 12),

                // ── Fee Table header ──────────────────────────
                Row(children: [
                  Expanded(
                    flex: 5,
                    child: Text("FEE DESCRIPTION",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.8)),
                  ),
                  Text("INST. NO",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.8)),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 70,
                    child: Text("AMOUNT (₹)",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.8)),
                  ),
                ]),
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 10),

                // ── Fee Row ───────────────────────────────────
                Row(children: [
                  Expanded(
                    flex: 5,
                    child: Text(r.feeDescription,
                        style: const TextStyle(fontSize: 13)),
                  ),
                  Text('#${r.installmentNo}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 70,
                    child: Text('₹${r.amount.toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ]),

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),

                // ── Subtotal / Total ──────────────────────────
                _TotalRow(label: 'SUBTOTAL',
                    amount: '₹${r.amount.toStringAsFixed(2)}'),
                Container(
                  color: const Color(0xFFF5F7FF),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  child: _TotalRow(
                    label: 'TOTAL PAID',
                    amount: '₹${r.amount.toStringAsFixed(2)}',
                    bold: true,
                    amountColor: const Color(0xFFE53935),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Amount in words ───────────────────────────
                Text("Amount in words: ${r.amountInWords}",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic)),

                const SizedBox(height: 24),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),

                // ── Seal / Signature ──────────────────────────
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.verified_rounded,
                              size: 30, color: Colors.grey.shade400),
                        ),
                        const SizedBox(height: 4),
                        Text("SCHOOL SEAL",
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600)),
                      ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(width: 100, height: 1, color: Colors.black54),
                            const SizedBox(height: 4),
                            const Text("AUTHORISED SIGNATORY",
                                style: TextStyle(
                                    fontSize: 9, fontWeight: FontWeight.w600)),
                            Text("Accounts Department",
                                style: TextStyle(
                                    fontSize: 9, color: Colors.grey.shade500)),
                          ]),
                    ]),

                const SizedBox(height: 20),
              ]),
        ),

        // ── Footer ────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Column(children: [
            Text(r.schoolName,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold)),
            Text(r.schoolAddress,
                style: TextStyle(
                    fontSize: 10, color: Colors.grey.shade500)),
            const SizedBox(height: 6),
            Text(
              "This is a computer-generated receipt and does not require a physical signature.\n"
                  "Please retain this receipt for future reference as per school policy.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _InfoRow {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow(this.label, this.value, {this.valueColor});
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;
  const _InfoBlock({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 0.8)),
      const SizedBox(height: 6),
      ...rows.map((r) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.label,
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey.shade500)),
              Text(r.value,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: r.valueColor ?? Colors.black87)),
            ]),
      )),
    ]);
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool bold;
  final Color? amountColor;
  const _TotalRow(
      {required this.label,
        required this.amount,
        this.bold = false,
        this.amountColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                color: Colors.grey.shade600)),
        Text(amount,
            style: TextStyle(
                fontSize: bold ? 16 : 13,
                fontWeight: FontWeight.bold,
                color: amountColor ?? Colors.black87)),
      ]),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final bool loading;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    this.borderColor,
    this.loading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.5)
              : null,
          boxShadow: borderColor == null
              ? [
            BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]
              : [],
        ),
        child: Center(
          child: loading
              ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                  color: textColor, strokeWidth: 2.5))
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXAMPLE: _submit() mein yeh navigate karo
// ─────────────────────────────────────────────────────────────────────────────
//
// if (success && mounted) {
//   Navigator.pop(context);                     // bottom sheet band karo
//
//   // API response se FeeReceiptData banao
//   final receiptData = FeeReceiptData(
//     receiptNo:      apiResponse['receipt_no']    ?? 'RCP-XXXX',
//     studentName:    widget.studentName,
//     admissionNo:    apiResponse['admission_no']  ?? '',
//     classSection:   apiResponse['class_section'] ?? '',
//     schoolName:     'Anshuma School of Artificial Intelligence',
//     schoolAddress:  'School Address',
//     academicYear:   '2026–27',
//     paymentDate:    apiResponse['payment_date']  ?? DateFormat('d MMMM yyyy').format(DateTime.now()),
//     paymentTime:    apiResponse['payment_time']  ?? DateFormat('hh:mm a').format(DateTime.now()),
//     paymentMethod:  _paymentMode,
//     feeDescription: widget.fee.feeHeadName ?? '',
//     installmentNo:  selectedInstallmentNo,      // pehle selected installment ka no.
//     amount:         _selectedTotal,
//     amountInWords:  'Twenty Rupees Only',       // converter use karo
//   );
//
//   Navigator.push(context, MaterialPageRoute(
//     builder: (_) => FeeReceiptScreen(receipt: receiptData),
//   ));
// }