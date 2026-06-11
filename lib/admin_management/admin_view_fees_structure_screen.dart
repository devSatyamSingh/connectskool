// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/main.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
// import 'package:school_pro/utils/utils.dart';
// import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/create_fees_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/fees_head_management_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/fees_management_view_model.dart';
//
// import '../model/school_model/academic_model.dart';
// import '../view_model/school_view_model/academic_view_model.dart';
// class _Installment {
//   final int index;
//   final String label;
//   final String monthYear;
//   double amount; // mutable now
//   DateTime dueDate;      // start due date
//   DateTime endDueDate;   // end due date
//   String status;
//
//   _Installment({
//     required this.index,
//     required this.label,
//     required this.monthYear,
//     required this.amount,
//     required this.dueDate,
//     required this.endDueDate,
//     this.status = 'Draft',
//   });
// }
// // ────────────────────────────────────────────────────────────────────────────
// class AdminViewFeesStructureScreen extends StatefulWidget {
//   const AdminViewFeesStructureScreen({super.key});
//
//   @override
//   State<AdminViewFeesStructureScreen> createState() =>
//       _AdminViewFeesStructureScreenState();
// }
//
// class _AdminViewFeesStructureScreenState
//     extends State<AdminViewFeesStructureScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   // ── Form state ────────────────────────────────
//   final _baseAmountCtrl = TextEditingController();
//   final _startDateCtrl  = TextEditingController();
//   final _endDateCtrl    = TextEditingController();
//   AcademicData? selectedYear;
//   int?    _selectedClassId;
//   int?    _selectedFeeHeadId;
//   String? _selectedFeeHeadName;
//   // String? _selectedAcademicYear;
//   String  _selectedFrequency = 'monthly';
//
//   final _academicYears = ['2024-25', '2025-26', '2026-27'];
//   final _frequencies   = ['monthly', 'Quarterly', 'one_time', 'half_yearly'];
//
//   // ── Installment preview state ─────────────────
//   List<_Installment> _installments = [];
//   bool _showPreview = false;
//
//   // ── View filter ───────────────────────────────
//   String _viewFilter = 'all';
//   bool _previewVisible = false;
//   @override
//   // void initState() {
//   //   super.initState();
//   //   _tabController = TabController(length: 2, vsync: this);
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     Provider.of<AllClassesViewModel>(context, listen: false).allClassesApi(context);
//   //     Provider.of<FeesHeadManagementViewModel>(context, listen: false).feesHeadManagementApi(context);
//   //     Provider.of<FeesManagementViewModel>(context, listen: false).feesManagementApi(context);
//   //   });
//   //
//   //   // Re-generate preview when amount or dates change
//   //   _baseAmountCtrl.addListener(_tryGeneratePreview);
//   //   _startDateCtrl.addListener(_tryGeneratePreview);
//   //   _endDateCtrl.addListener(_tryGeneratePreview);
//   // }
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//
//     // ✅ Argument check karo aur tab set karo
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = ModalRoute.of(context)?.settings.arguments;
//       if (args is Map && args['initialTab'] != null) {
//         _tabController.animateTo(args['initialTab'] as int);
//       }
//       Provider.of<AcademicViewModel>(context, listen: false)
//           .academicApi(context);
//       Provider.of<AllClassesViewModel>(context, listen: false).allClassesApi(context);
//       Provider.of<FeesHeadManagementViewModel>(context, listen: false).feesHeadManagementApi(context);
//       Provider.of<FeesManagementViewModel>(context, listen: false).feesManagementApi(context);
//     });
//
//     _baseAmountCtrl.addListener(_tryGeneratePreview);
//     _startDateCtrl.addListener(_tryGeneratePreview);
//     _endDateCtrl.addListener(_tryGeneratePreview);
//   }
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _baseAmountCtrl.dispose();
//     _startDateCtrl.dispose();
//     _endDateCtrl.dispose();
//     super.dispose();
//   }
//
//   // ── Date picker ───────────────────────────────
//   Future<void> _pickDate(TextEditingController ctrl) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate:  DateTime(2030),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       ctrl.text = DateFormat('yyyy-MM-dd').format(picked);
//     }
//   }
//
//   // ── Generate installments ─────────────────────
//   // void _tryGeneratePreview() {
//   //   final amt   = double.tryParse(_baseAmountCtrl.text.trim());
//   //   final start = DateTime.tryParse(_startDateCtrl.text.trim());
//   //   final end   = DateTime.tryParse(_endDateCtrl.text.trim());
//   //
//   //   if (amt == null || amt <= 0 || start == null || end == null || end.isBefore(start)) {
//   //     if (_showPreview) setState(() { _showPreview = false; _installments = []; });
//   //     return;
//   //   }
//   //
//   //   final list = <_Installment>[];
//   //
//   //   // ── step size in months per frequency ──────
//   //   final int stepMonths;
//   //   final String labelPrefix;
//   //   switch (_selectedFrequency) {
//   //     case 'one_time':
//   //       list.add(_Installment(
//   //         index: 1, label: 'One Time Payment',
//   //         monthYear: DateFormat('MMM yyyy').format(start),
//   //         amount: amt, dueDate: start,
//   //       ));
//   //       setState(() { _installments = list; _showPreview = true; });
//   //       return;
//   //     case 'Quarterly':
//   //       stepMonths  = 12;
//   //       labelPrefix = 'Quarterly Installment';
//   //       break;
//   //     case 'half_yearly':
//   //       stepMonths  = 6;
//   //       labelPrefix = 'Half Yearly Installment';
//   //       break;
//   //     default: // monthly
//   //       stepMonths  = 1;
//   //       labelPrefix = 'Monthly Installment';
//   //   }
//   //
//   //   DateTime cur = DateTime(start.year, start.month, start.day);
//   //   int idx = 1;
//   //   while (!cur.isAfter(end)) {
//   //     list.add(_Installment(
//   //       index: idx,
//   //       label: '$labelPrefix $idx',
//   //       monthYear: DateFormat('MMM yyyy').format(cur),
//   //       amount: amt,
//   //       dueDate: cur,
//   //     ));
//   //     cur = DateTime(cur.year, cur.month + stepMonths, cur.day);
//   //     idx++;
//   //   }
//   //
//   //   setState(() {
//   //     _installments = list;
//   //     _showPreview  = list.isNotEmpty;
//   //   });
//   // }
//   void _tryGeneratePreview() {
//     final amt   = double.tryParse(_baseAmountCtrl.text.trim());
//     final start = DateTime.tryParse(_startDateCtrl.text.trim());
//     final end   = DateTime.tryParse(_endDateCtrl.text.trim());
//
//     if (amt == null || amt <= 0 || start == null || end == null || end.isBefore(start)) {
//       if (_showPreview) setState(() { _showPreview = false; _installments = []; });
//       return;
//     }
//
//     final list = <_Installment>[];
//
//     if (_selectedFrequency == 'one_time') {
//       list.add(_Installment(
//         index: 1, label: 'One Time Payment',
//         monthYear: DateFormat('MMM yyyy').format(start),
//         amount: amt, dueDate: start,
//         endDueDate: end,
//       ));
//       setState(() { _installments = list; _showPreview = false; }); // hide preview for one_time
//       return;
//     }
//
//     final int stepMonths;
//     final String labelPrefix;
//     switch (_selectedFrequency) {
//       case 'Quarterly':   stepMonths = 3;  labelPrefix = 'Quarterly Installment'; break;
//       case 'half_yearly': stepMonths = 6;  labelPrefix = 'Half Yearly Installment'; break;
//       default:            stepMonths = 1;  labelPrefix = 'Monthly Installment';
//     }
//
//     DateTime cur = DateTime(start.year, start.month, start.day);
//     int idx = 1;
//     while (!cur.isAfter(end)) {
//       final installmentEnd = DateTime(cur.year, cur.month + stepMonths - 1,
//           cur.day).isAfter(end) ? end : DateTime(cur.year, cur.month, cur.day + 16);
//       list.add(_Installment(
//         index: idx,
//         label: '$labelPrefix $idx',
//         monthYear: DateFormat('MMM yyyy').format(cur),
//         amount: amt,
//         dueDate: cur,
//         endDueDate: DateTime(cur.year, cur.month, cur.day + 16),
//       ));
//       cur = DateTime(cur.year, cur.month + stepMonths, cur.day);
//       idx++;
//     }
// // _tryGeneratePreview() ke end mein:
//     setState(() {
//       _installments = list;
//       _showPreview = false;
//       _previewVisible = false; // ✅ reset karo taaki button dobara press ho
//     });
//     // setState(() {
//     //   _installments = list;
//     //   _showPreview = false; // preview hidden until button tapped
//     // });
//   }
//   double get _totalAmount => _installments.fold(0, (s, e) => s + e.amount);
//
//   // ── Submit ────────────────────────────────────
//   // Future<void> _submit() async {
//   //   if (_selectedClassId == null)          { Utils.show('Please select class', context); return; }
//   //   if (_selectedFeeHeadId == null)        { Utils.show('Please select fee head', context); return; }
//   //   if (_baseAmountCtrl.text.trim().isEmpty) { Utils.show('Base amount cannot be empty', context); return; }
//   //   if (_selectedAcademicYear?.academicYearId == null) {
//   //     Utils.show('Please select academic year', context);
//   //     return;
//   //   }    if (_startDateCtrl.text.trim().isEmpty)  { Utils.show('Please select start date', context); return; }
//   //   if (_endDateCtrl.text.trim().isEmpty)    { Utils.show('Please select end date', context); return; }
//   //   final baseAmount = double.tryParse(_baseAmountCtrl.text.trim());
//   //   if (baseAmount == null || baseAmount <= 0) { Utils.show('Enter valid amount', context); return; }
//   //
//   //   final feesVm   = Provider.of<FeesManagementViewModel>(context, listen: false);
//   //   final outerCtx = context;
//   //
//   //   final success = await Provider.of<CreateFeesViewModel>(context, listen: false)
//   //       .createFeesApi(
//   //     _selectedClassId!,   _selectedFeeHeadId!,
//   //     baseAmount,          _selectedFrequency,
//   //     _selectedAcademicYear!,
//   //     _startDateCtrl.text.trim(),
//   //     _endDateCtrl.text.trim(),
//   //     outerCtx,
//   //   );
//   //
//   //   if (success == true) {
//   //     setState(() {
//   //       _baseAmountCtrl.clear(); _startDateCtrl.clear(); _endDateCtrl.clear();
//   //       _selectedClassId = null; _selectedFeeHeadId = null;
//   //       _selectedFeeHeadName = null; _selectedAcademicYear = null;
//   //       _selectedFrequency = 'monthly';
//   //       _installments = []; _showPreview = false;
//   //     });
//   //     feesVm.feesManagementApi(outerCtx);
//   //     _tabController.animateTo(1);
//   //   }
//   // }
//   Future<void> _submit() async {
//
//     if (selectedYear == null || selectedYear!.yearName == null) {
//       Utils.show('Please select academic year', context);
//       return;
//     }
//
//     final success =
//     await Provider.of<CreateFeesViewModel>(context, listen: false)
//         .createFeesApi(
//       _selectedClassId!,
//       _selectedFeeHeadId!,
//       double.parse(_baseAmountCtrl.text.trim()),
//       _selectedFrequency,
//       selectedYear!.yearName!, // ✅ STRING PASS
//       _startDateCtrl.text.trim(),
//       _endDateCtrl.text.trim(),
//       context,
//     );
//
//   }  // ────────────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//       child: Scaffold(
//         backgroundColor: AppColor.pageBgColor,
//         body: Column(
//           children: [
//             _buildHeader(),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [_buildCreateTab(), _buildViewTab()],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Header ────────────────────────────────────
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
//       decoration: BoxDecoration(
//         gradient: AppColor.primaryGradient,
//         boxShadow: [BoxShadow(color: AppColor.blueShadow, blurRadius: 18, offset: const Offset(0, 10))],
//       ),
//       child: Column(
//         children: [
//           SizedBox(height: screenHeight * 0.02),
//           Row(
//             children: [
//               InkWell(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(color: AppColor.glassWhite, shape: BoxShape.circle),
//                   child: const Icon(Icons.close, color: Colors.white, size: 18),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   AppText.customText('Fee Structure', size: 18, weight: FontWeight.bold, color: Colors.white),
//                   AppText.customText('Create & view fee structures', size: 11, color: Colors.white70),
//                 ]),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(color: AppColor.glassWhite, borderRadius: BorderRadius.circular(20)),
//                 child: Row(children: [
//                   const Icon(Icons.receipt_long, color: Colors.white, size: 16),
//                   const SizedBox(width: 6),
//                   AppText.customText('Fees', size: 13, weight: FontWeight.bold, color: Colors.white),
//                 ]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             decoration: BoxDecoration(color: AppColor.glassWhite, borderRadius: BorderRadius.circular(14)),
//             child: TabBar(
//               controller: _tabController,
//               indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
//               indicatorSize: TabBarIndicatorSize.tab,
//               labelColor: AppColor.lightBlueColor,
//               unselectedLabelColor: Colors.white,
//               labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//               dividerColor: Colors.transparent,
//               padding: const EdgeInsets.all(4),
//               tabs: const [
//                 Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   Icon(Icons.add_circle_outline, size: 16), SizedBox(width: 6), Text('Create'),
//                 ])),
//                 Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   Icon(Icons.list_alt, size: 16), SizedBox(width: 6), Text('View All'),
//                 ])),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   // TAB 1: CREATE
//   // ─────────────────────────────────────────────
//   Widget _buildCreateTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Section 1 ──────────────────────────
//           _sectionHeader('1', 'Fee Configuration', 'Select academic year, class and fee head'),
//           const SizedBox(height: 16),
//
//           _label('Academic Year *'),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Consumer<AcademicViewModel>(
//               builder: (context, academicVM, child) {
//
//                 if (academicVM.loading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 // ✅ Use id-based selection
//                 int? selectedId = selectedYear?.academicYearId;
//
//                 return DropdownButton<int>(
//                   value: selectedId,
//                   hint: const Text("Select Academic Year"),
//                   isExpanded: true,
//                   underline: const SizedBox(), // remove default underline
//                   items: academicVM.years.map((year) {
//                     return DropdownMenuItem<int>(
//                       value: year.academicYearId,
//                       child: Text(year.yearName ?? ''),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedYear = academicVM.years.firstWhere(
//                             (element) => element.academicYearId == value,
//                       );
//                     });
//                   },
//                 );
//               },
//             ),
//           )   ,       //     child: DropdownButton<String>(
//           //       value: _selectedAcademicYear, isExpanded: true,
//           //       hint: _hint('Select Academic Year', Icons.calendar_today),
//           //       icon: Icon(Icons.keyboard_arrow_down, color: AppColor.lightBlueColor),
//           //       items: _academicYears.map((yr) => DropdownMenuItem(
//           //         value: yr,
//           //         child: Row(children: [
//           //           Icon(Icons.calendar_today, size: 18, color: AppColor.lightBlueColor),
//           //           const SizedBox(width: 10), Text(yr),
//           //         ]),
//           //       )).toList(),
//           //       onChanged: (v) => setState(() => _selectedAcademicYear = v),
//           //     ),
//           //   ),
//           // ),
//           const SizedBox(height: 14),
//
//           _label('Class / Grade *'),
//           const SizedBox(height: 8),
//           Consumer<AllClassesViewModel>(builder: (ctx, vm, _) {
//             final classes = vm.allClassesModel?.data ?? [];
//             return _dropdownContainer(
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<int>(
//                   value: _selectedClassId, isExpanded: true,
//                   hint: _hint('Select Class', Icons.class_),
//                   icon: Icon(Icons.keyboard_arrow_down, color: AppColor.lightBlueColor),
//                   items: classes.map((c) => DropdownMenuItem(
//                     value: c.classId,
//                     child: Row(children: [
//                       Icon(Icons.school, size: 18, color: AppColor.lightBlueColor),
//                       const SizedBox(width: 10), Text(c.className ?? ''),
//                     ]),
//                   )).toList(),
//                   onChanged: (v) => setState(() => _selectedClassId = v),
//                 ),
//               ),
//             );
//           }),
//           const SizedBox(height: 14),
//
//           _label('Fee Head *'),
//           const SizedBox(height: 8),
//           Consumer<FeesHeadManagementViewModel>(builder: (ctx, vm, _) {
//             final feeHeads = vm.feesHeadManagementModel?.data?.feeHeads ?? [];
//             return _dropdownContainer(
//               child: vm.loading
//                   ? Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 child: Row(children: [
//                   SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.lightBlueColor)),
//                   const SizedBox(width: 12),
//                   Text('Loading fee heads...', style: TextStyle(color: Colors.grey.shade500)),
//                 ]),
//               )
//                   : DropdownButtonHideUnderline(
//                 child: DropdownButton<int>(
//                   value: _selectedFeeHeadId, isExpanded: true,
//                   hint: _hint('Select Fee Head', Icons.category),
//                   icon: Icon(Icons.keyboard_arrow_down, color: AppColor.lightBlueColor),
//                   items: feeHeads.map((h) => DropdownMenuItem(
//                     value: h.feeHeadId,
//                     child: Row(children: [
//                       Icon(Icons.category, size: 18, color: AppColor.lightBlueColor),
//                       const SizedBox(width: 10), Expanded(child: Text(h.headName ?? '')),
//                     ]),
//                   )).toList(),
//                   onChanged: (v) {
//                     setState(() {
//                       _selectedFeeHeadId   = v;
//                       _selectedFeeHeadName = feeHeads.firstWhere((h) => h.feeHeadId == v).headName;
//                     });
//                   },
//                 ),
//               ),
//             );
//           }),
//           const SizedBox(height: 24),
//
//           // ── Section 2 ──────────────────────────
//           _sectionHeader('2', 'Financial Details', 'Set payment frequency, base amount and due dates'),
//           const SizedBox(height: 16),
//
//           _label('Payment Frequency *'),
//           const SizedBox(height: 10),
//           Wrap(
//             spacing: 8, runSpacing: 8,
//             children: _frequencies.map((f) {
//               final sel = _selectedFrequency == f;
//               return GestureDetector(
//                 onTap: () {
//                   setState(() => _selectedFrequency = f);
//                   _tryGeneratePreview();
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   decoration: BoxDecoration(
//                     gradient: sel ? AppColor.primaryGradient : null,
//                     color: sel ? null : Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: sel ? Colors.transparent : Colors.grey.shade300),
//                     boxShadow: sel ? [BoxShadow(color: AppColor.lightBlueColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
//                   ),
//                   child: Text(
//                     f.replaceAll('_', ' ').toUpperCase(),
//                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: sel ? Colors.white : Colors.grey.shade700),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 16),
//
//           _label('Base Amount (₹) *'),
//           const SizedBox(height: 8),
//           TextField(
//             controller: _baseAmountCtrl,
//             keyboardType: TextInputType.number,
//             onChanged: (_) => setState(() {}),
//             decoration: _inputDeco('0.00', Icons.currency_rupee),
//           ),
//           const SizedBox(height: 8),
//
//           if (_baseAmountCtrl.text.isNotEmpty)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: BoxDecoration(
//                 color: AppColor.lightBlueColor.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: AppColor.lightBlueColor.withOpacity(0.2)),
//               ),
//               child: Row(children: [
//                 Icon(Icons.info_outline, size: 16, color: AppColor.lightBlueColor),
//                 const SizedBox(width: 8),
//                 AppText.customText('BASE AMOUNT PREVIEW', size: 10, color: AppColor.lightBlueColor, weight: FontWeight.w600),
//                 const Spacer(),
//                 AppText.customText(
//                   '₹${double.tryParse(_baseAmountCtrl.text)?.toStringAsFixed(2) ?? "0.00"}',
//                   size: 16, weight: FontWeight.bold, color: AppColor.lightBlueColor,
//                 ),
//               ]),
//             ),
//           const SizedBox(height: 16),
//
//           // ── Dates ──────────────────────────────
//           Row(
//             children: [
//               Expanded(child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _label('Start Due Date *'),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _startDateCtrl, readOnly: true,
//                     onTap: () => _pickDate(_startDateCtrl),
//                     decoration: _inputDeco('yyyy-mm-dd', Icons.calendar_today),
//                   ),
//                 ],
//               )),
//               const SizedBox(width: 12),
//               Expanded(child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _label('End Due Date *'),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _endDateCtrl, readOnly: true,
//                     onTap: () => _pickDate(_endDateCtrl),
//                     decoration: _inputDeco('yyyy-mm-dd', Icons.event),
//                   ),
//                 ],
//               )),
//             ],
//           ),
// // After the date row, before the preview section:
//           if (_installments.isNotEmpty) ...[
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity, height: 48,
//               child: ElevatedButton.icon(
//                 onPressed: () => setState(() => _previewVisible = true),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.lightBlueColor,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   elevation: 0,
//                 ),
//                 icon: const Icon(Icons.visibility_outlined, color: Colors.white, size: 18),
//                 label: Text(
//                   'Preview Installments  ${_installments.length}',
//                   style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//
// // Change the preview condition:
//           if (_previewVisible && _installments.isNotEmpty) ...[
//             const SizedBox(height: 28),
//             _buildInstallmentPreview(),
//           ],
//           // ════════════════════════════════════════
//           // SECTION 3: PREVIEW INSTALLMENTS
//           // ════════════════════════════════════════
//           // if (_showPreview) ...[
//           //   const SizedBox(height: 28),
//           //   _buildInstallmentPreview(),
//           // ],
//
//           const SizedBox(height: 28),
//
//           // Submit
//           Consumer<CreateFeesViewModel>(builder: (ctx, vm, _) {
//             return SizedBox(
//               width: double.infinity, height: 52,
//               child: ElevatedButton.icon(
//                 onPressed: vm.loading ? null : _submit,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.lightBlueColor,
//                   disabledBackgroundColor: AppColor.lightBlueColor.withOpacity(0.6),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   elevation: 0,
//                 ),
//                 icon: vm.loading
//                     ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                     : const Icon(Icons.add_rounded, color: Colors.white),
//                 label: Text(
//                   vm.loading ? 'Creating...' : 'Create Fee Structure',
//                   style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             );
//           }),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   // INSTALLMENT PREVIEW SECTION
//   // ─────────────────────────────────────────────
//   Widget _buildInstallmentPreview() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section header
//         _sectionHeader('3', 'Preview Installment Schedule', '${_installments.length} installments  •  Total: ₹${_totalAmount.toStringAsFixed(2)}'),
//         const SizedBox(height: 16),
//
//         // ── Summary card ─────────────────────────
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 10, offset: const Offset(0, 4))],
//           ),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Total Fee', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                   Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(color: AppColor.lightBlueColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
//                     child: Icon(Icons.copy_rounded, size: 14, color: AppColor.lightBlueColor),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   '₹${_totalAmount.toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColor.lightBlueColor),
//                 ),
//               ),
//               const Divider(height: 20),
//               _summaryRow('Installments', '${_installments.length}'),
//               _summaryRow('Frequency', _selectedFrequency.replaceAll('_', ' ').toUpperCase()),
//               _summaryRow('Base Amount', '₹${double.tryParse(_baseAmountCtrl.text)?.toStringAsFixed(2) ?? "0.00"}'),
//               // if (_selectedAcademicYear != null)
//               //   _summaryRow('Academic Year', _selectedAcademicYear!),
//               if (selectedYear != null)
//                 _summaryRow('Academic Year', selectedYear!.yearName ?? ''),
//               if (_startDateCtrl.text.isNotEmpty)
//                 _summaryRow('Start Date', _startDateCtrl.text),
//               if (_endDateCtrl.text.isNotEmpty)
//                 _summaryRow('End Date', _endDateCtrl.text),
//               const SizedBox(height: 8),
//               // Remaining balance bar
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Remaining Balance', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                   Text('₹0.00', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade600)),
//                 ],
//               ),
//               const SizedBox(height: 6),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: LinearProgressIndicator(
//                   value: 1.0,
//                   minHeight: 8,
//                   backgroundColor: Colors.grey.shade200,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade500),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//
//         // ── Installment table ─────────────────────
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 10, offset: const Offset(0, 4))],
//           ),
//           child: Column(
//             children: [
//               // Table header
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: AppColor.lightBlueColor.withOpacity(0.07),
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                 ),
//                 child: Row(
//                   children: [
//                     _tableHeader('#', flex: 1),
//                     _tableHeader('INSTALLMENT', flex: 3),
//                     _tableHeader('MONTH & YEAR', flex: 2),
//                     _tableHeader('AMOUNT (₹)', flex: 2),
//                     _tableHeader('DUE DATE', flex: 3),
//                     _tableHeader('STATUS', flex: 2),
//                   ],
//                 ),
//               ),
//
//               // Rows
//               ...List.generate(_installments.length, (i) {
//                 final ins = _installments[i];
//                 final isEven = i % 2 == 0;
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: isEven ? Colors.white : Colors.grey.shade50,
//                     borderRadius: i == _installments.length - 1
//                         ? const BorderRadius.vertical(bottom: Radius.circular(16))
//                         : null,
//                   ),
//                   child: _InstallmentRow(
//                     installment: ins,
//                     isLast: i == _installments.length - 1,
//                     onDueDateChanged: (date) {
//                       setState(() => _installments[i].dueDate = date);
//                     },
//                     onEndDueDateChanged: (date) {
//                       setState(() => _installments[i].endDueDate = date);
//                     },
//                     onAmountChanged: (val) {
//                       setState(() => _installments[i].amount = val);
//                     },
//                   ),
//                   // _InstallmentRow(
//                   //   installment: ins,
//                   //   isLast: i == _installments.length - 1,
//                   //   onDueDateChanged: (date) {
//                   //     setState(() => _installments[i].dueDate = date);
//                   //   },
//                   //   onStatusChanged: (status) {
//                   //     setState(() => _installments[i].status = status);
//                   //   },
//                   // ),
//                 );
//               }),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//
//         // ── Confirm button ────────────────────────
//         Consumer<CreateFeesViewModel>(builder: (ctx, vm, _) {
//           return SizedBox(
//             width: double.infinity, height: 52,
//             child: ElevatedButton(
//               onPressed: vm.loading ? null : _submit,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.lightBlueColor,
//                 disabledBackgroundColor: AppColor.lightBlueColor.withOpacity(0.6),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 elevation: 0,
//               ),
//               child: vm.loading
//                   ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                   : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 const Text('Confirm & Assign Fee',
//                     style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//                 const SizedBox(width: 8),
//                 const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
//               ]),
//             ),
//           );
//         }),
//       ],
//     );
//   }
//
//   Widget _summaryRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//           Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
//
//   Widget _tableHeader(String label, {required int flex}) {
//     return Expanded(
//       flex: flex,
//       child: Text(label,
//           style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColor.lightBlueColor, letterSpacing: 0.5)),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   // TAB 2: VIEW
//   // ─────────────────────────────────────────────
//   Widget _buildViewTab() {
//     return Consumer<FeesManagementViewModel>(builder: (ctx, vm, _) {
//       final allFees = vm.feesManagementModel?.data?.fees ?? [];
//       final displayFees = _viewFilter == 'all'
//           ? allFees
//           : allFees.where((f) => f.feeFrequency?.toLowerCase() == _viewFilter).toList();
//
//       return Column(
//         children: [
//           Container(
//             height: screenHeight * 0.04,
//             margin: const EdgeInsets.fromLTRB(18, 6, 18, 4),
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 _viewChip('All', 'all'), const SizedBox(width: 8),
//                 _viewChip('Monthly', 'monthly'), const SizedBox(width: 8),
//                 _viewChip('Quarterly', 'Quarterly'), const SizedBox(width: 8),
//                 _viewChip('One Time', 'one_time'), const SizedBox(width: 8),
//                 _viewChip('Half Yearly', 'half_yearly'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: vm.loading
//                 ? _shimmer()
//                 : displayFees.isEmpty
//                 ? _emptyView()
//                 : ListView.builder(
//               padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
//               physics: const BouncingScrollPhysics(),
//               itemCount: displayFees.length,
//               itemBuilder: (_, i) => _feeCard(displayFees[i]),
//             ),
//           ),
//         ],
//       );
//     });
//   }
//
//   Widget _viewChip(String label, String value) {
//     final sel = _viewFilter == value;
//     return GestureDetector(
//       onTap: () => setState(() => _viewFilter = value),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           gradient: sel ? AppColor.primaryGradient : null,
//           color: sel ? null : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 4, offset: const Offset(0, 2))],
//         ),
//         child: Text(label,
//             style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : AppColor.softGreyText)),
//       ),
//     );
//   }
//
//   Widget _feeCard(dynamic fee) {
//     final frequency = fee.feeFrequency?.toLowerCase() ?? '';
//     Color statusColor;
//     IconData statusIcon;
//
//     switch (frequency) {
//       case 'monthly':     statusColor = Colors.blue;   statusIcon = Icons.calendar_month; break;
//       case 'Quarterly':      statusColor = Colors.green;  statusIcon = Icons.calendar_today; break;
//       case 'one_time':    statusColor = Colors.orange; statusIcon = Icons.payment;        break;
//       case 'half_yearly': statusColor = Colors.purple; statusIcon = Icons.date_range;     break;
//       default:            statusColor = Colors.grey;   statusIcon = Icons.schedule;
//     }
//
//     final baseAmount  = double.tryParse(fee.baseAmount?.toString()  ?? '0') ?? 0;
//     final totalAmount = double.tryParse(fee.totalAmount?.toString() ?? '0') ?? 0;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 10, offset: const Offset(0, 5))],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.08),
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Row(children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
//                 child: Icon(statusIcon, color: statusColor, size: 18),
//               ),
//               const SizedBox(width: 10),
//               Expanded(child: AppText.customText(fee.feeHeadName ?? 'N/A', size: 15, weight: FontWeight.bold)),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
//                 child: Text(frequency.replaceAll('_', ' ').toUpperCase(),
//                     style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
//               ),
//             ]),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(children: [
//               Row(children: [
//                 _infoChip(Icons.class_, fee.className ?? 'N/A', Colors.blue),
//                 const SizedBox(width: 10),
//                 _infoChip(Icons.calendar_month, fee.academicYear ?? 'N/A', Colors.purple),
//               ]),
//               const SizedBox(height: 10),
//               Row(children: [
//                 Expanded(child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
//                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     AppText.customText('Base Amount', size: 10, color: AppColor.softGreyText),
//                     const SizedBox(height: 4),
//                     AppText.customText('₹${baseAmount.toStringAsFixed(2)}', size: 14, weight: FontWeight.bold),
//                   ]),
//                 )),
//                 const SizedBox(width: 10),
//                 Expanded(child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(color: AppColor.lightBlueColor.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
//                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     AppText.customText('Total Amount', size: 10, color: AppColor.lightBlueColor),
//                     const SizedBox(height: 4),
//                     AppText.customText('₹${totalAmount.toStringAsFixed(2)}', size: 14, weight: FontWeight.bold, color: AppColor.lightBlueColor),
//                   ]),
//                 )),
//               ]),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _infoChip(IconData icon, String label, Color color) {
//     return Expanded(child: Row(children: [
//       Icon(icon, size: 13, color: color), const SizedBox(width: 5),
//       Flexible(child: AppText.customText(label, size: 12, color: AppColor.softGreyText)),
//     ]));
//   }
//
//   Widget _emptyView() {
//     return Center(
//       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.receipt_long, size: 70, color: AppColor.lightBlueColor.withOpacity(0.3)),
//         const SizedBox(height: 16),
//         AppText.customText('No fee structures found', size: 16, weight: FontWeight.bold),
//         const SizedBox(height: 8),
//         AppText.customText('Switch to Create tab to add one', size: 13, color: AppColor.softGreyText),
//         const SizedBox(height: 16),
//         ElevatedButton.icon(
//           onPressed: () => _tabController.animateTo(0),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColor.lightBlueColor,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           icon: const Icon(Icons.add, color: Colors.white, size: 16),
//           label: const Text('Create Now', style: TextStyle(color: Colors.white)),
//         ),
//       ]),
//     );
//   }
//
//   Widget _shimmer() {
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
//       itemCount: 5,
//       itemBuilder: (_, __) => Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Container(
//           height: 130, margin: const EdgeInsets.only(bottom: 14),
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
//         ),
//       ),
//     );
//   }
//
//   // ── Helpers ───────────────────────────────────
//   Widget _sectionHeader(String num, String title, String sub) {
//     return Row(children: [
//       Container(
//         width: 32, height: 32,
//         decoration: BoxDecoration(gradient: AppColor.primaryGradient, shape: BoxShape.circle),
//         child: Center(child: Text(num, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
//       ),
//       const SizedBox(width: 12),
//       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         AppText.customText(title, size: 15, weight: FontWeight.bold),
//         AppText.customText(sub, size: 11, color: AppColor.softGreyText),
//       ])),
//     ]);
//   }
//
//   Widget _label(String text) =>
//       AppText.customText(text, size: 13, color: AppColor.softGreyText, weight: FontWeight.w500);
//
//   Widget _hint(String text, IconData icon) => Row(children: [
//     Icon(icon, size: 16, color: Colors.grey.shade400), const SizedBox(width: 8),
//     Text(text, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
//   ]);
//
//   Widget _dropdownContainer({required Widget child}) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: Colors.grey.shade200),
//       boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 6, offset: const Offset(0, 3))],
//     ),
//     child: child,
//   );
//
//   InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
//     hintText: hint,
//     hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
//     prefixIcon: Icon(icon, color: AppColor.lightBlueColor, size: 20),
//     filled: true, fillColor: Colors.white,
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
//     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColor.lightBlueColor, width: 2)),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Installment Row Widget (each row in the table)
// // ─────────────────────────────────────────────────────────────────────────────
// // class _InstallmentRow extends StatelessWidget {
// //   final _Installment installment;
// //   final bool isLast;
// //   final ValueChanged<DateTime> onDueDateChanged;
// //   final ValueChanged<String> onStatusChanged;
// //
// //   const _InstallmentRow({
// //     required this.installment,
// //     required this.isLast,
// //     required this.onDueDateChanged,
// //     required this.onStatusChanged,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
// //           child: Row(
// //             children: [
// //               // Index
// //               Expanded(
// //                 flex: 1,
// //                 child: Container(
// //                   width: 26, height: 26,
// //                   alignment: Alignment.center,
// //                   decoration: BoxDecoration(
// //                     color: AppColor.lightBlueColor.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(6),
// //                   ),
// //                   child: Text(
// //                     installment.index.toString().padLeft(2, '0'),
// //                     style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColor.lightBlueColor),
// //                   ),
// //                 ),
// //               ),
// //
// //               // Label
// //               Expanded(
// //                 flex: 3,
// //                 child: Text(
// //                   installment.label,
// //                   style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
// //                 ),
// //               ),
// //
// //               // Month & Year
// //               Expanded(
// //                 flex: 2,
// //                 child: Text(
// //                   installment.monthYear,
// //                   style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
// //                 ),
// //               ),
// //
// //               // Amount
// //               Expanded(
// //                 flex: 2,
// //                 child: Text(
// //                   installment.amount.toStringAsFixed(2),
// //                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// //                 ),
// //               ),
// //
// //               // Due Date (tappable)
// //               Expanded(
// //                 flex: 3,
// //                 child: GestureDetector(
// //                   onTap: () async {
// //                     final picked = await showDatePicker(
// //                       context: context,
// //                       initialDate: installment.dueDate,
// //                       firstDate: DateTime(2020),
// //                       lastDate: DateTime(2030),
// //                       builder: (ctx, child) => Theme(
// //                         data: Theme.of(ctx).copyWith(
// //                           colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
// //                         ),
// //                         child: child!,
// //                       ),
// //                     );
// //                     if (picked != null) onDueDateChanged(picked);
// //                   },
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
// //                     decoration: BoxDecoration(
// //                       border: Border.all(color: Colors.grey.shade300),
// //                       borderRadius: BorderRadius.circular(6),
// //                     ),
// //                     child: Row(children: [
// //                       Expanded(
// //                         child: Text(
// //                           DateFormat('dd/MM/yyyy').format(installment.dueDate),
// //                           style: const TextStyle(fontSize: 10),
// //                         ),
// //                       ),
// //                       Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade500),
// //                     ]),
// //                   ),
// //                 ),
// //               ),
// //
// //               // Status badge
// //               Expanded(
// //                 flex: 2,
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey.shade100,
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Text(
// //                     installment.status,
// //                     style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         if (!isLast) Divider(height: 1, color: Colors.grey.shade100),
// //       ],
// //     );
// //   }
// // }
// class _InstallmentRow extends StatefulWidget {
//   final _Installment installment;
//   final bool isLast;
//   final ValueChanged<DateTime> onDueDateChanged;
//   final ValueChanged<DateTime> onEndDueDateChanged;
//   final ValueChanged<double> onAmountChanged;
//
//   const _InstallmentRow({
//     required this.installment,
//     required this.isLast,
//     required this.onDueDateChanged,
//     required this.onEndDueDateChanged,
//     required this.onAmountChanged,
//   });
//
//   @override
//   State<_InstallmentRow> createState() => _InstallmentRowState();
// }
//
// class _InstallmentRowState extends State<_InstallmentRow> {
//   late TextEditingController _amtCtrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _amtCtrl = TextEditingController(
//         text: widget.installment.amount.toStringAsFixed(2));
//   }
//
//   @override
//   void dispose() {
//     _amtCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickDate(BuildContext context, bool isStart) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: isStart ? widget.installment.dueDate : widget.installment.endDueDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       isStart ? widget.onDueDateChanged(picked) : widget.onEndDueDateChanged(picked);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//           child: Row(
//             children: [
//               // Index
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   width: 26, height: 26,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: AppColor.lightBlueColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     widget.installment.index.toString().padLeft(2, '0'),
//                     style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
//                         color: AppColor.lightBlueColor),
//                   ),
//                 ),
//               ),
//               // Installment label
//               Expanded(
//                 flex: 3,
//                 child: Text(widget.installment.label,
//                     style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
//               ),
//               // Month & Year
//               Expanded(
//                 flex: 2,
//                 child: Text(widget.installment.monthYear,
//                     style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
//               ),
//               // Amount (editable)
//               Expanded(
//                 flex: 2,
//                 child: TextField(
//                   controller: _amtCtrl,
//                   keyboardType: TextInputType.number,
//                   style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
//                   decoration: InputDecoration(
//                     isDense: true,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(6),
//                       borderSide: BorderSide(color: Colors.grey.shade300),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(6),
//                       borderSide: BorderSide(color: Colors.grey.shade300),
//                     ),
//                   ),
//                   onChanged: (v) {
//                     final val = double.tryParse(v);
//                     if (val != null) widget.onAmountChanged(val);
//                   },
//                 ),
//               ),
//               const SizedBox(width: 4),
//               // Start Due Date
//               Expanded(
//                 flex: 3,
//                 child: GestureDetector(
//                   onTap: () => _pickDate(context, true),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       DateFormat('yyyy-MM-dd').format(widget.installment.dueDate),
//                       style: const TextStyle(fontSize: 9),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 4),
//               // End Due Date
//               Expanded(
//                 flex: 3,
//                 child: GestureDetector(
//                   onTap: () => _pickDate(context, false),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       DateFormat('yyyy-MM-dd').format(widget.installment.endDueDate),
//                       style: const TextStyle(fontSize: 9),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (!widget.isLast) Divider(height: 1, color: Colors.grey.shade100),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/utils/utils.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_fees_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees_head_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees_management_view_model.dart';

import '../model/school_model/academic_model.dart';
import '../view_model/school_view_model/academic_view_model.dart';

class _Installment {
  final int index;
  final String label;
  final String monthYear;
  double amount;
  DateTime dueDate;
  DateTime endDueDate;
  String status;

  _Installment({
    required this.index,
    required this.label,
    required this.monthYear,
    required this.amount,
    required this.dueDate,
    required this.endDueDate,
    this.status = 'Draft',
  });
}

class AdminViewFeesStructureScreen extends StatefulWidget {
  const AdminViewFeesStructureScreen({super.key});

  @override
  State<AdminViewFeesStructureScreen> createState() =>
      _AdminViewFeesStructureScreenState();
}

class _AdminViewFeesStructureScreenState
    extends State<AdminViewFeesStructureScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _baseAmountCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();

  AcademicData? selectedYear;
  int? _selectedClassId;
  int? _selectedFeeHeadId;
  String? _selectedFeeHeadName;
  String _selectedFrequency = 'monthly';

  final _frequencies = ['monthly', 'Quarterly', 'one_time', 'half_yearly'];

  List<_Installment> _installments = [];
  bool _previewVisible = false;
  String _viewFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['initialTab'] != null) {
        _tabController.animateTo(args['initialTab'] as int);
      }
      Provider.of<AcademicViewModel>(
        context,
        listen: false,
      ).academicApi(context);
      Provider.of<AllClassesViewModel>(
        context,
        listen: false,
      ).allClassesApi(context);
      Provider.of<FeesHeadManagementViewModel>(
        context,
        listen: false,
      ).feesHeadManagementApi(context);
      Provider.of<FeesManagementViewModel>(
        context,
        listen: false,
      ).feesManagementApi(context);
    });

    _baseAmountCtrl.addListener(_tryGeneratePreview);
    _startDateCtrl.addListener(_tryGeneratePreview);
    _endDateCtrl.addListener(_tryGeneratePreview);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _baseAmountCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ctrl.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  DateTime? _parseDate(String value) {
    try {
      return DateFormat('dd-MM-yyyy').parseStrict(value);
    } catch (_) {
      return null;
    }
  }

  void _tryGeneratePreview() {
    final amt = double.tryParse(_baseAmountCtrl.text.trim());

    final start = _parseDate(_startDateCtrl.text.trim());

    final selectedEndDate = _parseDate(_endDateCtrl.text.trim());

    if (amt == null || amt <= 0 || start == null) {
      setState(() {
        _installments = [];
        _previewVisible = false;
      });
      return;
    }

    final list = <_Installment>[];

    // ─────────────────────────────────────
    // ONE TIME
    // ─────────────────────────────────────
    if (_selectedFrequency == 'one_time') {
      list.add(
        _Installment(
          index: 1,
          label: 'One Time Payment',
          monthYear: DateFormat('MMM yyyy').format(start),
          amount: amt,
          dueDate: start,
          endDueDate:
              selectedEndDate ??
              DateTime(start.year, start.month + 1, start.day),
        ),
      );

      setState(() {
        _installments = list;
        _previewVisible = false;
      });

      return;
    }

    // ─────────────────────────────────────
    // Frequency Config
    // ─────────────────────────────────────
    late final int totalInstallments;
    late final int stepMonths;
    late final String labelPrefix;

    switch (_selectedFrequency) {
      case 'Quarterly':
        totalInstallments = 4;
        stepMonths = 3;
        labelPrefix = 'Quarterly Installment';
        break;

      case 'half_yearly':
        totalInstallments = 2;
        stepMonths = 6;
        labelPrefix = 'Half Yearly Installment';
        break;

      default:
        totalInstallments = 12;
        stepMonths = 1;
        labelPrefix = 'Monthly Installment';
    }

    // ─────────────────────────────────────
    // Generate Installments
    // ─────────────────────────────────────
    for (int i = 0; i < totalInstallments; i++) {
      final rawMonth = start.month + (i * stepMonths);

      final instYear = start.year + ((rawMonth - 1) ~/ 12);

      final instMonth = ((rawMonth - 1) % 12) + 1;

      final instStart = DateTime(instYear, instMonth, start.day);

      final rawEndMonth = instMonth + stepMonths;

      final endYear = instYear + ((rawEndMonth - 1) ~/ 12);

      final endMonth = ((rawEndMonth - 1) % 12) + 1;

      final calculatedEndDate = DateTime(
        endYear,
        endMonth,
        start.day,
      ).subtract(const Duration(days: 1));

      list.add(
        _Installment(
          index: i + 1,
          label: '$labelPrefix ${i + 1}',
          monthYear: DateFormat('MMM yyyy').format(instStart),
          amount: amt,
          dueDate: instStart,

          // User selected end date priority
          endDueDate: selectedEndDate ?? calculatedEndDate,
        ),
      );
    }

    setState(() {
      _installments = list;
      _previewVisible = false;
    });
  }

  double get _totalAmount => _installments.fold(0, (s, e) => s + e.amount);

  Future<void> _submit() async {
    if (_selectedClassId == null) {
      Utils.show('Please select class', context);
      return;
    }

    if (_selectedFeeHeadId == null) {
      Utils.show('Please select fee head', context);
      return;
    }

    if (_baseAmountCtrl.text.trim().isEmpty) {
      Utils.show('Base amount cannot be empty', context);
      return;
    }

    if (selectedYear == null || selectedYear!.yearName == null) {
      Utils.show('Please select academic year', context);
      return;
    }

    if (_startDateCtrl.text.trim().isEmpty) {
      Utils.show('Please select start date', context);
      return;
    }

    if (_endDateCtrl.text.trim().isEmpty) {
      Utils.show('Please select end date', context);
      return;
    }

    final success =
        await Provider.of<CreateFeesViewModel>(
          context,
          listen: false,
        ).createFeesApi(
          _selectedClassId!,
          _selectedFeeHeadId!,
          double.parse(_baseAmountCtrl.text.trim()),
          _selectedFrequency,
          selectedYear!.yearName!,
          _startDateCtrl.text.trim(),
          _endDateCtrl.text.trim(),
          context,
        );

    if (success) {
      /// Preview reset
      setState(() {
        _previewVisible = false;
        _installments.clear();
      });

      /// View All tab pe switch
      _tabController.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Scaffold(
        backgroundColor: AppColor.pageBgColor,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildCreateTab(), _buildViewTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColor.blueShadow,
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.glassWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText(
                      'Fee Structure',
                      size: 18,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    AppText.customText(
                      'Create & view fee structures',
                      size: 11,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.glassWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    AppText.customText(
                      'Fees',
                      size: 13,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColor.glassWhite,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColor.lightBlueColor,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, size: 16),
                      SizedBox(width: 6),
                      Text('Create'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt, size: 16),
                      SizedBox(width: 6),
                      Text('View All'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCreateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            '1',
            'Fee Configuration',
            'Select academic year, class and fee head',
          ),
          const SizedBox(height: 16),

          _label('Academic Year *'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Consumer<AcademicViewModel>(
              builder: (context, academicVM, child) {
                if (academicVM.loading)
                  return const Center(child: CircularProgressIndicator());
                return DropdownButton<int>(
                  value: selectedYear?.academicYearId,
                  hint: const Text("Select Academic Year"),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: academicVM.years
                      .map(
                        (year) => DropdownMenuItem<int>(
                          value: year.academicYearId,
                          child: Text(year.yearName ?? ''),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = academicVM.years.firstWhere(
                        (e) => e.academicYearId == value,
                      );
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          _label('Class / Grade *'),
          const SizedBox(height: 8),
          Consumer<AllClassesViewModel>(
            builder: (ctx, vm, _) {
              final classes = vm.allClassesModel?.data ?? [];
              return _dropdownContainer(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedClassId,
                    isExpanded: true,
                    hint: _hint('Select Class', Icons.class_),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor.lightBlueColor,
                    ),
                    items: classes
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.classId,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.school,
                                  size: 18,
                                  color: AppColor.lightBlueColor,
                                ),
                                const SizedBox(width: 10),
                                Text(c.className ?? ''),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedClassId = v),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 14),

          _label('Fee Head *'),
          const SizedBox(height: 8),
          Consumer<FeesHeadManagementViewModel>(
            builder: (ctx, vm, _) {
              final feeHeads = vm.feesHeadManagementModel?.data?.feeHeads ?? [];
              return _dropdownContainer(
                child: vm.loading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.lightBlueColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Loading fee heads...',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                    : DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _selectedFeeHeadId,
                          isExpanded: true,
                          hint: _hint('Select Fee Head', Icons.category),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor.lightBlueColor,
                          ),
                          items: feeHeads
                              .map(
                                (h) => DropdownMenuItem(
                                  value: h.feeHeadId,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.category,
                                        size: 18,
                                        color: AppColor.lightBlueColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(h.headName ?? '')),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _selectedFeeHeadId = v;
                              _selectedFeeHeadName = feeHeads
                                  .firstWhere((h) => h.feeHeadId == v)
                                  .headName;
                            });
                          },
                        ),
                      ),
              );
            },
          ),
          const SizedBox(height: 24),

          _sectionHeader(
            '2',
            'Financial Details',
            'Set payment frequency, base amount and due dates',
          ),
          const SizedBox(height: 16),

          _label('Payment Frequency *'),
          const SizedBox(height: 10),

          // ✅ Frequency chips with installment count badge
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _frequencies.map((f) {
              final sel = _selectedFrequency == f;
              final count = f == 'monthly'
                  ? '12'
                  : f == 'Quarterly'
                  ? '4'
                  : f == 'half_yearly'
                  ? '2'
                  : '1';
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedFrequency = f);
                  _tryGeneratePreview();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: sel ? AppColor.primaryGradient : null,
                    color: sel ? null : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sel ? Colors.transparent : Colors.grey.shade300,
                    ),
                    boxShadow: sel
                        ? [
                            BoxShadow(
                              color: AppColor.lightBlueColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        f.replaceAll('_', ' ').toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: sel ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: sel
                              ? Colors.white.withOpacity(0.25)
                              : AppColor.lightBlueColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          count,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: sel ? Colors.white : AppColor.lightBlueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          _label('Base Amount (₹) *'),
          const SizedBox(height: 8),
          TextField(
            controller: _baseAmountCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: _inputDeco('0.00', Icons.currency_rupee),
          ),
          const SizedBox(height: 8),

          if (_baseAmountCtrl.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColor.lightBlueColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.lightBlueColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColor.lightBlueColor,
                  ),
                  const SizedBox(width: 8),
                  AppText.customText(
                    'BASE AMOUNT PREVIEW',
                    size: 10,
                    color: AppColor.lightBlueColor,
                    weight: FontWeight.w600,
                  ),
                  const Spacer(),
                  AppText.customText(
                    '₹${double.tryParse(_baseAmountCtrl.text)?.toStringAsFixed(2) ?? "0.00"}',
                    size: 16,
                    weight: FontWeight.bold,
                    color: AppColor.lightBlueColor,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Start Due Date *'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _startDateCtrl,
                      readOnly: true,
                      onTap: () => _pickDate(_startDateCtrl),
                      decoration: _inputDeco(
                        'dd-mm-yyyy',
                        Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('End Due Date *'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _endDateCtrl,
                      readOnly: true,
                      onTap: () => _pickDate(_endDateCtrl),
                      decoration: _inputDeco('dd-mm-yyyy', Icons.event),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (_installments.isNotEmpty) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _previewVisible = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.lightBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(
                  Icons.visibility_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  'Preview Installments  (${_installments.length})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],

          if (_previewVisible && _installments.isNotEmpty) ...[
            const SizedBox(height: 28),
            _buildInstallmentPreview(),
          ],

          const SizedBox(height: 28),

          if (!_previewVisible)
            Consumer<CreateFeesViewModel>(
              builder: (ctx, vm, _) {
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: vm.loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightBlueColor,
                      disabledBackgroundColor: AppColor.lightBlueColor
                          .withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: vm.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add_rounded, color: Colors.white),
                    label: Text(
                      vm.loading ? 'Creating...' : 'Create Fee Structure',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInstallmentPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          '3',
          'Preview Installment Schedule',
          '${_installments.length} installments  •  Total: ₹${_totalAmount.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Fee',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColor.lightBlueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 14,
                      color: AppColor.lightBlueColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '₹${_totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColor.lightBlueColor,
                  ),
                ),
              ),
              const Divider(height: 20),
              _summaryRow('Installments', '${_installments.length}'),
              _summaryRow(
                'Frequency',
                _selectedFrequency.replaceAll('_', ' ').toUpperCase(),
              ),
              _summaryRow(
                'Base Amount',
                '₹${double.tryParse(_baseAmountCtrl.text)?.toStringAsFixed(2) ?? "0.00"}',
              ),
              if (selectedYear != null)
                _summaryRow('Academic Year', selectedYear!.yearName ?? ''),
              if (_startDateCtrl.text.isNotEmpty)
                _summaryRow('Start Date', _startDateCtrl.text),
              if (_endDateCtrl.text.isNotEmpty)
                _summaryRow('End Date', _endDateCtrl.text),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Remaining Balance',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '₹0.00',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColor.lightBlueColor.withOpacity(0.07),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    _tableHeader('#', flex: 0),
                    _tableHeader('INSTALLMENT', flex: 3),
                    _tableHeader('MONTH', flex: 2),
                    _tableHeader('AMOUNT', flex: 2),
                    _tableHeader('START DATE', flex: 3),
                    _tableHeader('END DATE', flex: 3),
                  ],
                ),
              ),
              ...List.generate(_installments.length, (i) {
                return Container(
                  decoration: BoxDecoration(
                    color: i % 2 == 0 ? Colors.white : Colors.grey.shade50,
                    borderRadius: i == _installments.length - 1
                        ? const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          )
                        : null,
                  ),
                  child: _InstallmentRow(
                    installment: _installments[i],
                    isLast: i == _installments.length - 1,
                    onDueDateChanged: (date) =>
                        setState(() => _installments[i].dueDate = date),
                    onEndDueDateChanged: (date) =>
                        setState(() => _installments[i].endDueDate = date),
                    onAmountChanged: (val) =>
                        setState(() => _installments[i].amount = val),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Consumer<CreateFeesViewModel>(
          builder: (ctx, vm, _) {
            return SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: vm.loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.lightBlueColor,
                  disabledBackgroundColor: AppColor.lightBlueColor.withOpacity(
                    0.6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: vm.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Confirm & Assign Fee',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  Widget _tableHeader(String label, {required int flex}) => Expanded(
    flex: flex,
    child: Text(
      label,
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.bold,
        color: AppColor.lightBlueColor,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _buildViewTab() {
    return Consumer<FeesManagementViewModel>(
      builder: (ctx, vm, _) {
        final allFees = vm.feesManagementModel?.data?.fees ?? [];
        final displayFees = _viewFilter == 'all'
            ? allFees
            : allFees
                  .where((f) => f.feeFrequency?.toLowerCase() == _viewFilter)
                  .toList();

        return Column(
          children: [
            Container(
              height: screenHeight * 0.04,
              margin: const EdgeInsets.fromLTRB(18, 6, 18, 4),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _viewChip('All', 'all'),
                  const SizedBox(width: 8),
                  _viewChip('Monthly', 'monthly'),
                  const SizedBox(width: 8),
                  _viewChip('Quarterly', 'Quarterly'),
                  const SizedBox(width: 8),
                  _viewChip('One Time', 'one_time'),
                  const SizedBox(width: 8),
                  _viewChip('Half Yearly', 'half_yearly'),
                ],
              ),
            ),
            Expanded(
              child: vm.loading
                  ? _shimmer()
                  : displayFees.isEmpty
                  ? _emptyView()
                  : RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<FeesManagementViewModel>(
                          context,
                          listen: false,
                        ).feesManagementApi(context);
                      },
                      color: AppColor.lightBlueColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),

                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),

                        itemCount: displayFees.length,

                        itemBuilder: (_, i) => _feeCard(displayFees[i]),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _viewChip(String label, String value) {
    final sel = _viewFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _viewFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: sel ? AppColor.primaryGradient : null,
          color: sel ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: sel ? Colors.white : AppColor.softGreyText,
          ),
        ),
      ),
    );
  }

  Widget _feeCard(dynamic fee) {
    final frequency = fee.feeFrequency?.toLowerCase() ?? '';
    Color statusColor;
    IconData statusIcon;
    switch (frequency) {
      case 'monthly':
        statusColor = Colors.blue;
        statusIcon = Icons.calendar_month;
        break;
      case 'quarterly':
        statusColor = Colors.green;
        statusIcon = Icons.calendar_today;
        break;
      case 'one_time':
        statusColor = Colors.orange;
        statusIcon = Icons.payment;
        break;
      case 'half_yearly':
        statusColor = Colors.purple;
        statusIcon = Icons.date_range;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.schedule;
    }
    final baseAmount = double.tryParse(fee.baseAmount?.toString() ?? '0') ?? 0;
    final totalAmount =
        double.tryParse(fee.totalAmount?.toString() ?? '0') ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText.customText(
                    fee.feeHeadName ?? 'N/A',
                    size: 15,
                    weight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showDeleteDialog(fee);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red, size: 14),
                        const SizedBox(width: 6),
                        const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    frequency.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    _infoChip(
                      Icons.class_,
                      fee.className ?? 'N/A',
                      Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    _infoChip(
                      Icons.calendar_month,
                      fee.academicYear ?? 'N/A',
                      Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.customText(
                              'Base Amount',
                              size: 10,
                              color: AppColor.softGreyText,
                            ),
                            const SizedBox(height: 4),
                            AppText.customText(
                              '₹${baseAmount.toStringAsFixed(2)}',
                              size: 14,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.lightBlueColor.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.customText(
                              'Total Amount',
                              size: 10,
                              color: AppColor.lightBlueColor,
                            ),
                            const SizedBox(height: 4),
                            AppText.customText(
                              '₹${totalAmount.toStringAsFixed(2)}',
                              size: 14,
                              weight: FontWeight.bold,
                              color: AppColor.lightBlueColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(dynamic fee) async {
    bool loading = false;
    String? apiMessage;
    bool? apiSuccess;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delete Fee Structure",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "This action cannot be undone",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// FEE INFO CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xfffdf5f5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        "Are you sure you want to delete the fee structure for ",
                                  ),
                                  TextSpan(
                                    text: "${fee.className}?",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            Text(
                              "Fee Head: ${fee.feeHeadName}",
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Amount: ₹${fee.totalAmount}",
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Academic Year: ${fee.academicYear}",
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      /// API RESPONSE CARD
                      if (apiMessage != null) ...[
                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: apiSuccess == true
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: apiSuccess == true
                                  ? Colors.green.shade300
                                  : Colors.red.shade300,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                apiSuccess == true
                                    ? Icons.check_circle
                                    : Icons.error_outline,
                                color: apiSuccess == true
                                    ? Colors.green
                                    : Colors.red,
                                size: 32,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                apiMessage!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: apiSuccess == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),

                              if (apiSuccess == true)
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "Dialog will close automatically...",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: loading
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                      },
                                icon: Icon(Icons.close_rounded, size: 18),
                                label: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey.shade800,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: loading
                                    ? null
                                    : () async {
                                        setStateDialog(() {
                                          loading = true;
                                        });

                                        final result =
                                            await Provider.of<
                                                  FeesManagementViewModel
                                                >(context, listen: false)
                                                .deleteFee(fee.feeId, context);

                                        setStateDialog(() {
                                          loading = false;
                                          apiSuccess = result["success"];
                                          apiMessage = result["message"];
                                        });

                                        if (result["success"] == true) {
                                          await Provider.of<
                                                FeesManagementViewModel
                                              >(context, listen: false)
                                              .feesManagementApi(context);

                                          Future.delayed(
                                            const Duration(seconds: 2),
                                            () {
                                              if (mounted) {
                                                Navigator.pop(context);
                                              }
                                            },
                                          );
                                        }
                                      },

                                icon: loading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.delete_forever_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      ),

                                label: Text(
                                  loading ? "Deleting..." : "Delete",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: const Color(0xFFDC2626),
                                  disabledBackgroundColor: const Color(
                                    0xFFDC2626,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
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
            );
          },
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) => Expanded(
    child: Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Flexible(
          child: AppText.customText(
            label,
            size: 12,
            color: AppColor.softGreyText,
          ),
        ),
      ],
    ),
  );

  Widget _emptyView() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.receipt_long,
          size: 70,
          color: AppColor.lightBlueColor.withOpacity(0.3),
        ),
        const SizedBox(height: 16),
        AppText.customText(
          'No fee structures found',
          size: 16,
          weight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        AppText.customText(
          'Switch to Create tab to add one',
          size: 13,
          color: AppColor.softGreyText,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _tabController.animateTo(0),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.lightBlueColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white, size: 16),
          label: const Text(
            'Create Now',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );

  Widget _shimmer() => ListView.builder(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
    itemCount: 5,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );

  Widget _sectionHeader(String num, String title, String sub) => Row(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: AppColor.primaryGradient,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            num,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.customText(title, size: 15, weight: FontWeight.bold),
            AppText.customText(sub, size: 11, color: AppColor.softGreyText),
          ],
        ),
      ),
    ],
  );

  Widget _label(String text) => AppText.customText(
    text,
    size: 13,
    color: AppColor.softGreyText,
    weight: FontWeight.w500,
  );

  Widget _hint(String text, IconData icon) => Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey.shade400),
      const SizedBox(width: 8),
      Text(text, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
    ],
  );

  Widget _dropdownContainer({required Widget child}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: AppColor.cardShadow,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: child,
  );

  InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    prefixIcon: Icon(icon, color: AppColor.lightBlueColor, size: 20),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColor.lightBlueColor, width: 2),
    ),
  );
}

class _InstallmentRow extends StatefulWidget {
  final _Installment installment;
  final bool isLast;
  final ValueChanged<DateTime> onDueDateChanged;
  final ValueChanged<DateTime> onEndDueDateChanged;
  final ValueChanged<double> onAmountChanged;

  const _InstallmentRow({
    required this.installment,
    required this.isLast,
    required this.onDueDateChanged,
    required this.onEndDueDateChanged,
    required this.onAmountChanged,
  });

  @override
  State<_InstallmentRow> createState() => _InstallmentRowState();
}

class _InstallmentRowState extends State<_InstallmentRow> {
  late TextEditingController _amtCtrl;

  @override
  void initState() {
    super.initState();
    _amtCtrl = TextEditingController(
      text: widget.installment.amount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _amtCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? widget.installment.dueDate
          : widget.installment.endDueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
        ),
        child: child!,
      ),
    );
    if (picked != null)
      isStart
          ? widget.onDueDateChanged(picked)
          : widget.onEndDueDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.lightBlueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.installment.index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColor.lightBlueColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  widget.installment.label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.installment.monthYear,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _amtCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (v) {
                    final val = double.tryParse(v);
                    if (val != null) widget.onAmountChanged(val);
                  },
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => _pickDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      DateFormat(
                        'dd-MM-yyyy',
                      ).format(widget.installment.dueDate),
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => _pickDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      DateFormat(
                        'dd-MM-yyyy',
                      ).format(widget.installment.endDueDate),
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!widget.isLast) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
