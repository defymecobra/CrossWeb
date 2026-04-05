import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const FuelCalculatorApp());
}

class FuelCalculatorApp extends StatelessWidget {
  const FuelCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Calculator Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF3B82F6),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF10B981),
          surface: Color(0x991E293B), // Transparent surface
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradients
          Positioned(
            left: MediaQuery.of(context).size.width * 0.15 - 200,
            top: MediaQuery.of(context).size.height * 0.5 - 200,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.15),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.15 - 200,
            top: MediaQuery.of(context).size.height * 0.3 - 200,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.15),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Калькулятор властивостей палива',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Розрахунок складу та теплоти згоряння',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xFF3B82F6),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white54,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: 'Завдання 1'),
                        Tab(text: 'Завдання 2'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        Task1Tab(),
                        Task2Tab(),
                      ],
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
}

// ======================= GLASS CARD WIDGET =======================
class GlassCard extends StatelessWidget {
  final Widget child;
  final bool highlight;

  const GlassCard({super.key, required this.child, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: highlight 
                ? const Color(0xFF10B981).withOpacity(0.05) 
                : const Color(0xFF1E293B).withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlight ? const Color(0xFF10B981) : const Color(0xFF334155),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ======================= INPUT FIELD WIDGET =======================
class CustomInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomInput({super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A).withOpacity(0.6),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ======================= RESULT ROW =======================
class ResRow extends StatelessWidget {
  final String label;
  final String value;
  const ResRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}

// ======================= TASK 1 =======================
class Task1Tab extends StatefulWidget {
  const Task1Tab({super.key});

  @override
  State<Task1Tab> createState() => _Task1TabState();
}

class _Task1TabState extends State<Task1Tab> {
  final Map<String, TextEditingController> ctrl = {
    'HP': TextEditingController(text: "3.4"),
    'CP': TextEditingController(text: "70.6"),
    'SP': TextEditingController(text: "2.7"),
    'NP': TextEditingController(text: "1.2"),
    'OP': TextEditingController(text: "1.9"),
    'WP': TextEditingController(text: "5.0"),
    'AP': TextEditingController(text: "15.2"),
  };

  Map<String, dynamic>? result;

  void _calculate() {
    try {
      double HP = double.parse(ctrl['HP']!.text.replaceAll(',', '.'));
      double CP = double.parse(ctrl['CP']!.text.replaceAll(',', '.'));
      double SP = double.parse(ctrl['SP']!.text.replaceAll(',', '.'));
      double NP = double.parse(ctrl['NP']!.text.replaceAll(',', '.'));
      double OP = double.parse(ctrl['OP']!.text.replaceAll(',', '.'));
      double WP = double.parse(ctrl['WP']!.text.replaceAll(',', '.'));
      double AP = double.parse(ctrl['AP']!.text.replaceAll(',', '.'));

      double K_RS = 100 / (100 - WP);
      double K_RG = 100 / (100 - WP - AP);

      Map<String, double> dry = {
        'H': HP * K_RS,
        'C': CP * K_RS,
        'S': SP * K_RS,
        'N': NP * K_RS,
        'O': OP * K_RS,
        'A': AP * K_RS,
      };

      Map<String, double> comb = {
        'H': HP * K_RG,
        'C': CP * K_RG,
        'S': SP * K_RG,
        'N': NP * K_RG,
        'O': OP * K_RG,
      };

      double qrMj = (339 * CP + 1030 * HP - 108.8 * (OP - SP) - 25 * WP) / 1000;
      double qDryMj = (qrMj + 0.025 * WP) * 100 / (100 - WP);
      double qCombMj = (qrMj + 0.025 * WP) * 100 / (100 - WP - AP);

      setState(() {
        result = {
          'K_RS': K_RS,
          'K_RG': K_RG,
          'dry': dry,
          'comb': comb,
          'QR': qrMj,
          'QDry': qDryMj,
          'QComb': qCombMj,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть коректні числа')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Введення компонентів палива (%)',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Color(0xFF334155), height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: ctrl.entries.map((e) => SizedBox(
                        width: 150,
                        child: CustomInput(label: e.key, controller: e.value),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _calculate,
                        child: const Text('РОЗРАХУВАТИ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              if (result != null) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(width: 4, height: 24, color: const Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    const Text('Результати розрахунку', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: 250,
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Коефіцієнти', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            ResRow(label: 'K_RS', value: result!['K_RS'].toStringAsFixed(2)),
                            ResRow(label: 'K_RG', value: result!['K_RG'].toStringAsFixed(2)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: GlassCard(
                        highlight: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Теплота згоряння (МДж/кг)', style: TextStyle(color: Color(0xFF10B981), fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            ResRow(label: 'Робоча', value: result!['QR'].toStringAsFixed(4)),
                            ResRow(label: 'Суха', value: result!['QDry'].toStringAsFixed(4)),
                            ResRow(label: 'Горюча', value: result!['QComb'].toStringAsFixed(4)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Склад мас (%)', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      DataTable(
                        columnSpacing: 20,
                        headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.05)),
                        columns: const [
                          DataColumn(label: Text('Елемент', style: TextStyle(color: Colors.white70))),
                          DataColumn(label: Text('Суха маса', style: TextStyle(color: Colors.white70))),
                          DataColumn(label: Text('Горюча маса', style: TextStyle(color: Colors.white70))),
                        ],
                        rows: [
                          _buildTableRow('Водень (H)', result!['dry']['H'], result!['comb']['H']),
                          _buildTableRow('Вуглець (C)', result!['dry']['C'], result!['comb']['C']),
                          _buildTableRow('Сірка (S)', result!['dry']['S'], result!['comb']['S']),
                          _buildTableRow('Азот (N)', result!['dry']['N'], result!['comb']['N']),
                          _buildTableRow('Кисень (O)', result!['dry']['O'], result!['comb']['O']),
                          _buildTableRow('Зола (A)', result!['dry']['A'], null),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48), 
              ]
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildTableRow(String name, double? dry, double? comb) {
    return DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Text(dry != null ? dry.toStringAsFixed(2) : '-')),
      DataCell(Text(comb != null ? comb.toStringAsFixed(2) : '-')),
    ]);
  }
}

// ======================= TASK 2 =======================
class Task2Tab extends StatefulWidget {
  const Task2Tab({super.key});

  @override
  State<Task2Tab> createState() => _Task2TabState();
}

class _Task2TabState extends State<Task2Tab> {
  final Map<String, TextEditingController> ctrl = {
    'CG': TextEditingController(text: "85.5"),
    'HG': TextEditingController(text: "11.2"),
    'OG': TextEditingController(text: "0.8"),
    'SG': TextEditingController(text: "2.5"),
    'QG': TextEditingController(text: "40.4"),
    'W': TextEditingController(text: "2.0"),
    'A': TextEditingController(text: "0.15"),
    'V': TextEditingController(text: "333.3"),
  };

  Map<String, dynamic>? result;

  void _calculate() {
    try {
      double CG = double.parse(ctrl['CG']!.text.replaceAll(',', '.'));
      double HG = double.parse(ctrl['HG']!.text.replaceAll(',', '.'));
      double OG = double.parse(ctrl['OG']!.text.replaceAll(',', '.'));
      double SG = double.parse(ctrl['SG']!.text.replaceAll(',', '.'));
      double QG = double.parse(ctrl['QG']!.text.replaceAll(',', '.'));
      double W = double.parse(ctrl['W']!.text.replaceAll(',', '.'));
      double A = double.parse(ctrl['A']!.text.replaceAll(',', '.'));
      double V = double.parse(ctrl['V']!.text.replaceAll(',', '.'));

      double AP = A * (100 - W) / 100;
      double K_GR = (100 - W - AP) / 100;

      Map<String, double> working = {
        'C': CG * K_GR,
        'H': HG * K_GR,
        'O': OG * K_GR,
        'S': SG * K_GR,
        'A': AP,
        'V': V * (100 - W) / 100,
      };

      double QR = QG * K_GR - 0.025 * W;

      setState(() {
        result = {
          'working': working,
          'QR': QR,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть коректні числа')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Введення параметрів мазуту',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Color(0xFF334155), height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: ctrl.entries.map((e) => SizedBox(
                        width: 150,
                        child: CustomInput(label: e.key, controller: e.value),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _calculate,
                        child: const Text('РОЗРАХУВАТИ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              if (result != null) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(width: 4, height: 24, color: const Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    const Text('Результати розрахунку', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: 300,
                      child: GlassCard(
                        highlight: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Теплота згоряння (МДж/кг)', style: TextStyle(color: Color(0xFF10B981), fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            ResRow(label: 'Нижча робоча', value: result!['QR'].toStringAsFixed(4)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Склад робочої маси', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            ResRow(label: 'Вуглець (CP) %', value: result!['working']['C'].toStringAsFixed(2)),
                            ResRow(label: 'Водень (HP) %', value: result!['working']['H'].toStringAsFixed(2)),
                            ResRow(label: 'Кисень (OP) %', value: result!['working']['O'].toStringAsFixed(2)),
                            ResRow(label: 'Сірка (SP) %', value: result!['working']['S'].toStringAsFixed(2)),
                            ResRow(label: 'Зола (AP) %', value: result!['working']['A'].toStringAsFixed(2)),
                            ResRow(label: 'Ванадій (V) мг/кг', value: result!['working']['V'].toStringAsFixed(2)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48), 
              ]
            ],
          ),
        ),
      ),
    );
  }
}
