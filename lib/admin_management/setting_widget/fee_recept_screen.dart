import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ──────────────────────0000000000000───────────────────────────────────────────────────────
// MODEL — matches the real API response
// ─────────────────────────────────────────────────────────────────────────────

class PaidInstallmentItem {
  final int installmentId;
  final int installmentNo;
  final String type; // "normal" | "transport"
  final double amount;
  final double fine;
  final String? startDueDate;
  final String? endDueDate;

  const PaidInstallmentItem({
    required this.installmentId,
    required this.installmentNo,
    required this.type,
    required this.amount,
    required this.fine,
    this.startDueDate,
    this.endDueDate,
  });

  bool get isTransport => type == 'transport';
  double get total => amount + fine;
}

class FeeReceiptData {
  final String receiptNo;
  final String studentName;
  final String admissionNo;
  final String classSection;
  final String schoolName;
  final String schoolAddress;
  final String schoolPhone;
  final String schoolEmail;
  final String academicYear;
  final String paymentDate;
  final String paymentTime;
  final String paymentMethod;
  final double amount;
  final double fineAmount;
  final double totalAmount;
  final String remarks;
  final List<PaidInstallmentItem> installmentsPaid;

  const FeeReceiptData({
    required this.receiptNo,
    required this.studentName,
    required this.admissionNo,
    required this.classSection,
    required this.schoolName,
    required this.schoolAddress,
    this.schoolPhone = '',
    this.schoolEmail = '',
    required this.academicYear,
    required this.paymentDate,
    required this.paymentTime,
    required this.paymentMethod,
    required this.amount,
    required this.fineAmount,
    required this.totalAmount,
    this.remarks = '',
    required this.installmentsPaid,
  });

  /// Build from raw API map (the `data` block inside the response)
  factory FeeReceiptData.fromApiResponse(Map<String, dynamic> data) {
    final paidOn = data['paid_on'] as String?;
    DateTime? paidDt;
    try {
      paidDt = paidOn != null ? DateTime.parse(paidOn).toLocal() : null;
    } catch (_) {}

    final items = <PaidInstallmentItem>[];
    final rawList = data['installments_paid'] as List?;
    if (rawList != null) {
      for (final v in rawList) {
        final m = Map<String, dynamic>.from(v as Map);
        items.add(PaidInstallmentItem(
          installmentId: m['installment_id'] ?? 0,
          installmentNo: m['installment_no'] ?? 0,
          type: m['type']?.toString() ?? 'normal',
          amount: double.tryParse(m['amount']?.toString() ?? '0') ?? 0,
          fine: double.tryParse(m['fine']?.toString() ?? '0') ?? 0,
          startDueDate: m['start_due_date']?.toString(),
          endDueDate: m['end_due_date']?.toString(),
        ));
      }
    }

    return FeeReceiptData(
      receiptNo: data['receipt_no']?.toString() ?? 'RCP-XXXX',
      studentName: data['student_name']?.toString() ?? '',
      admissionNo: data['admission_no']?.toString() ?? '',
      classSection:
      '${data['class_name'] ?? ''} – ${data['section_name'] ?? ''}',
      schoolName: data['school_name']?.toString() ?? '',
      schoolAddress: data['school_address']?.toString() ?? '',
      schoolPhone: data['school_phone']?.toString() ?? '',
      schoolEmail: data['school_email']?.toString() ?? '',
      academicYear: data['academic_year']?.toString() ?? '2026-27',
      paymentDate: paidDt != null
          ? DateFormat('d MMMM yyyy').format(paidDt)
          : DateFormat('d MMMM yyyy').format(DateTime.now()),
      paymentTime: paidDt != null
          ? DateFormat('hh:mm a').format(paidDt)
          : DateFormat('hh:mm a').format(DateTime.now()),
      paymentMethod: (data['payment_mode']?.toString() ?? 'cash').toUpperCase(),
      amount: double.tryParse(data['amount']?.toString() ?? '0') ?? 0,
      fineAmount:
      double.tryParse(data['fine_amount']?.toString() ?? '0') ?? 0,
      totalAmount:
      double.tryParse(data['total_amount']?.toString() ?? '0') ?? 0,
      remarks: data['remarks']?.toString() ?? '',
      installmentsPaid: items,
    );
  }

  String get amountInWords => _numberToWords(totalAmount.toInt());

  // Normal-fee subtotal
  double get feeSubtotal => installmentsPaid
      .where((e) => !e.isTransport)
      .fold(0.0, (s, e) => s + e.total);

  // Transport-fee subtotal
  double get transportSubtotal => installmentsPaid
      .where((e) => e.isTransport)
      .fold(0.0, (s, e) => s + e.total);

