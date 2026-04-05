import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const PowerLoadCalculatorApp());
}

class PowerLoadCalculatorApp extends StatelessWidget {
  const PowerLoadCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Розрахунок Електричних Навантажень',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF10B981), // Emerald Green
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF10B981),
          secondary: Color(0xFF0EA5E9), // Light Blue
          surface: Color(0x991E293B),
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
            left: -100,
            top: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.15), // Emerald
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -100,
            top: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0EA5E9).withOpacity(0.15), // Light blue
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Електричні Навантаження',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Метод впорядкованих діаграм - ПР6',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 20),
                
                const Expanded(
                  child: SingleChildScrollView(
                    child: CalculatorContent(),
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

// ======================= FORM WIDGETS =======================
class CustomInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomInput({super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7))),
        const SizedBox(height: 6),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0F172A).withOpacity(0.6),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ResRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const ResRow({super.key, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14))),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color ?? Colors.white)),
        ],
      ),
    );
  }
}

// ======================= DATA MODEL & LOGIC =======================
class EP {
  final int n;
  final double p;
  final double kv;
  final double tg;
  
  EP(this.n, this.p, this.kv, this.tg);

  double get np => n * p;
  double get npkv => n * p * kv;
  double get npkvtg => n * p * kv * tg;
  double get nP2 => n * pow(p, 2).toDouble();
}

class CalculatorContent extends StatefulWidget {
  const CalculatorContent({super.key});
  @override
  State<CalculatorContent> createState() => _CalculatorContentState();
}

class _CalculatorContentState extends State<CalculatorContent> {
  // Inputs matching Variant 4 defaults
  final ctrl_P_shlif = TextEditingController(text: "23.0");
  final ctrl_Kv_polir = TextEditingController(text: "0.24");
  final ctrl_tg_circ = TextEditingController(text: "1.58");
  
  // Custom coefficients (to be grabbed from tables 6.3 / 6.4)
  final ctrl_Kp_shr = TextEditingController(text: "1.27"); // Found in Table 6.3 for K_v=0.21, n_e=14
  final ctrl_Kp_shop = TextEditingController(text: "0.75"); // Found in Table 6.4 for Shop n_e=36, K_v_shop=0.29
  
  Map<String, dynamic>? resultShr;
  Map<String, dynamic>? resultShop;
  
