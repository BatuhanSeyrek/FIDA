import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class FinanceGameScreen extends StatefulWidget {
  const FinanceGameScreen({super.key});

  @override
  State<FinanceGameScreen> createState() => _FinanceGameScreenState();
}

class _FinanceGameScreenState extends State<FinanceGameScreen>
    with TickerProviderStateMixin {
  int lane = 1;
  double score = 0;
  double health = 100;
  bool isPlaying = false;
  bool isShowingFeedback = false;
  int currentQuestionIndex = 0;
  double questionY = -0.2;
  Timer? gameTimer;

  // HIZ AYARI: 0.004 değeri akışı oldukça yavaş ve sakin tutar.
  double speed = 0.004;

  static const colorDarkBlue = Color(0xFF0D1026);
  static const colorBordo = Color(0xFF9c1132);
  static const colorNavy = Color(0xFF1b2255);

  final List<Map<String, dynamic>> financialQuestions = [
    {
      "term": "DOLAR",
      "desc": "Amerika Birleşik Devletleri'nin (ABD) resmi para birimidir.",
      "options": ["İngiltere", "ABD", "Almanya"],
      "correct": 1,
    },
    {
      "term": "EURO",
      "desc":
          "Avrupa Birliği ülkelerinin çoğunluğu tarafından kullanılan ortak paradır.",
      "options": ["Avrupa Birliği", "Rusya", "Çin"],
      "correct": 0,
    },
    {
      "term": "ENFLASYON",
      "desc": "Fiyatlar genel düzeyinin sürekli ve hissedilir artışıdır.",
      "options": ["Fiyat artışı", "Birikim", "Döviz düşüşü"],
      "correct": 0,
    },
    {
      "term": "LİKİDİTE",
      "desc":
          "Bir varlığın değer kaybı yaşamadan nakit paraya dönüşme hızıdır.",
      "options": ["Borç", "Nakit Dönüşümü", "Kredi"],
      "correct": 1,
    },
    {
      "term": "YEN",
      "desc": "Japonya'nın resmi para birimidir.",
      "options": ["Çin", "Japonya", "Kore"],
      "correct": 1,
    },
    {
      "term": "PORTFÖY",
      "desc": "Bir yatırımcının sahip olduğu yatırım araçlarının toplamıdır.",
      "options": ["Cüzdan", "Banka", "Yatırım Sepeti"],
      "correct": 2,
    },
    {
      "term": "POUND",
      "desc": "Birleşik Krallık'ın (İngiltere) kullandığı para birimidir.",
      "options": ["İngiltere", "ABD", "Kanada"],
      "correct": 0,
    },
    {
      "term": "KRİPTO PARA",
      "desc":
          "Dijital ortamda üretilen, şifreli ve merkeziyetsiz varlıklardır.",
      "options": ["Kağıt para", "Dijital varlık", "Altın"],
      "correct": 1,
    },
    {
      "term": "RESESYON",
      "desc":
          "Ekonomik faaliyetlerin üst üste iki çeyrek daralması, durgunluktur.",
      "options": ["Durgunluk", "Büyüme", "İhracat"],
      "correct": 0,
    },
    {
      "term": "TEMETTÜ",
      "desc": "Şirketlerin elde ettiği kârı hissedarlarına dağıtmasıdır.",
      "options": ["Kâr Payı", "Faiz", "Vergi"],
      "correct": 0,
    },
    {
      "term": "ASGARİ ÜCRET",
      "desc": "Bir işçiye yasal olarak ödenebilecek en düşük ücrettir.",
      "options": ["En yüksek", "Ortalama", "En düşük"],
      "correct": 2,
    },
    {
      "term": "CARİ AÇIK",
      "desc": "Bir ülkenin ithalatının ihracatından fazla olması durumudur.",
      "options": ["Bütçe fazlası", "Dış ticaret açığı", "Kâr"],
      "correct": 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    financialQuestions.shuffle();
  }

  void _startGame() {
    setState(() {
      isPlaying = true;
      isShowingFeedback = false;
      score = 0;
      health = 100;
      financialQuestions.shuffle();
      currentQuestionIndex = 0;
      questionY = -0.2;
      speed = 0.004;
    });
    _startTimer();
  }

  void _startTimer() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _updateGame();
    });
  }

  void _updateGame() {
    if (isShowingFeedback) return;

    setState(() {
      questionY += speed;
      if (questionY > 0.78 && questionY < 0.82) {
        if (lane == financialQuestions[currentQuestionIndex]['correct']) {
          score += 20;
          _nextQuestion();
        } else {
          _handleWrongAnswer();
        }
      }
      if (health <= 0) {
        gameTimer?.cancel();
        isPlaying = false;
      }
    });
  }

  void _handleWrongAnswer() {
    gameTimer?.cancel();
    setState(() {
      health -= 25;
      isShowingFeedback = true;
    });
  }

  void _continueGame() {
    setState(() {
      isShowingFeedback = false;
      _nextQuestion();
    });
    _startTimer();
  }

  void _nextQuestion() {
    questionY = -0.2;
    currentQuestionIndex =
        (currentQuestionIndex + 1) % financialQuestions.length;
    // Hız artışı çok daha minimal hale getirildi
    if (score > 200) speed = 0.0045;
    if (score > 500) speed = 0.005;
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorDarkBlue,
      body: Stack(
        children: [
          _buildRoads(),
          _buildQuestionTerm(),
          _buildOptionsOnRoad(),
          _buildPlayer(),
          _buildHUD(),
          _buildNavButtons(),
          if (isShowingFeedback) _buildFeedbackOverlay(),
          if (!isPlaying && !isShowingFeedback) _buildStartOverlay(),
        ],
      ),
    );
  }

  // --- SİLİK KONTROL BUTONLARI ---
  Widget _buildNavButtons() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _controlButton(Icons.arrow_back_ios_new_rounded, () {
              if (lane > 0) setState(() => lane--);
            }),
            _controlButton(Icons.arrow_forward_ios_rounded, () {
              if (lane < 2) setState(() => lane++);
            }),
          ],
        ),
      ),
    );
  }

  Widget _controlButton(IconData icon, VoidCallback action) {
    return GestureDetector(
      onTapDown: (_) => (isShowingFeedback || !isPlaying) ? null : action(),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          // Opacity 0.15 yapılarak butonlar daha silik hale getirildi
          color: colorBordo.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: colorBordo.withOpacity(0.3), width: 1.5),
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.4), size: 28),
      ),
    );
  }

  Widget _buildRoads() {
    return Row(
      children: List.generate(
        3,
        (i) => Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
              color:
                  lane == i
                      ? Colors.white.withOpacity(0.02)
                      : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      alignment: Alignment(lane == 0 ? -0.7 : (lane == 1 ? 0 : 0.7), 0.85),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: colorBordo.withOpacity(0.3), blurRadius: 15),
          ],
        ),
        child: const Icon(
          Icons.rocket_launch_rounded,
          color: colorBordo,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildQuestionTerm() {
    return Align(
      alignment: const Alignment(0, -0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "HEDEF TERİM",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            financialQuestions[currentQuestionIndex]['term'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsOnRoad() {
    var options = financialQuestions[currentQuestionIndex]['options'];
    return Stack(
      children: List.generate(
        3,
        (i) => AnimatedAlign(
          duration: const Duration(milliseconds: 16),
          alignment: Alignment(
            i == 0 ? -0.85 : (i == 1 ? 0 : 0.85),
            questionY * 2 - 1,
          ),
          child: Container(
            width: 105,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorNavy,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Text(
              options[i],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHUD() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "SKOR: ${score.toInt()}",
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            _healthBar(),
          ],
        ),
      ),
    );
  }

  Widget _healthBar() {
    return Container(
      width: 100,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (health / 100).clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(
            color: colorBordo,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackOverlay() {
    var q = financialQuestions[currentQuestionIndex];
    return Container(
      color: Colors.black.withOpacity(0.95),
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: Colors.amber,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              q['term'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              q['desc'],
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _continueGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorBordo,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: const Text(
                "ANLADIM, DEVAM ET",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartOverlay() {
    return Container(
      width: double.infinity,
      color: colorDarkBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.rocket_launch, color: colorBordo, size: 80),
          const SizedBox(height: 20),
          const Text(
            "FİDA RUNNER",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: _startGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorBordo,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            child: const Text(
              "BAŞLA",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
