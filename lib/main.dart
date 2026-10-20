import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const NovaApp());

const navy = Color(0xFF203B72),
    blue = Color(0xFF5B63F6),
    pale = Color(0xFFF5F6FF),
    grey = Color(0xFF7D8BAB);

class Product {
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating = 4.5,
  });
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  double rating;
  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'] as int,
    title: j['title'] as String,
    price: (j['price'] as num).toDouble(),
    description: j['description'] as String,
    category: j['category'] as String,
    image: j['image'] as String,
    rating: ((j['rating']?['rate'] ?? 4.5) as num).toDouble(),
  );
}

class CartLine {
  CartLine(this.product, this.quantity);
  Product product;
  int quantity;
}

class NovaApp extends StatelessWidget {
  const NovaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NOVA',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: pale,
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      fontFamily: 'Roboto',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFDDE1FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFDDE1FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: blue, width: 1.5),
        ),
      ),
    ),
    home: const LoginPage(),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final form = GlobalKey<FormState>(),
      user = TextEditingController(),
      pass = TextEditingController();
  bool hide = true;
  void signIn() {
    if (!form.currentState!.validate()) return;
    final u = user.text.trim().toLowerCase();
    final isAdmin = u == 'admin' && pass.text == '1234';
    final isBuyer = u == 'cliente' && pass.text == '1234';
    if (!isAdmin && !isBuyer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => StorePage(
          isAdmin: isAdmin,
          username: isAdmin ? 'Administrador' : 'Cliente',
        ),
      ),
    );
  }

  @override
  void dispose() {
    user.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Positioned(top: -90, right: -80, child: _orb(280)),
        Positioned(bottom: -140, left: -90, child: _orb(300)),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(38, 34, 38, 30),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .94),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: blue.withValues(alpha: .12),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Form(
                    key: form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              _logo(64),
                              const SizedBox(height: 9),
                              const Text(
                                'N O V A',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: navy,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Center(
                          child: Text(
                            'Bienvenido a NOVA',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: navy,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Administra tu tienda de forma fácil y segura.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: grey, fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Usuario',
                          style: TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: user,
                          decoration: const InputDecoration(
                            hintText: 'Escribe tu usuario',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Ingresa tu usuario'
                              : null,
                          onFieldSubmitted: (_) => signIn(),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Contraseña',
                          style: TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: pass,
                          obscureText: hide,
                          decoration: InputDecoration(
                            hintText: 'Escribe tu contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => hide = !hide),
                              icon: Icon(
                                hide
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Ingresa tu contraseña'
                              : null,
                          onFieldSubmitted: (_) => signIn(),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 53,
                          child: FilledButton.icon(
                            onPressed: signIn,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text(
                              'Ingresar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 19),
                        const Center(
                          child: Text(
                            'Admin: admin / 1234    ·    Comprador: cliente / 1234',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _orb(double size) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: const Color(0xFFE5E6FF).withValues(alpha: .7),
  ),
);
Widget _logo(double size) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
    color: blue,
    borderRadius: BorderRadius.circular(size * .28),
    boxShadow: [
      BoxShadow(
        color: blue.withValues(alpha: .25),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Icon(
    Icons.shopping_bag_outlined,
    color: Colors.white,
    size: size * .48,
  ),
);

class StorePage extends StatefulWidget {
  const StorePage({super.key, required this.isAdmin, required this.username});
  final bool isAdmin;
  final String username;
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final products = <Product>[], cart = <CartLine>[];
  bool loading = true;
  String query = '', category = 'Todos', section = 'Productos';
  int view = 0;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final r = await http
          .get(Uri.parse('https://fakestoreapi.com/products/'))
          .timeout(const Duration(seconds: 15));
      if (r.statusCode != 200) throw Exception();
      final rows = jsonDecode(r.body) as List;
      if (!mounted) return;
      setState(() {
        products
          ..clear()
          ..addAll(
            rows.map((e) => Product.fromJson(e as Map<String, dynamic>)),
          );
        loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => loading = false);
    }
  }

  List<String> get categories => [
    'Todos',
    ...{for (final p in products) p.category},
  ];
  List<Product> get filtered => products
      .where(
        (p) =>
            (category == 'Todos' || p.category == category) &&
            (p.title.toLowerCase().contains(query.toLowerCase()) ||
                p.description.toLowerCase().contains(query.toLowerCase())),
      )
      .toList();
  int get count => cart.fold(0, (a, b) => a + b.quantity);
  double get total => cart.fold(0, (a, b) => a + b.product.price * b.quantity);
  void add(Product p) {
    setState(
      () => cart.indexWhere((l) => l.product.id == p.id) < 0
          ? cart.add(CartLine(p, 1))
          : cart.firstWhere((l) => l.product.id == p.id).quantity++,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.title} agregado al carrito'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> productForm({Product? product}) async {
    final p = await showDialog<Product>(
      context: context,
      builder: (_) => ProductDialog(
        product: product,
        categories: categories.where((c) => c != 'Todos').toList(),
      ),
    );
    if (p == null) return;
    setState(() {
      if (product == null) {
        p.id = products.fold<int>(0, (a, b) => a > b.id ? a : b.id) + 1;
        products.insert(0, p);
      } else {
        final i = products.indexOf(product);
        if (i >= 0) products[i] = p;
      }
    });
  }

  Future<void> delete(Product p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Eliminar “${p.title}” del catálogo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) setState(() => products.remove(p));
  }

  void openDetails(Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetail(
          product: p,
          isAdmin: widget.isAdmin,
          onEdit: () => productForm(product: p),
          onDelete: () => delete(p),
          onAdd: () => add(p),
        ),
      ),
    );
  }

  void checkout() {
    if (cart.isEmpty) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Compra confirmada'),
        content: Text(
          'Tu pedido por \$${total.toStringAsFixed(2)} quedó registrado en esta sesión.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              setState(cart.clear);
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void navigate(String s) {
    setState(() => section = s);
    if (s == 'Productos') return;
    if (s == 'Inicio') return;
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;
    return Scaffold(
      backgroundColor: pale,
      drawer: wide ? null : Drawer(child: _sidebar()),
      floatingActionButton: widget.isAdmin && section == 'Productos'
          ? FloatingActionButton.extended(
              onPressed: () => productForm(),
              backgroundColor: blue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Agregar producto'),
            )
          : null,
      body: Column(
        children: [
          Container(
            height: 76,
            color: Colors.white,
            child: Row(
              children: [
                if (!wide)
                  Builder(
                    builder: (drawerContext) => IconButton(
                      onPressed: () => Scaffold.of(drawerContext).openDrawer(),
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      _logo(42),
                      const SizedBox(width: 10),
                      const Text(
                        'NOVA',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 23,
                          letterSpacing: 1.4,
                          color: navy,
                        ),
                      ),
                    ],
                  ),
                ),
                if (section == 'Productos')
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: TextField(
                          onChanged: (v) => setState(() => query = v),
                          decoration: const InputDecoration(
                            hintText: 'Buscar productos...',
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const Spacer(),
                IconButton(
                  onPressed: () => setState(() => section = 'Carrito'),
                  icon: Badge(
                    label: Text('$count'),
                    isLabelVisible: count > 0,
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: navy,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFE6E9FF),
                    child: Text(
                      widget.username[0],
                      style: const TextStyle(
                        color: blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (wide) SizedBox(width: 216, child: _sidebar()),
                Expanded(
                  child: section == 'Productos' || section == 'Inicio'
                      ? _catalog()
                      : section == 'Carrito'
                      ? _cart()
                      : _sectionView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebar() => Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 14),
        for (final entry in [
          (Icons.home_outlined, 'Inicio'),
          (Icons.shopping_bag_outlined, 'Productos'),
          if (widget.isAdmin) ...[
            (Icons.point_of_sale_outlined, 'Ventas'),
            (Icons.inventory_2_outlined, 'Inventario'),
            (Icons.people_outline, 'Clientes'),
            (Icons.bar_chart_outlined, 'Reportes'),
          ],
        ])
          _nav(entry.$1, entry.$2),
        const Spacer(),
        _nav(Icons.settings_outlined, 'Configuración'),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EAFE),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.sell_outlined, color: blue),
                SizedBox(height: 7),
                Text(
                  'Grandes estilos, mejores precios',
                  style: TextStyle(color: navy, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tu tienda de confianza',
                  style: TextStyle(color: grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (_) => false,
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
        ),
      ],
    ),
  );
  Widget _nav(IconData icon, String label) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    child: ListTile(
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      selected: section == label,
      selectedTileColor: blue,
      selectedColor: Colors.white,
      leading: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      onTap: () => navigate(label),
    ),
  );
  Widget _catalog() {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (products.isEmpty)
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined, size: 50, color: grey),
            const Text('No se pudo cargar el catálogo'),
            FilledButton(
              onPressed: () {
                setState(() => loading = true);
                load();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    final items = filtered;
    return RefreshIndicator(
      onRefresh: load,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section == 'Inicio' ? 'Descubre NOVA' : 'Productos',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    section == 'Inicio'
                        ? 'Encuentra tus favoritos en un solo lugar.'
                        : 'Gestiona y descubre productos.',
                    style: const TextStyle(color: grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 17,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF626BFF), Color(0xFF9A9FFF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estilo para cada ocasión',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Explora productos seleccionados para ti',
                                style: TextStyle(
                                  color: Color(0xFFE9EAFF),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.isAdmin &&
                            MediaQuery.sizeOf(context).width > 850)
                          OutlinedButton.icon(
                            onPressed: () => productForm(),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Nuevo producto'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (section == 'Productos')
                    Wrap(
                      spacing: 9,
                      runSpacing: 8,
                      children: categories
                          .map(
                            (c) => ChoiceChip(
                              label: Text(c),
                              selected: category == c,
                              onSelected: (_) => setState(() => category = c),
                              selectedColor: blue,
                              labelStyle: TextStyle(
                                color: category == c ? Colors.white : navy,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
          if (items.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No hay productos que coincidan con la búsqueda.'),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            sliver: SliverLayoutBuilder(
              builder: (context, c) {
                final cols = c.crossAxisExtent > 1050
                    ? 4
                    : c.crossAxisExtent > 650
                    ? 3
                    : 2;
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _card(items[i]),
                    childCount: items.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: .67,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Product p) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      onTap: () => openDetails(p),
      borderRadius: BorderRadius.circular(17),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FF),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Image.network(
                      p.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: grey,
                      ),
                    ),
                  ),
                  if (widget.isAdmin)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: PopupMenuButton<String>(
                        onSelected: (v) =>
                            v == 'edit' ? productForm(product: p) : delete(p),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Editar')),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Eliminar'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              p.category.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: blue,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              p.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: navy, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFB547),
                  size: 17,
                ),
                Text(
                  ' ${p.rating.toStringAsFixed(1)}',
                  style: const TextStyle(color: grey, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  '\$${p.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            if (!widget.isAdmin)
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => add(p),
                    icon: const Icon(Icons.add_shopping_cart, size: 17),
                    label: const Text('Agregar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: blue,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
  Widget _cart() => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mi carrito',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: cart.isEmpty
              ? const Center(
                  child: Text(
                    'Tu carrito está vacío.',
                    style: TextStyle(color: grey),
                  ),
                )
              : ListView(
                  children: [
                    for (final line in cart)
                      Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Image.network(
                            line.product.image,
                            width: 48,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                          title: Text(
                            line.product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '\$${line.product.price.toStringAsFixed(2)} × ${line.quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => setState(
                                  () => line.quantity > 1
                                      ? line.quantity--
                                      : cart.remove(line),
                                ),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              IconButton(
                                onPressed: () =>
                                    setState(() => line.quantity++),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        if (cart.isNotEmpty)
          Row(
            children: [
              Text(
                'Total  \$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: checkout,
                icon: const Icon(Icons.lock_outline),
                label: const Text('Finalizar compra'),
              ),
            ],
          ),
      ],
    ),
  );
  Widget _sectionView() {
    final info = switch (section) {
      'Ventas' => 'Aún no hay ventas en esta sesión.',
      'Inventario' => 'Productos registrados: ${products.length}',
      'Clientes' => 'Sesión actual: ${widget.username}',
      'Reportes' => 'Productos: ${products.length}',
      _ =>
        'Cuenta: ${widget.username} · Rol: ${widget.isAdmin ? 'Administrador' : 'Comprador'}',
    };
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            section,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
          const SizedBox(height: 12),
          Text(info, style: const TextStyle(color: grey)),
        ],
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  const ProductDetail({
    super.key,
    required this.product,
    required this.isAdmin,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
  });
  final Product product;
  final bool isAdmin;
  final VoidCallback onEdit, onDelete, onAdd;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Detalle del producto'),
      actions: [
        if (isAdmin)
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
        if (isAdmin)
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: SizedBox(
            height: 300,
            child: Image.network(
              product.image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 60),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          product.category.toUpperCase(),
          style: const TextStyle(color: blue, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Calificación: ${product.rating} / 5     \$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, color: blue),
        ),
        const Divider(height: 32),
        const Text(
          'Descripción',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: const TextStyle(color: grey, height: 1.5),
        ),
        if (!isAdmin)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Agregar al carrito'),
            ),
          ),
      ],
    ),
  );
}

class ProductDialog extends StatefulWidget {
  const ProductDialog({super.key, this.product, required this.categories});
  final Product? product;
  final List<String> categories;
  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final form = GlobalKey<FormState>();
  late final title = TextEditingController(text: widget.product?.title ?? '');
  late final price = TextEditingController(
    text: widget.product?.price.toString() ?? '',
  );
  late final desc = TextEditingController(
    text: widget.product?.description ?? '',
  );
  late final image = TextEditingController(text: widget.product?.image ?? '');
  late String category =
      widget.product?.category ??
      (widget.categories.isEmpty ? 'electronics' : widget.categories.first);
  @override
  void dispose() {
    title.dispose();
    price.dispose();
    desc.dispose();
    image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.product == null ? 'Agregar producto' : 'Editar producto',
    ),
    content: SizedBox(
      width: 440,
      child: Form(
        key: form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa el nombre' : null,
              ),
              TextFormField(
                controller: price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  return n == null || n <= 0
                      ? 'Ingresa un precio válido'
                      : null;
                },
              ),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items:
                    (widget.categories.isEmpty
                            ? [
                                'electronics',
                                'jewelery',
                                "men's clothing",
                                "women's clothing",
                              ]
                            : widget.categories)
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (v) => setState(() => category = v!),
              ),
              TextFormField(
                controller: desc,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) => v == null || v.trim().length < 5
                    ? 'Agrega una descripción'
                    : null,
              ),
              TextFormField(
                controller: image,
                decoration: const InputDecoration(labelText: 'URL de imagen'),
                validator: (v) {
                  final u = Uri.tryParse(v ?? '');
                  return u == null ||
                          !u.hasScheme ||
                          !['http', 'https'].contains(u.scheme)
                      ? 'Ingresa una URL válida'
                      : null;
                },
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () {
          if (!form.currentState!.validate()) return;
          Navigator.pop(
            context,
            Product(
              id: widget.product?.id ?? 0,
              title: title.text.trim(),
              price: double.parse(price.text),
              description: desc.text.trim(),
              category: category,
              image: image.text.trim(),
              rating: widget.product?.rating ?? 4.5,
            ),
          );
        },
        child: const Text('Guardar'),
      ),
    ],
  );
}