  void _calculate() {
    try {
      double p_shlif = double.parse(ctrl_P_shlif.text.replaceAll(',', '.'));
      double kv_polir = double.parse(ctrl_Kv_polir.text.replaceAll(',', '.'));
      double tg_circ = double.parse(ctrl_tg_circ.text.replaceAll(',', '.'));
      double kp_shr = double.parse(ctrl_Kp_shr.text.replaceAll(',', '.'));
      double kp_shop = double.parse(ctrl_Kp_shop.text.replaceAll(',', '.'));

      // Define standard EP characteristics for ШР1
      final eps_shr1 = [
        EP(4, p_shlif, 0.15, 1.33), // Шліфувальний верстат
        EP(2, 14, 0.12, 1.00),      // Свердлильний верстат
        EP(4, 42, 0.15, 1.33),      // Фугувальний верстат
        EP(1, 36, 0.30, tg_circ),   // Циркулярна пила
        EP(1, 20, 0.50, 0.75),      // Прес
        EP(1, 40, kv_polir, 1.00),  // Полірувальний верстат
        EP(2, 32, 0.20, 1.00),      // Фрезерний верстат
        EP(1, 20, 0.65, 0.75),      // Вентилятор
      ];

      // Krupni EP for the shop
      final krupni = [
        EP(2, 100, 0.20, 3.0), // Зварювальний
        EP(2, 120, 0.80, 0.0), // Сушильна
      ];

      // --------- Calc for ШР1 ---------
      double shr_np = 0;
      double shr_npkv = 0;
      double shr_npkvtg = 0;
      double shr_nP2 = 0;
      for (var ep in eps_shr1) {
        shr_np += ep.np;
        shr_npkv += ep.npkv;
        shr_npkvtg += ep.npkvtg;
        shr_nP2 += ep.nP2;
      }
      
      double shr_kv = shr_npkv / shr_np;
      double shr_ne = pow(shr_np, 2) / shr_nP2;
      
      double shr_Pp = kp_shr * shr_npkv;
      double shr_Qp = (shr_ne <= 10 ? 1.1 : 1.0) * shr_npkvtg; 
      double shr_Sp = sqrt(pow(shr_Pp, 2) + pow(shr_Qp, 2));
      double shr_Ip = shr_Pp / 0.38; // Pedagogical formula from task manual: Ip = Pp / Uh

      // --------- Calc for Shop ---------
      double shop_np = 3 * shr_np;
      double shop_npkv = 3 * shr_npkv;
      double shop_npkvtg = 3 * shr_npkvtg;
      double shop_nP2 = 3 * shr_nP2;
      
      for (var ep in krupni) {
        shop_np += ep.np;
        shop_npkv += ep.npkv;
        shop_npkvtg += ep.npkvtg;
        shop_nP2 += ep.nP2;
      }
      
      double shop_kv = shop_npkv / shop_np;
      double shop_ne = pow(shop_np, 2) / shop_nP2;
      
      double shop_Pp = kp_shop * shop_npkv;
      double shop_Qp = (shop_ne <= 10 ? 1.1 : 1.0) * shop_npkvtg;
      double shop_Sp = sqrt(pow(shop_Pp, 2) + pow(shop_Qp, 2));
      double shop_Ip = shop_Pp / 0.38;

      setState(() {
        resultShr = {
          'kv': shr_kv, 'ne': shr_ne,
          'Pp': shr_Pp, 'Qp': shr_Qp, 'Sp': shr_Sp, 'Ip': shr_Ip,
        };
        resultShop = {
          'kv': shop_kv, 'ne': shop_ne,
          'Pp': shop_Pp, 'Qp': shop_Qp, 'Sp': shop_Sp, 'Ip': shop_Ip,
        };
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Перевірте коректність вводу')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Змінні параметри Варіанту', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: CustomInput(label: 'Рн (Шліфувал.)', controller: ctrl_P_shlif)),
                        const SizedBox(width: 8),
                        Expanded(child: CustomInput(label: 'Кв (Полірувал.)', controller: ctrl_Kv_polir)),
                        const SizedBox(width: 8),
                        Expanded(child: CustomInput(label: 'tg φ (Циркулярка)', controller: ctrl_tg_circ)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Розрахункові коефіцієнти (з таблиць)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: CustomInput(label: 'Kр для ШР1 (з табл. 6.3)', controller: ctrl_Kp_shr)),
                        const SizedBox(width: 8),
                        Expanded(child: CustomInput(label: 'Kр для Цеху (з табл. 6.4)', controller: ctrl_Kp_shop)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: _calculate,
                                child: const Text('РОЗРАХУВАТИ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (resultShr != null && resultShop != null) ...[
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GlassCard(
                        highlight: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ШР1 (Шини 1-3)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            const Divider(color: Color(0xFF334155), height: 24),
                            ResRow(label: 'Груповий К_в:', value: resultShr!['kv'].toStringAsFixed(4)),
                            ResRow(label: 'Ефективна к-ть n_e:', value: resultShr!['ne'].toStringAsFixed(0)),
                            const SizedBox(height: 8),
                            ResRow(label: 'Розрахункове P_p:', value: '${resultShr!['Pp'].toStringAsFixed(2)} кВт'),
                            ResRow(label: 'Розрахункове Q_p:', value: '${resultShr!['Qp'].toStringAsFixed(2)} квар'),
                            ResRow(label: 'Повна потужність S_p:', value: '${resultShr!['Sp'].toStringAsFixed(2)} кВ·А'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                              child: ResRow(label: 'Розрахунковий струм I_p:', value: '${resultShr!['Ip'].toStringAsFixed(2)} А', color: const Color(0xFF10B981)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassCard(
                        highlight: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('В цілому по Цеху', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                            const Divider(color: Color(0xFF334155), height: 24),
                            ResRow(label: 'Цеховий К_в:', value: resultShop!['kv'].toStringAsFixed(4)),
                            ResRow(label: 'Ефективна к-ть n_e:', value: resultShop!['ne'].toStringAsFixed(0)),
                            const SizedBox(height: 8),
                            ResRow(label: 'Розрахункове P_p:', value: '${resultShop!['Pp'].toStringAsFixed(2)} кВт'),
                            ResRow(label: 'Розрахункове Q_p:', value: '${resultShop!['Qp'].toStringAsFixed(2)} квар'),
                            ResRow(label: 'Повна потужність S_p:', value: '${resultShop!['Sp'].toStringAsFixed(2)} кВ·А'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                              child: ResRow(label: 'Цеховий струм I_p:', value: '${resultShop!['Ip'].toStringAsFixed(2)} А', color: const Color(0xFF0EA5E9)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
