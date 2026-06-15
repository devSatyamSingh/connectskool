import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/model/school_model/transport_model/route_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/create_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/delete_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/update_route_view_model.dart';

import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

// ─── Screen ──────────────────────────────────────────────────────────────────

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetRouteViewModel>(context, listen: false)
          .getRouteApi(context);
    });
  }

  void _refreshList() {
    Provider.of<GetRouteViewModel>(context, listen: false)
        .getRouteApi(context);
  }

  List<Data> _filtered(List<Data> all) {
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all
        .where((r) =>
    (r.routeName?.toLowerCase().contains(q) ?? false) ||
        (r.driverName?.toLowerCase().contains(q) ?? false) ||
        (r.vehicleNo?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  void _openSheet({Data? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RouteFormSheet(
        existing: existing,
        onSaved: _refreshList,
      ),
    );
  }

  // ── Delete with confirmation dialog ──────────────────────────────────────
  void _confirmDelete(Data r) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Route',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content:
        Text('Are you sure you want to delete "${r.routeName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          // ── Delete button: watches DeleteRouteViewModel loading ──
          Consumer<DeleteRouteViewModel>(
            builder: (context, deleteVm, _) => TextButton(
              onPressed: deleteVm.loading
                  ? null
                  : () async {
                final success = await deleteVm.deleteRouteApi(
                  r.transportRouteId,
                  context,
                );
                if (success) {
                  Navigator.pop(context); // close dialog
                  _refreshList();         // reload list
                }
              },
              child: deleteVm.loading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Color(0xFFFF4D6D)),
              )
                  : const Text('Delete',
                  style: TextStyle(
                      color: Color(0xFFFF4D6D),
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      body: Consumer<GetRouteViewModel>(
        builder: (context, vm, _) {
          final allRoutes = vm.routeModel?.data ?? [];
          final routes = _filtered(allRoutes);

          return Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: _buildSearchBar(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    AppText.customText(
                      vm.loading
                          ? 'Loading...'
                          : '${routes.length} route${routes.length != 1 ? 's' : ''} found',
                      size: 13,
                      color: Colors.grey.shade500,
                      weight: FontWeight.w600,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _refreshList,
                      child: Icon(Icons.refresh_rounded,
                          size: 20, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: vm.loading
                    ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF3F72FF)))
                    : routes.isEmpty
                    ? _buildEmpty()
                    : ListView.separated(
                  padding:
                  const EdgeInsets.fromLTRB(16, 4, 16, 100),
                  itemCount: routes.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (_, i) => _RouteCard(
                    route: routes[i],
                    onEdit: () {

                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.manageTransport)) {

                        Utils.show(
                          "You don't have permission to perform this action.",
                          context,
                        );

                        return;
                      }

                      _openSheet(
                        existing: routes[i],
                      );
                    },
                    onDelete: () {

                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.manageTransport)) {

                        Utils.show(
                          "You don't have permission to perform this action.",
                          context,
                        );

                        return;
                      }

                      _confirmDelete(
                        routes[i],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

          if (!PermissionExtensions.canAccess(
              PermissionKeys.manageTransport)) {

            Utils.show(
              "You don't have permission to perform this action.",
              context,
            );

            return;
          }

          _openSheet();
        },
        backgroundColor: const Color(0xFF3F72FF),
        elevation: 6,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: AppText.customText('Add Route',
            color: Colors.white, weight: FontWeight.bold, size: 14),
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
            child: AppText.customText('Route Management',
                size: 19, weight: FontWeight.bold, color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColor.glassWhite,
                borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.directions_bus_rounded,
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
          hintText: 'Search routes, drivers, vehicles...',
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

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bus_outlined,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          AppText.customText('No routes found',
              size: 16, weight: FontWeight.bold, color: Colors.grey.shade400),
          const SizedBox(height: 6),
          AppText.customText('Tap + Add Route to get started',
              size: 13, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

// ─── Route Card ──────────────────────────────────────────────────────────────

class _RouteCard extends StatelessWidget {
  final Data route;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RouteCard(
      {required this.route, required this.onEdit, required this.onDelete});

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
                  colors: [Color(0xFF3F72FF), Color(0xFF1A3FCC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.route_rounded,
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
                          route.routeName ?? '-',
                          size: 16,
                          weight: FontWeight.w800,
                          color: const Color(0xFF1a2340),
                        ),
                      ),
                      if ((route.totalStops ?? 0) > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${route.totalStops} stops',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3F72FF)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (route.vehicleNo?.isNotEmpty ?? false)
                    _InfoChip(
                        icon: Icons.directions_car_rounded,
                        label: route.vehicleNo!,
                        color: const Color(0xFF3F72FF),
                        bg: const Color(0xFFEEF2FF))
                  else
                    _InfoChip(
                        icon: Icons.directions_car_outlined,
                        label: 'No vehicle assigned',
                        color: Colors.grey.shade400,
                        bg: const Color(0xFFF5F5F5)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (route.driverName?.isNotEmpty ?? false)
                        Flexible(
                          child: _InfoChip(
                              icon: Icons.person_rounded,
                              label: route.driverName!,
                              color: const Color(0xFF5a6a8a),
                              bg: Colors.transparent,
                              small: true),
                        ),
                      if ((route.driverName?.isNotEmpty ?? false) &&
                          (route.driverPhone?.isNotEmpty ?? false))
                        const SizedBox(width: 8),
                      if (route.driverPhone?.isNotEmpty ?? false)
                        Flexible(
                          child: _InfoChip(
                              icon: Icons.phone_rounded,
                              label: route.driverPhone!,
                              color: const Color(0xFF5a6a8a),
                              bg: Colors.transparent,
                              small: true),
                        ),
                    ],
                  ),
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
  final String label;
  final Color color;
  final Color bg;
  final bool small;

  const _InfoChip(
      {required this.icon,
        required this.label,
        required this.color,
        required this.bg,
        this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: small
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: small
          ? null
          : BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: small ? 13 : 14, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(label,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: color),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
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
        decoration:
        BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}

// ─── Form Bottom Sheet ────────────────────────────────────────────────────────

class _RouteFormSheet extends StatefulWidget {
  final Data? existing;
  final VoidCallback onSaved;

  const _RouteFormSheet({this.existing, required this.onSaved});

  @override
  State<_RouteFormSheet> createState() => _RouteFormSheetState();
}

class _RouteFormSheetState extends State<_RouteFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _vehicleCtrl;
  late final TextEditingController _driverCtrl;
  late final TextEditingController _phoneCtrl;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.routeName ?? '');
    _vehicleCtrl = TextEditingController(text: e?.vehicleNo ?? '');
    _driverCtrl = TextEditingController(text: e?.driverName ?? '');
    _phoneCtrl = TextEditingController(text: e?.driverPhone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _vehicleCtrl.dispose();
    _driverCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isEdit) {
      // ── UPDATE ────────────────────────────────────────────────────────────
      final vm = Provider.of<UpdateRouteViewModel>(context, listen: false);
      final success = await vm.updateRouteApi(
        widget.existing!.transportRouteId,
        _nameCtrl.text.trim(),
        _vehicleCtrl.text.trim().isEmpty ? null : _vehicleCtrl.text.trim(),
        _driverCtrl.text.trim().isEmpty ? null : _driverCtrl.text.trim(),
        _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        context,
      );
      if (success) {
        Navigator.pop(context);
        widget.onSaved();
      }
    } else {
      // ── CREATE ────────────────────────────────────────────────────────────
      final vm = Provider.of<CreateRouteViewModel>(context, listen: false);
      final success = await vm.createFineApi(
        _nameCtrl.text.trim(),
        _vehicleCtrl.text.trim().isEmpty ? null : _vehicleCtrl.text.trim(),
        _driverCtrl.text.trim().isEmpty ? null : _driverCtrl.text.trim(),
        _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        context,
      );
      // CreateRouteViewModel already pops on success
      if (success) widget.onSaved();
    }
  }

  bool _isLoading(
      CreateRouteViewModel c, UpdateRouteViewModel u) =>
      _isEdit ? u.loading : c.loading;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Consumer2<CreateRouteViewModel, UpdateRouteViewModel>(
      builder: (context, createVm, updateVm, _) {
        final loading = _isLoading(createVm, updateVm);

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
          child: Form(
            key: _formKey,
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
                        gradient: const LinearGradient(
                            colors: [Color(0xFF3F72FF), Color(0xFF1A3FCC)]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.route_rounded,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    AppText.customText(
                      _isEdit ? 'Edit Route' : 'Add New Route',
                      size: 18,
                      weight: FontWeight.w900,
                      color: const Color(0xFF1a2340),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _FormField(
                  controller: _nameCtrl,
                  label: 'Route Name',
                  hint: 'e.g. Route A',
                  icon: Icons.route_rounded,
                  required: true,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Route name is required'
                      : null,
                ),
                const SizedBox(height: 14),
                _FormField(
                  controller: _vehicleCtrl,
                  label: 'Vehicle Number',
                  hint: 'e.g. UP32AB1234',
                  icon: Icons.directions_car_rounded,
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Vehicle number is required'
                      : null,
                ),
                const SizedBox(height: 14),
                _FormField(
                  controller: _driverCtrl,
                  label: 'Driver Name',
                  hint: 'e.g. Ramesh Kumar',
                  icon: Icons.person_rounded,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Driver name is required'
                      : null,
                ),
                const SizedBox(height: 14),
                _FormField(
                  controller: _phoneCtrl,
                  label: 'Driver Phone',
                  hint: '10-digit mobile number',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    if (v.trim().length != 10)
                      return 'Enter valid 10-digit number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                        loading ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: AppText.customText('Cancel',
                            size: 14,
                            weight: FontWeight.w700,
                            color: Colors.grey.shade600),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF3F72FF), Color(0xFF1A3FCC)]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                                color:
                                const Color(0xFF3F72FF).withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: loading ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: loading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.2, color: Colors.white),
                          )
                              : AppText.customText(
                              _isEdit ? 'Update Route' : 'Add Route',
                              size: 14,
                              weight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Reusable Form Field ──────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool required;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.required = false,
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
              const Text(' *',
                  style: TextStyle(color: Color(0xFFFF4D6D), fontSize: 13)),
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
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFFE2E8F5), width: 1.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFFE2E8F5), width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFF3F72FF), width: 1.8)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFFFF4D6D), width: 1.5)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFFFF4D6D), width: 1.8)),
          ),
        ),
      ],
    );
  }
}