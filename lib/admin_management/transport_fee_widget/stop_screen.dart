import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/model/school_model/transport_model/route_model.dart';
import 'package:school_pro/model/school_model/transport_model/stop_model.dart';
import 'package:school_pro/model/school_model/fees/fees_head_management_model.dart' hide Data;
import 'package:school_pro/utils/utils.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fees_head_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/create_stop_view_model.dart';

import '../../res/app_button.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../view_model/school_view_model/transport_fee/delete_stop_view_model.dart';
import '../../view_model/school_view_model/transport_fee/update_stop_view_model.dart';

// ─── Fee Frequency Options ────────────────────────────────────────────────────

class _FreqOption {
  final String   value;
  final String   label;
  final IconData icon;
  const _FreqOption(this.value, this.label, this.icon);
}

const _freqOptions = [
  _FreqOption('monthly',     'Monthly',     Icons.calendar_month_rounded),
  _FreqOption('quarterly',   'Quarterly',   Icons.date_range_rounded),
  _FreqOption('half_yearly', 'Half Yearly', Icons.calendar_today_rounded),
  _FreqOption('yearly',      'Yearly',      Icons.event_rounded),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class StopScreen extends StatefulWidget {
  const StopScreen({super.key});

  @override
  State<StopScreen> createState() => _StopScreenState();
}

class _StopScreenState extends State<StopScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  Data? _selectedFilterRoute;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetRouteViewModel>(context, listen: false)
          .getRouteApi(context);
      Provider.of<FeesHeadManagementViewModel>(context, listen: false)
          .feesHeadManagementApi(context);
    });
  }

  void _onFilterRouteChanged(Data? route) {
    setState(() {
      _selectedFilterRoute = route;
      _searchQuery = '';
      _searchCtrl.clear();
    });
    if (route?.transportRouteId != null) {
      Provider.of<GetStopViewModel>(context, listen: false)
          .getStopApi(route!.transportRouteId.toString());
    }
  }

  String _freqLabel(String? val) =>
      _freqOptions
          .firstWhere((f) => f.value == val,
          orElse: () => const _FreqOption('', '-', Icons.help_outline))
          .label;

  void _openSheet({
    StopData?        existing,
    required List<Data>     routes,
    required List<FeeHeads> feeHeads,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _StopFormSheet(
        existing: existing,
        routes: routes,
        feeHeads: feeHeads,
        preselectedRoute: _selectedFilterRoute,
        onSaved: () {
          if (_selectedFilterRoute?.transportRouteId != null) {
            Provider.of<GetStopViewModel>(context, listen: false)
                .getStopApi(
                _selectedFilterRoute!.transportRouteId.toString());
          }
        },
      ),
    );
  }

  void _confirmDelete(StopData s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('stop.delete_stop'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text('stop.delete_confirm'.tr().replaceAll('{name}', s.stopName ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('stop.cancel'.tr(),
                style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final vm = Provider.of<DeleteStopViewModel>(context, listen: false);
              final success = await vm.deleteRouteApi(
                s.transportRouteStopId,
                context,
              );
              if (success) {
                if (_selectedFilterRoute?.transportRouteId != null) {
                  Provider.of<GetStopViewModel>(context, listen: false)
                      .getStopApi(_selectedFilterRoute!.transportRouteId.toString());
                }
              }
            },
            child: Text('stop.delete'.tr(),
                style: const TextStyle(
                    color: Color(0xFFFF4D6D),
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14)),
        backgroundColor: const Color(0xFF3F72FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      body: Consumer3<GetRouteViewModel, GetStopViewModel,
          FeesHeadManagementViewModel>(
        builder: (context, routeVm, stopVm, feeHeadVm, _) {
          final List<Data>     routes   = routeVm.routeModel?.data ?? [];
          final List<FeeHeads> feeHeads =
              feeHeadVm.feesHeadManagementModel?.data?.feeHeads ?? [];

          final List<StopData> allStops = stopVm.stopModel.data ?? [];
          final List<StopData> stops = _searchQuery.isEmpty
              ? allStops
              : allStops
              .where((s) =>
          (s.stopName
              ?.toLowerCase()
              .contains(_searchQuery.toLowerCase()) ??
              false))
              .toList();

          return Column(
            children: [
              _buildHeader(),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildRouteFilter(routes),
              ),

              if (_selectedFilterRoute != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: _buildSearchBar(),
                ),

              if (_selectedFilterRoute != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      AppText.customText(
                        stopVm.loading
                            ? 'stop.loading'.tr()
                            : 'stop.stops_found'.tr()
                            .replaceAll('{count}', '${stops.length}')
                            .replaceAll('{plural}', stops.length != 1 ? '' : ''),
                        size: 13,
                        color: Colors.grey.shade500,
                        weight: FontWeight.w600,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _onFilterRouteChanged(
                            _selectedFilterRoute),
                        child: Icon(Icons.refresh_rounded,
                            size: 20, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: _selectedFilterRoute == null
                    ? _buildSelectRoutePrompt()
                    : stopVm.loading
                    ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF3F72FF)))
                    : stops.isEmpty
                    ? _buildEmpty()
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                      16, 4, 16, 100),
                  itemCount: stops.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (_, i) => _StopCard(
                    stop: stops[i],
                    freqLabel: _freqLabel(
                        stops[i].feeFrequency),
                    onEdit: () {
                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.manageTransport)) {
                        Utils.show('stop.no_permission_edit'.tr(), context);
                        return;
                      }
                      _openSheet(
                        existing: stops[i],
                        routes: routes,
                        feeHeads: feeHeads,
                      );
                    },
                    onDelete: () {
                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.manageTransport)) {
                        Utils.show('stop.no_permission_delete'.tr(), context);
                        return;
                      }
                      _confirmDelete(stops[i]);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton:
      Consumer2<GetRouteViewModel, FeesHeadManagementViewModel>(
        builder: (context, routeVm, feeHeadVm, _) {
          final routes =
              routeVm.routeModel?.data ?? [];

          final feeHeads =
              feeHeadVm.feesHeadManagementModel
                  ?.data
                  ?.feeHeads ??
                  [];

          return SizedBox(
            width: 150,
            child: AppButton(
              title: 'stop.add_stop'.tr(),
              icon: Icons.add_rounded,
              height: 50,
              radius: 14,
              onTap: () {
                if (!PermissionExtensions.canAccess(
                    PermissionKeys.manageTransport)) {
                  Utils.show('stop.no_permission_add'.tr(), context);
                  return;
                }
                _openSheet(
                  routes: routes,
                  feeHeads: feeHeads,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRouteFilter(List<Data> routes) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Data>(
          value: _selectedFilterRoute,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.route_rounded,
                    size: 18, color: Colors.grey.shade400),
                const SizedBox(width: 10),
                Text('stop.select_route'.tr(),
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
              ],
            ),
          ),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(14),
          dropdownColor: Colors.white,
          icon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade400),
          ),
          selectedItemBuilder: (_) => routes
              .map((r) => Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.route_rounded,
                      size: 16, color: Color(0xFF3F72FF)),
                ),
                const SizedBox(width: 10),
                Text(r.routeName ?? '-',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1a2340))),
              ],
            ),
          ))
              .toList(),
          items: routes
              .map((r) => DropdownMenuItem<Data>(
            value: r,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.route_rounded,
                        size: 16,
                        color: Color(0xFF3F72FF)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(r.routeName ?? '-',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1a2340))),
                        if (r.vehicleNo?.isNotEmpty ?? false)
                          Text(r.vehicleNo!,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                  fontWeight:
                                  FontWeight.w500)),
                      ],
                    ),
                  ),
                  if (_selectedFilterRoute == r)
                    const Icon(Icons.check_circle_rounded,
                        size: 18, color: Color(0xFF3F72FF)),
                ],
              ),
            ),
          ))
              .toList(),
          onChanged: _onFilterRouteChanged,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: AppColor.blueShadow,
              blurRadius: 18,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColor.glassWhite, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText.customText('stop.title'.tr(),
                size: 19, weight: FontWeight.bold, color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColor.glassWhite,
                borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.location_on_rounded,
                color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1a2340)),
        decoration: InputDecoration(
          hintText: 'stop.search_hint'.tr(),
          hintStyle: TextStyle(
              color: Colors.grey.shade400, fontWeight: FontWeight.w500),
          prefixIcon: Icon(Icons.search_rounded,
              color: Colors.grey.shade400, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.close_rounded,
                color: Colors.grey.shade400, size: 20),
            onPressed: () => setState(() {
              _searchQuery = '';
              _searchCtrl.clear();
            }),
          )
              : null,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSelectRoutePrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.route_rounded, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          AppText.customText('stop.select_route_prompt'.tr(),
              size: 16,
              weight: FontWeight.bold,
              color: Colors.grey.shade400),
          const SizedBox(height: 6),
          AppText.customText('stop.select_route_desc'.tr(),
              size: 13, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_rounded,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          AppText.customText('stop.no_stops_found'.tr(),
              size: 16,
              weight: FontWeight.bold,
              color: Colors.grey.shade400),
          const SizedBox(height: 6),
          AppText.customText('stop.tap_to_add'.tr(),
              size: 13, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

// ─── Stop Card ──────────────────────────────────────────────────────────────

class _StopCard extends StatelessWidget {
  final StopData     stop;
  final String       freqLabel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StopCard({
    required this.stop,
    required this.freqLabel,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEF1FB), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF3F72FF).withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C9A7), Color(0xFF007A65)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.location_on_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText.customText(
                          stop.stopName ?? '-',
                          size: 16,
                          weight: FontWeight.w800,
                          color: const Color(0xFF1a2340),
                        ),
                      ),
                      if ((stop.totalStudents ?? 0) > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${stop.totalStudents} ${'stop.students'.tr()}',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3F72FF)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _InfoChip(
                          icon: Icons.currency_rupee_rounded,
                          label: '${double.tryParse(stop.baseAmount ?? '0')?.toStringAsFixed(0) ?? '0'}',
                          color: const Color(0xFF00C9A7),
                          bg: const Color(0xFFE6FAF7)),
                      const SizedBox(width: 8),
                      _InfoChip(
                          icon: Icons.social_distance_rounded,
                          label: '${double.tryParse(stop.distanceKm ?? '0')?.toStringAsFixed(1) ?? '0'} ${'stop.km'.tr()}',
                          color: const Color(0xFFFF8C42),
                          bg: const Color(0xFFFFF3EC)),
                    ],
                  ),
                  const SizedBox(height: 6),

                  _InfoChip(
                      icon: Icons.repeat_rounded,
                      label: freqLabel,
                      color: const Color(0xFF8B5CF6),
                      bg: const Color(0xFFF3EEFF),
                      small: true),
                ],
              ),
            ),

            Column(
              children: [
                _ActionBtn(
                    icon: Icons.edit_rounded,
                    color: const Color(0xFF3F72FF),
                    bg: const Color(0xFFEEF2FF),
                    onTap: onEdit),
                const SizedBox(height: 8),
                _ActionBtn(
                    icon: Icons.delete_rounded,
                    color: const Color(0xFFFF4D6D),
                    bg: const Color(0xFFFFF0F0),
                    onTap: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;
  final Color    bg;
  final bool     small;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: small
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: small
          ? null
          : BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: small ? 13 : 14, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData     icon;
  final Color        color;
  final Color        bg;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon,
        required this.color,
        required this.bg,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}

// ─── Form Bottom Sheet ────────────────────────────────────────────────────────

class _StopFormSheet extends StatefulWidget {
  final StopData?        existing;
  final List<Data>       routes;
  final List<FeeHeads>   feeHeads;
  final Data?            preselectedRoute;
  final VoidCallback     onSaved;

  const _StopFormSheet({
    this.existing,
    required this.routes,
    required this.feeHeads,
    this.preselectedRoute,
    required this.onSaved,
  });

  @override
  State<_StopFormSheet> createState() => _StopFormSheetState();
}

class _StopFormSheetState extends State<_StopFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _stopNameCtrl;
  late final TextEditingController _distanceCtrl;
  late final TextEditingController _amountCtrl;

  Data?     _selectedRoute;
  FeeHeads? _selectedFeeHead;
  String    _selectedFreq = 'monthly';

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;

    _stopNameCtrl = TextEditingController(text: e?.stopName ?? '');
    _distanceCtrl = TextEditingController(
        text: e != null
            ? (double.tryParse(e.distanceKm ?? '0')
            ?.toStringAsFixed(1) ??
            '')
            : '');
    _amountCtrl = TextEditingController(
        text: e != null
            ? (double.tryParse(e.baseAmount ?? '0')
            ?.toStringAsFixed(0) ??
            '')
            : '');
    if (e != null) {
      _selectedRoute = widget.routes.cast<Data?>().firstWhere(
            (r) => r?.transportRouteId == e.transportRouteId,
        orElse: () => null,
      );
      _selectedFreq = e.feeFrequency ?? 'monthly';
    } else {
      _selectedRoute = widget.preselectedRoute;
    }
  }

  @override
  void dispose() {
    _stopNameCtrl.dispose();
    _distanceCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRoute == null) {
      Utils.show('stop.route_name_required'.tr(), context);
      return;
    }
    if (_selectedFeeHead == null) {
      Utils.show('stop.fee_head_required'.tr(), context);
      return;
    }

    if (_isEdit) {
      final vm = Provider.of<UpdateStopViewModel>(context, listen: false);
      final success = await vm.updateStopApi(
        widget.existing!.transportRouteStopId,
        _stopNameCtrl.text.trim(),
        double.tryParse(_distanceCtrl.text.trim()),
        double.tryParse(_amountCtrl.text.trim()),
        _selectedFreq,
        context,
      );
      if (success) {
        Navigator.pop(context);
        widget.onSaved();
      }
      return;
    }

    final vm = Provider.of<CreateStopViewModel>(context, listen: false);
    final success = await vm.createStopApi(
      _selectedRoute!.transportRouteId,
      _stopNameCtrl.text.trim(),
      double.tryParse(_distanceCtrl.text.trim()),
      double.tryParse(_amountCtrl.text.trim()),
      _selectedFreq,
      _selectedFeeHead!.feeHeadId,
      context,
    );

    if (success) widget.onSaved();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFFF4D6D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Consumer<CreateStopViewModel>(
      builder: (context, vm, _) {
        final loading = !_isEdit && vm.loading;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xFF00C9A7),
                            Color(0xFF007A65)
                          ]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_on_rounded,
                            color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      AppText.customText(
                        _isEdit ? 'stop.edit_stop'.tr() : 'stop.add_new_stop'.tr(),
                        size: 18,
                        weight: FontWeight.w900,
                        color: const Color(0xFF1a2340),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('stop.select_route_hint'.tr(), Icons.route_rounded,
                      required: true),
                  const SizedBox(height: 6),
                  widget.routes.isEmpty
                      ? _buildLoadingDropdown('stop.loading_routes'.tr())
                      : _buildStyledDropdown<Data>(
                    value: _selectedRoute,
                    hint: 'stop.select_route_hint'.tr(),
                    icon: Icons.route_rounded,
                    iconBg: const Color(0xFFEEF2FF),
                    iconColor: const Color(0xFF3F72FF),
                    checkColor: const Color(0xFF3F72FF),
                    items: widget.routes,
                    itemLabel: (r) => r.routeName ?? '-',
                    onChanged: (r) =>
                        setState(() => _selectedRoute = r),
                  ),
                  const SizedBox(height: 14),

                  _FormField(
                    controller: _stopNameCtrl,
                    label: 'stop.stop_name'.tr(),
                    hint: 'stop.stop_name_hint'.tr(),
                    icon: Icons.location_on_rounded,
                    required: true,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'stop.stop_name_required'.tr()
                        : null,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _FormField(
                          controller: _distanceCtrl,
                          label: 'stop.distance'.tr(),
                          hint: 'stop.distance_hint'.tr(),
                          icon: Icons.social_distance_rounded,
                          required: true,
                          keyboardType:
                          const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'stop.distance_required'.tr();
                            if (double.tryParse(v) == null)
                              return 'stop.distance_invalid'.tr();
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FormField(
                          controller: _amountCtrl,
                          label: 'stop.base_amount'.tr(),
                          hint: 'stop.base_amount_hint'.tr(),
                          icon: Icons.currency_rupee_rounded,
                          required: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'stop.amount_required'.tr();
                            if (double.tryParse(v) == null)
                              return 'stop.amount_invalid'.tr();
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _buildLabel('stop.fee_frequency'.tr(), Icons.repeat_rounded,
                      required: true),
                  const SizedBox(height: 6),
                  _buildFrequencyDropdown(),
                  const SizedBox(height: 14),

                  _buildLabel('stop.fee_head'.tr(),
                      Icons.account_balance_wallet_rounded,
                      required: true),
                  const SizedBox(height: 6),
                  widget.feeHeads.isEmpty
                      ? _buildLoadingDropdown('stop.loading_fee_heads'.tr())
                      : IgnorePointer(
                    ignoring: _isEdit,
                    child: Opacity(
                      opacity: _isEdit ? 0.6 : 1,
                      child: _buildStyledDropdown<FeeHeads>(
                        value: _selectedFeeHead,
                        hint: 'stop.select_fee_head'.tr(),
                        icon: Icons.account_balance_wallet_rounded,
                        iconBg: const Color(0xFFF3EEFF),
                        iconColor: const Color(0xFF8B5CF6),
                        checkColor: const Color(0xFF8B5CF6),
                        items: widget.feeHeads,
                        itemLabel: (f) => f.headName ?? '-',
                        onChanged: (f) => setState(() => _selectedFeeHead = f),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: loading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14)),
                          ),
                          child: AppText.customText('stop.cancel'.tr(),
                              size: 14,
                              weight: FontWeight.w700,
                              color: Colors.grey.shade600),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          title: _isEdit
                              ? 'stop.update_stop'.tr()
                              : 'stop.add_stop'.tr(),
                          icon: _isEdit
                              ? Icons.edit_location_alt_rounded
                              : Icons.add_location_alt_rounded,
                          loading: loading,
                          height: 50,
                          radius: 14,
                          onTap: _save,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFrequencyDropdown() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _freqOptions.map((f) {
        final isSelected = _selectedFreq == f.value;
        final label = f.value == 'monthly' ? 'stop.monthly'.tr() :
        f.value == 'quarterly' ? 'stop.quarterly'.tr() :
        f.value == 'half_yearly' ? 'stop.half_yearly'.tr() :
        'stop.yearly'.tr();
        return GestureDetector(
          onTap: () => setState(() => _selectedFreq = f.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
              )
                  : null,
              color: isSelected ? null : const Color(0xFFF7F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : const Color(0xFFE2E8F5),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  f.icon,
                  size: 15,
                  color: isSelected ? Colors.white : const Color(0xFF8B5CF6),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF3a4a6b),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStyledDropdown<T>({
    required T?      value,
    required String  hint,
    required IconData icon,
    required Color   iconBg,
    required Color   iconColor,
    required Color   checkColor,
    required List<T> items,
    required String  Function(T) itemLabel,
    required void    Function(T?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F5), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          borderRadius: BorderRadius.circular(14),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF8898c0)),
          selectedItemBuilder: (_) => items
              .map((item) => Align(
            alignment: Alignment.centerLeft,
            child: Text(itemLabel(item),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a2340))),
          ))
              .toList(),
          items: items
              .map((item) => DropdownMenuItem<T>(
            value: item,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius:
                        BorderRadius.circular(8)),
                    child: Icon(icon,
                        size: 16, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(itemLabel(item),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1a2340))),
                  ),
                  if (value == item)
                    Icon(Icons.check_circle_rounded,
                        size: 18, color: checkColor),
                ],
              ),
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLoadingDropdown(String text) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F5), width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Color(0xFF3F72FF)),
          ),
          const SizedBox(width: 10),
          Text(text,
              style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, IconData icon,
      {bool required = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF5a6a8a)),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3a4a6b))),
        if (required)
          Text(' *',
              style: const TextStyle(
                  color: Color(0xFFFF4D6D), fontSize: 13)),
      ],
    );
  }
}

// ─── Reusable Form Field ──────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final TextEditingController      controller;
  final String                     label;
  final String                     hint;
  final IconData                   icon;
  final bool                       required;
  final String? Function(String?)? validator;
  final TextInputType?              keyboardType;
  final List<TextInputFormatter>?  inputFormatters;
  final TextCapitalization         textCapitalization;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.required           = false,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF5a6a8a)),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3a4a6b))),
            if (required)
              Text(' *',
                  style: const TextStyle(
                      color: Color(0xFFFF4D6D), fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1a2340)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
                fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF7F9FF),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFE2E8F5), width: 1.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFE2E8F5), width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF3F72FF), width: 1.8)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFFF4D6D), width: 1.5)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFFF4D6D), width: 1.8)),
          ),
        ),
      ],
    );
  }
}