  int get normalCount => installmentsPaid.where((e) => !e.isTransport).length;
  int get transportCount =>
      installmentsPaid.where((e) => e.isTransport).length;
}

// ─────────────────────────────────────────────────────────────────────────────
// Number → words (simple, handles values up to crores)
// ─────────────────────────────────────────────────────────────────────────────
String _numberToWords(int n) {
  if (n == 0) return 'Zero Rupees Only';
  const ones = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight',
    'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen',
    'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
  ];
  const tens = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty',
    'Sixty', 'Seventy', 'Eighty', 'Ninety'
  ];

  String _conv(int num) {
    if (num == 0) return '';
    if (num < 20) return '${ones[num]} ';
    if (num < 100) {
      return '${tens[num ~/ 10]} ${ones[num % 10]} ';
    }
    return '${ones[num ~/ 100]} Hundred ${_conv(num % 100)}';
  }

  String result = '';
  if (n >= 10000000) {
    result += '${_conv(n ~/ 10000000)}Crore ';
    n %= 10000000;
  }
  if (n >= 100000) {
    result += '${_conv(n ~/ 100000)}Lakh ';
    n %= 100000;
  }
  if (n >= 1000) {
    result += '${_conv(n ~/ 1000)}Thousand ';
    n %= 1000;
  }
  result += _conv(n);
  return '${result.trim()} Rupees Only';
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

  Future<Uint8List> _captureReceipt() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final boundary = _receiptKey.currentContext!.findRenderObject()
    as RenderRepaintBoundary;
    final img = await boundary.toImage(pixelRatio: 3.0);
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  }

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

  Future<void> _downloadPdf() async {
    setState(() => _downloading = true);
    try {
      final pdfBytes = await _buildPdf();
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) dir = await getExternalStorageDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }
      final fileName =
          'Fee_Receipt_${widget.receipt.receiptNo.replaceAll('/', '_').replaceAll('-', '_')}.pdf';
      final file = File('${dir!.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Downloaded: $fileName',
                  style: const TextStyle(fontSize: 13)),
            ),
          ]),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OPEN',
            textColor: Colors.white,
            onPressed: () async => OpenFile.open(file.path),
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

  @override
  Widget build(BuildContext context) {
    final r = widget.receipt;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        body: Column(children: [
          // ── Header ──────────────────────────────────────────────────────
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
                      Text('Payment Successful!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text('Fee receipt generated',
                          style:
                          TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.green.shade400, shape: BoxShape.circle),
                child:
                const Icon(Icons.check_rounded, color: Colors.white, size: 22),
              ),
            ]),
          ),

          // ── Body ────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(children: [
                    RepaintBoundary(
                      key: _receiptKey,
                      child: _ReceiptCard(receipt: r),
                    ),
                    const SizedBox(height: 20),
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
                    _ActionButton(
                      label: 'Download PDF',
                      icon: Icons.download_rounded,
                      color: const Color(0xFFE53935),
                      textColor: Colors.white,
                      loading: _downloading,
                      onTap: _downloadPdf,
                    ),
                    const SizedBox(height: 12),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RECEIPT CARD — shows real itemised data
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
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // ── School header ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
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
                    Text('FEE RECEIPT',
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
                // ── Title block ───────────────────────────────────────
                Center(
                  child: Column(children: [
                    const Text('OFFICIAL FEE RECEIPT',
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
                    if (r.schoolEmail.isNotEmpty)
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.email_outlined,
                            size: 11, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(r.schoolEmail,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade500)),
                      ]),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'ACADEMIC YEAR ${r.academicYear}',
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

                // ── Student + Receipt details ─────────────────────────
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _InfoBlock(title: 'STUDENT DETAILS', rows: [
                          _InfoRow('Student Name', r.studentName),
                          _InfoRow('Admission No.', r.admissionNo),
                          _InfoRow('Class & Section', r.classSection),
                        ]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _InfoBlock(title: 'RECEIPT DETAILS', rows: [
                          _InfoRow('Receipt No.', r.receiptNo,
                              valueColor: const Color(0xFFE53935)),
                          _InfoRow('Payment Date', r.paymentDate),
                          _InfoRow('Payment Time', r.paymentTime),
                          _InfoRow('Payment Method', r.paymentMethod),
                        ]),
                      ),
                    ]),

                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 12),

                // ── Table header ──────────────────────────────────────
                Row(children: [
                  Expanded(
                    flex: 5,
                    child: Text('DESCRIPTION',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.8)),
                  ),
                  Text('TYPE',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.8)),
                  const SizedBox(width: 12),
                  Text('INST. #',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.8)),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 72,
                    child: Text('AMOUNT (₹)',
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

                // ── Line items ────────────────────────────────────────
                ...r.installmentsPaid.map((item) => _InstallmentRow(item: item)),

                // ── Fine row (if any) ─────────────────────────────────
                if (r.fineAmount > 0) ...[
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Late Payment Penalty',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFE53935),
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Text('Fine',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.red.shade400,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      const SizedBox(width: 24, child: Text('—')),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 72,
                        child: Text('₹${r.fineAmount.toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade500)),
                      ),
                    ]),
                  ),
                ],

                // ── Subtotal rows by category ─────────────────────────
                if (r.normalCount > 0 && r.transportCount > 0) ...[
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              'Fee Subtotal (${r.normalCount} Installment${r.normalCount > 1 ? 's' : ''})',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 16),
                          Text('₹${r.feeSubtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700)),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              'Transport Subtotal (${r.transportCount} Installment${r.transportCount > 1 ? 's' : ''})',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.teal.shade700,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 16),
                          Text('₹${r.transportSubtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade700)),
                        ]),
                  ),
                ],

                const Divider(height: 1, color: Color(0xFFEEEEEE)),

                // ── Subtotal / Total ──────────────────────────────────
                _TotalRow(
                    label: 'SUBTOTAL',
                    amount: '₹${r.totalAmount.toStringAsFixed(2)}'),
                Container(
                  color: const Color(0xFFF5F7FF),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 10),
                  child: _TotalRow(
                    label: 'TOTAL PAID',
                    amount: '₹${r.totalAmount.toStringAsFixed(2)}',
                    bold: true,
                    amountColor: const Color(0xFFE53935),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Amount in words ───────────────────────────────────
                Text('Amount in words: ${r.amountInWords}',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic)),

                // ── Remarks ───────────────────────────────────────────
                if (r.remarks.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Remarks: ${r.remarks}',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600)),
                ],

                const SizedBox(height: 24),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),

                // ── Seal / Signature ──────────────────────────────────
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
                        Text('SCHOOL SEAL',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600)),
                      ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 100,
                                height: 1,
                                color: Colors.black54),
                            const SizedBox(height: 4),
                            const Text('AUTHORISED SIGNATORY',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600)),
                            Text('Accounts Department',
                                style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade500)),
                          ]),
                    ]),

                const SizedBox(height: 20),
              ]),
        ),

        // ── Footer ────────────────────────────────────────────────────────
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
                style:
                TextStyle(fontSize: 10, color: Colors.grey.shade500)),
            if (r.schoolEmail.isNotEmpty || r.schoolPhone.isNotEmpty)
              Text(
                  [
                    if (r.schoolPhone.isNotEmpty) r.schoolPhone,
                    if (r.schoolEmail.isNotEmpty) r.schoolEmail,
                  ].join('  |  '),
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey.shade500)),
            const SizedBox(height: 6),
            Text(
              'This is a computer-generated receipt and does not require a physical signature.\n'
                  'Please keep this copy for your records. Refund policy applies as per school guidelines.',
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
// Installment line-item row
// ─────────────────────────────────────────────────────────────────────────────
class _InstallmentRow extends StatelessWidget {
  final PaidInstallmentItem item;
  const _InstallmentRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Description
        Expanded(
          flex: 5,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.isTransport ? 'Transport Fee' : 'Fee head web test date',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(
                '${item.isTransport ? 'Transport' : 'Fee'} Installment #${item.installmentNo}',
                style:
                TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ]),
        ),
        // Type badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: item.isTransport
                ? Colors.teal.shade50
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(
                item.isTransport
                    ? Icons.directions_bus_rounded
                    : Icons.menu_book_rounded,
                size: 10,
                color: item.isTransport
                    ? Colors.teal.shade600
                    : Colors.blue.shade600),
            const SizedBox(width: 3),
            Text(item.isTransport ? 'Transport' : 'Fee',
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: item.isTransport
                        ? Colors.teal.shade600
                        : Colors.blue.shade600)),
          ]),
        ),
        const SizedBox(width: 12),
        // Installment number
        SizedBox(
          width: 24,
          child: Text('#${item.installmentNo}',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
        // Amount
        SizedBox(
          width: 72,
          child: Text('₹${item.amount.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold)),
        ),
      ]),
      // Fine sub-line
      if (item.fine > 0) ...[
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('+₹${item.fine.toStringAsFixed(0)} fine',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.red.shade500,
                  fontWeight: FontWeight.w500)),
        ]),
      ],
      const SizedBox(height: 8),
      Divider(height: 1, color: Colors.grey.shade100),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
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
        padding: const EdgeInsets.only(bottom: 6),
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
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                    bold ? FontWeight.bold : FontWeight.w500,
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
              : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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