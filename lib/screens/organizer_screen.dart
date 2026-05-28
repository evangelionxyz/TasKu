import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskuapp/globals/globals.dart';
import 'package:taskuapp/services/organizer_service.dart';
import 'package:taskuapp/services/theme_service.dart';
import 'package:taskuapp/widgets/stacked_card.dart';

class OrganizerPage extends StatefulWidget {
  const OrganizerPage({super.key, this.user});

  final User? user;

  @override
  State<OrganizerPage> createState() => _OrganizerPageState();
}

class _OrganizerPageState extends State<OrganizerPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return Scaffold(
      backgroundColor: theme.colors.bg,
      appBar: AppBar(
        backgroundColor: theme.colors.surface,
        foregroundColor: theme.colors.onCard,
        elevation: 0,
        titleSpacing: 0,
        title: const AppTitle(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              'Organizer',
              style: TextStyle(
                fontFamily: 'Roxborough',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.colors.accent,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colors.accent,
          indicatorWeight: 3,
          labelColor: theme.colors.onCard,
          unselectedLabelColor: theme.colors.accentDim,
          labelStyle: const TextStyle(
            fontFamily: 'Roxborough',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Telegraf',
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Checklist'),
            Tab(text: 'Compartment'),
            Tab(text: 'Stats'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const _OrganizerBody(),
          const _CompartmentMapTab(),
          const _StatsTab(),
        ],
      ),
      floatingActionButton: null,
    );
  }
}

// ─────────────────────────── Checklist Body ──────────────────────────────────

class _OrganizerBody extends StatelessWidget {
  const _OrganizerBody();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final organizer = context.watch<OrganizerService>();

    if (organizer.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.colors.accent),
      );
    }

    if (organizer.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.backpack_outlined, size: 56, color: theme.colors.accent),
            const SizedBox(height: 16),
            Text(
              'Your bag is empty',
              style: TextStyle(
                fontFamily: 'Roxborough',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: theme.colors.onCard,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _showAddSheet(context),
              child: SizedBox(
                width: 160,
                height: 52,
                child: Stack(
                  children: [
                    Positioned(
                      left: 4,
                      top: 4,
                      right: 0,
                      bottom: 0,
                      child: Container(color: theme.colors.onCard),
                    ),
                    Container(
                      width: 156,
                      height: 48,
                      color: theme.colors.accent,
                      alignment: Alignment.center,
                      child: Text(
                        'ADD ITEM',
                        style: TextStyle(
                          fontFamily: 'Telegraf',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colors.onDanger,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
      itemCount: organizer.items.length + 1,
      itemBuilder: (context, index) {
        if (index < organizer.items.length) {
          final item = organizer.items[index];
          return StaggeredListItem(
            index: index,
            child: _OrganizerItemTile(key: ValueKey(item.id), item: item),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
            child: GestureDetector(
              onTap: () => _showAddSheet(context),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Stack(
                  children: [
                    Positioned(
                      left: 5,
                      top: 5,
                      right: 0,
                      bottom: 0,
                      child: Container(color: theme.colors.onCard),
                    ),
                    Container(
                      color: theme.colors.accent,
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: theme.colors.onDanger,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ADD ITEM',
                            style: TextStyle(
                              fontFamily: 'Telegraf',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: theme.colors.onDanger,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

// ─────────────────────────── Item Tile ───────────────────────────────────────

class _OrganizerItemTile extends StatelessWidget {
  const _OrganizerItemTile({super.key, required this.item});
  final OrganizerItem item;

  void _showEditItemSheet(
    BuildContext context,
    ThemeService theme,
    OrganizerService organizer,
  ) {
    final controller = TextEditingController(text: item.name);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(ctx).viewInsets.bottom + 32,
              ),
              child: Container(
                color: theme.colors.card,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Item',
                      style: TextStyle(
                        fontFamily: 'Roxborough',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: theme.colors.onCard,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      color: theme.colors.surface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        style: TextStyle(
                          fontFamily: 'Telegraf',
                          fontSize: 15,
                          color: theme.colors.onCard,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Item name…',
                          hintStyle: TextStyle(color: theme.colors.accentDim),
                        ),
                        onSubmitted: (val) async {
                          final name = val.trim();
                          if (name.isEmpty) return;
                          await organizer.updateItem(item.id, name);
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final name = controller.text.trim();
                        if (name.isEmpty) return;
                        await organizer.updateItem(item.id, name);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 5,
                              top: 5,
                              right: 0,
                              bottom: 0,
                              child: Container(color: theme.colors.onCard),
                            ),
                            Container(
                              color: theme.colors.accent,
                              width: double.infinity,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontFamily: 'Roxborough',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colors.onDanger,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curve = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    ThemeService theme,
    OrganizerService organizer,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: theme.colors.card,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(
            'Delete Item',
            style: TextStyle(
              fontFamily: 'Roxborough',
              color: theme.colors.onCard,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${item.name}" from your bag?',
            style: TextStyle(
              fontFamily: 'Telegraf',
              color: theme.colors.onCard,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'CANCEL',
                style: TextStyle(color: theme.colors.accent),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                organizer.deleteItem(item.id);
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colors.danger,
                foregroundColor: theme.colors.onDanger,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final organizer = context.read<OrganizerService>();

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colors.danger,
        child: Icon(
          Icons.delete_outline,
          color: theme.colors.onDanger,
          size: 24,
        ),
      ),
      onDismissed: (_) => organizer.deleteItem(item.id),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              // Shadow / back layer
              Positioned(
                left: 4,
                top: 4,
                right: 0,
                bottom: 0,
                child: Container(color: theme.colors.onCard),
              ),
              // Front layer
              Container(
                color: theme.colors.card,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // Custom checkbox (stacked square style)
                    GestureDetector(
                      onTap: () =>
                          organizer.togglePacked(item.id, item.isPacked),
                      child: Container(
                        width: 22,
                        height: 22,
                        color: item.isPacked
                            ? theme.colors.accent
                            : theme.colors.bg,
                        alignment: Alignment.center,
                        child: item.isPacked
                            ? Icon(
                                Icons.check,
                                size: 14,
                                color: theme.colors.onDanger,
                              )
                            : Container(
                                width: 14,
                                height: 14,
                                color: theme.colors.card,
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontFamily: 'Telegraf',
                          fontSize: 15,
                          color: item.isPacked
                              ? theme.colors.accent
                              : theme.colors.onCard,
                          decoration: item.isPacked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: theme.colors.accent,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: theme.colors.accent,
                        size: 20,
                      ),
                      onPressed: () =>
                          _showEditItemSheet(context, theme, organizer),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outlined,
                        color: theme.colors.danger,
                        size: 20,
                      ),
                      onPressed: () =>
                          _confirmDelete(context, theme, organizer),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.drag_handle,
                      color: theme.colors.accent,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── Compartment Map Tab ─────────────────────────────

class _CompartmentMapTab extends StatelessWidget {
  const _CompartmentMapTab();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      children: [
        // Backpack silhouette illustration
        Center(
          child: Container(
            width: 180,
            height: 240,
            padding: const EdgeInsets.all(10),
            child: CustomPaint(
              painter: BackpackPainter(color: theme.colors.accent),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'COMPARTMENTS',
          style: TextStyle(
            fontFamily: 'Roxborough',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: theme.colors.accent,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildCompartmentRow(theme, 'Main Compartment', true),
        _buildCompartmentRow(theme, 'Side Pocket', false),
        _buildCompartmentRow(theme, 'Front Pocket', true),
      ],
    );
  }

  Widget _buildCompartmentRow(ThemeService theme, String label, bool isFilled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Positioned(
            left: 4,
            top: 4,
            right: 0,
            bottom: 0,
            child: Container(color: theme.colors.onCard),
          ),
          Container(
            color: theme.colors.card,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  isFilled ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isFilled
                      ? theme.colors.accent
                      : theme.colors.accentDim,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Telegraf',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: theme.colors.onCard,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  color: isFilled ? theme.colors.accent : theme.colors.surface,
                  child: Text(
                    isFilled ? 'FILLED' : 'EMPTY',
                    style: TextStyle(
                      fontFamily: 'Telegraf',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isFilled
                          ? theme.colors.onDanger
                          : theme.colors.accentDim,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to draw a clean minimalist backpack silhouette
class BackpackPainter extends CustomPainter {
  final Color color;
  const BackpackPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    // Main compartment
    path.moveTo(size.width * 0.25, size.height * 0.9);
    path.lineTo(size.width * 0.25, size.height * 0.35);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width * 0.75,
      size.height * 0.35,
    );
    path.lineTo(size.width * 0.75, size.height * 0.9);
    path.close();

    // Front pocket
    path.moveTo(size.width * 0.32, size.height * 0.9);
    path.lineTo(size.width * 0.32, size.height * 0.6);
    path.lineTo(size.width * 0.68, size.height * 0.6);
    path.lineTo(size.width * 0.68, size.height * 0.9);
    path.close();

    // Top loop
    path.moveTo(size.width * 0.45, size.height * 0.23);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.13,
      size.width * 0.55,
      size.height * 0.23,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BackpackPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ─────────────────────────── Statistics Tab ──────────────────────────────────

class _StatsTab extends StatelessWidget {
  const _StatsTab();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      children: [
        StackedCard(
          label: 'AVG Weight',
          child: Text(
            '2.4 kg',
            style: TextStyle(
              fontFamily: 'Roxborough',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colors.onCard,
            ),
          ),
        ),
        const SizedBox(height: 20),
        StackedCard(
          label: 'AVG Bag Opens',
          child: Text(
            '4.2×/day',
            style: TextStyle(
              fontFamily: 'Roxborough',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colors.onCard,
            ),
          ),
        ),
      ],
    );
  }
}

void _showAddSheet(BuildContext context) {
  final theme = Provider.of<ThemeService>(context, listen: false);
  final controller = TextEditingController();
  final organizer = context.read<OrganizerService>();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              MediaQuery.of(ctx).viewInsets.bottom + 32,
            ),
            child: Container(
              color: theme.colors.card,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Item',
                    style: TextStyle(
                      fontFamily: 'Roxborough',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: theme.colors.onCard,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    color: theme.colors.surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      style: TextStyle(
                        fontFamily: 'Telegraf',
                        fontSize: 15,
                        color: theme.colors.onCard,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Item name…',
                        hintStyle: TextStyle(color: theme.colors.accentDim),
                      ),
                      onSubmitted: (val) async {
                        final name = val.trim();
                        if (name.isEmpty) return;
                        await organizer.addItem(name);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      final name = controller.text.trim();
                      if (name.isEmpty) return;
                      await organizer.addItem(name);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 5,
                            top: 5,
                            right: 0,
                            bottom: 0,
                            child: Container(color: theme.colors.onCard),
                          ),
                          Container(
                            color: theme.colors.accent,
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Add to Bag',
                              style: TextStyle(
                                fontFamily: 'Roxborough',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: theme.colors.onDanger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (ctx, anim1, anim2, child) {
      final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curve),
        child: child,
      );
    },
  );
}

// ─────────────────────────── Staggered List Item Animation ───────────────────

class StaggeredListItem extends StatefulWidget {
  const StaggeredListItem({
    super.key,
    required this.child,
    required this.index,
  });

  final Widget child;
  final int index;

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    if (widget.index < 10) {
      Future.delayed(Duration(milliseconds: widget.index * 40), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeAnimation, child: widget.child);
  }
}
