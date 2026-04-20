import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/dart_provider.dart';
import '../providers/game_provider.dart';
import 'dart:math';

class DartBoardWidget extends StatefulWidget {
  const DartBoardWidget({super.key});

  @override
  State<DartBoardWidget> createState() => _DartBoardWidgetState();
}

class _DartBoardWidgetState extends State<DartBoardWidget> with SingleTickerProviderStateMixin {
  Offset? _currentDragPos;
  bool _isThrowing = false;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  final List<_ArrowHit> _hitPoints = [];
  Offset _throwVelocity = Offset.zero;
  Offset _finalHitPos = Offset.zero;
  double _finalHitAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInQuad),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _registerHit();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (_isThrowing || context.read<DartGameProvider>().dartsLeft <= 0) return;
    HapticFeedback.selectionClick();
    setState(() {
      _currentDragPos = details.localPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isThrowing || context.read<DartGameProvider>().dartsLeft <= 0) return;
    setState(() {
      _currentDragPos = details.localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details, Offset bowOrigin, double tX, double tY) {
    if (_isThrowing || _currentDragPos == null || context.read<DartGameProvider>().dartsLeft <= 0) return;
    
    // Calculate slingshot vector
    Offset pull = _currentDragPos! - bowOrigin;

    // Must pull down to shoot
    if (pull.dy > 40) {
      HapticFeedback.mediumImpact();
      
      // Slingshot mathematics
      // Ideal pull for bullseye is exactly 130 pixels straight back
      double pullDX = pull.dx;
      double pullDY = pull.dy;

      // Inverse travel
      double hitX = tX - (pullDX * 2.0); 
      // Height calculation (weak pull drops low, strong flies high)
      double hitY = tY + (130 - pullDY) * 3.0; 

      _finalHitPos = Offset(hitX, hitY);
      
      // Arrow flight angle based on trajectory
      _finalHitAngle = atan2(hitY - bowOrigin.dy, hitX - bowOrigin.dx) + (pi / 2);

      setState(() {
        _isThrowing = true;
      });
      _animationController.forward(from: 0.0);
    } else {
      // Cancel Weak Draw
      setState(() {
        _currentDragPos = null;
      });
    }
  }

  void _registerHit() {
    HapticFeedback.heavyImpact();
    
    final size = MediaQuery.of(context).size;
    final tX = size.width / 2;
    final tY = size.height * 0.25;

    final dx = tX - _finalHitPos.dx;
    final dy = tY - _finalHitPos.dy;
    final dist = sqrt(dx * dx + dy * dy);

    int points = 0;
    if (dist < 12) points = 50; 
    else if (dist < 30) points = 25;
    else if (dist < 52) points = 10;
    else if (dist < 75) points = 5;

    setState(() {
      _hitPoints.add(_ArrowHit(_finalHitPos, _finalHitAngle));
      _isThrowing = false;
      _currentDragPos = null;
      _animationController.reset();
    });

    context.read<DartGameProvider>().throwDart(points);
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<DartGameProvider>();
    final isHighContrast = context.select((GameProvider g) => g.isHighContrast);
    final size = MediaQuery.of(context).size;

    final tX = size.width / 2;
    final tY = size.height * 0.25;
    final bowOrigin = Offset(size.width / 2, size.height * 0.65);

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: (d) => _onPanEnd(d, bowOrigin, tX, tY),
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Sky and Grass Background tailored to elevated target
            Positioned.fill(
              child: CustomPaint(
                painter: _LandscapeBackgroundPainter(isHighContrast, tY),
              ),
            ),
            
            // Archery Target centered exactly at the horizon
            Positioned(
              left: tX - 75,
              top: tY - 75,
              child: Container(
                width: 150, 
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isHighContrast ? Colors.grey[800] : Colors.grey[300],
                  boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 15, offset: Offset(0, 5))],
                ),
                child: CustomPaint(
                  painter: _ArcheryTargetPainter(isHighContrast),
                ),
              ),
            ),

            // Lodged Arrows on the target!
            ..._hitPoints.map((hit) => Positioned(
              left: hit.pos.dx - 15,
              top: hit.pos.dy - 15,
              child: Transform.rotate(
                angle: hit.angle,
                child: SizedBox(
                  width: 30, height: 30,
                  child: CustomPaint(painter: _ArrowEmbeddedPainter()),
                ),
              ),
            )),

            // Stats Header
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('SCORE: ${game.score}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
                        Text('LEVEL: ${game.currentLevel}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amberAccent, shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
                      ],
                    ),
                    Row(
                      children: List.generate(3, (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.arrow_upward_rounded, 
                          color: index < game.dartsLeft ? Colors.amberAccent : Colors.grey[700],
                          size: 32,
                          shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),

            // Base Bow
            if (game.dartsLeft > 0 && !_isThrowing)
               Positioned.fill(
                 child: CustomPaint(
                   painter: _BowPainter(bowOrigin, _currentDragPos ?? bowOrigin),
                 )
               ),

            // Arrow animating off string
            if (_isThrowing)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final progress = _animationController.value;
                  
                  final startX = bowOrigin.dx;
                  final startY = bowOrigin.dy;

                  final currentX = startX + (_finalHitPos.dx - startX) * progress;
                  final currentY = startY + (_finalHitPos.dy - startY) * progress;

                  return Positioned(
                    left: currentX - 50, 
                    top: currentY - 50,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _finalHitAngle,
                        child: SizedBox(width: 100, height: 100, child: CustomPaint(painter: _ArrowFlightPainter())),
                      ),
                    ),
                  );
                },
              )
            // Arrow resting on the taut string
            else if (game.dartsLeft > 0 && !_isThrowing && _currentDragPos != null)
              Positioned(
                left: _currentDragPos!.dx - 50,
                top: _currentDragPos!.dy - 50,
                child: SizedBox(
                   width: 100,
                   height: 100,
                   child: Transform.rotate(
                     // Arrow angle tracks toward target
                     angle: atan2(tY - bowOrigin.dy, tX - bowOrigin.dx) + (pi / 2),
                     child: CustomPaint(painter: _ArrowFlightPainter()),
                   )
                ),
              )
             // Idle Arrow resting on Slack Bow
            else if (game.dartsLeft > 0 && !_isThrowing && _currentDragPos == null)
              Positioned(
                left: bowOrigin.dx - 50,
                top: bowOrigin.dy - 50,
                child: SizedBox(
                   width: 100,
                   height: 100,
                   child: CustomPaint(painter: _ArrowFlightPainter()),
                ),
              ),

          ],
        ),
      ),
    );
  }
}

class _ArrowHit {
  final Offset pos;
  final double angle;
  _ArrowHit(this.pos, this.angle);
}

// Painter for an Arrow embedded into the target
class _ArrowEmbeddedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final woodPaint = Paint()..color = const Color(0xFF8D6E63)..style = PaintingStyle.fill;
    final featherPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final shadow = Paint()..color = Colors.black45..style = PaintingStyle.fill;

    // Draw embedded shaft starting from center
    canvas.drawRect(Rect.fromLTWH(size.width / 2 - 1, size.height / 2, 3, 25), shadow);
    canvas.drawRect(Rect.fromLTWH(size.width / 2 - 2, size.height / 2, 4, 25), woodPaint);

    // Draw feathers sticking out
    final f1 = Path()
      ..moveTo(size.width / 2 - 2, size.height / 2 + 15)
      ..lineTo(size.width / 2 - 10, size.height / 2 + 25)
      ..lineTo(size.width / 2 - 2, size.height / 2 + 25)
      ..close();
    final f2 = Path()
      ..moveTo(size.width / 2 + 2, size.height / 2 + 15)
      ..lineTo(size.width / 2 + 10, size.height / 2 + 25)
      ..lineTo(size.width / 2 + 2, size.height / 2 + 25)
      ..close();
    
    canvas.drawPath(f1, featherPaint);
    canvas.drawPath(f2, featherPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Graphical Painter for an active flying/drawing Arrow
class _ArrowFlightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final woodPaint = Paint()..color = const Color(0xFF6D4C41)..style = PaintingStyle.fill;
    final tipPaint = Paint()..color = const Color(0xFF90A4AE)..style = PaintingStyle.fill;
    final featherPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    
    // Shaft 
    canvas.drawRect(Rect.fromLTWH(size.width / 2 - 2, 10, 4, 80), woodPaint);
    
    // Broadhead Tip
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2 + 6, 12)
      ..lineTo(size.width / 2 - 6, 12)
      ..close();
    canvas.drawPath(path, tipPaint);
    
    // Fletching Feathers
    final finL = Path()
      ..moveTo(size.width / 2, 70)
      ..lineTo(size.width / 2 - 12, 85)
      ..lineTo(size.width / 2 - 12, 95)
      ..lineTo(size.width / 2, 90)
      ..close();
    final finR = Path()
      ..moveTo(size.width / 2, 70)
      ..lineTo(size.width / 2 + 12, 85)
      ..lineTo(size.width / 2 + 12, 95)
      ..lineTo(size.width / 2, 90)
      ..close();
      
    canvas.drawPath(finL, featherPaint);
    canvas.drawPath(finR, featherPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Draws the Bow Arc and the Elastic String pulled to the finger
class _BowPainter extends CustomPainter {
  final Offset bowOrigin; // Fixed center top part of the grip
  final Offset pullOrigin; // Where the string is pulled to

  _BowPainter(this.bowOrigin, this.pullOrigin);

  @override
  void paint(Canvas canvas, Size size) {
    final bowPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final stringPaint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Bow Arc (Curve facing target)
    Path bowArc = Path();
    double arcWidth = 160.0;
    double arcDrop = 40.0;
    
    // Curve ends
    Offset leftTip = Offset(bowOrigin.dx - arcWidth/2, bowOrigin.dy + arcDrop);
    Offset rightTip = Offset(bowOrigin.dx + arcWidth/2, bowOrigin.dy + arcDrop);
    
    // Curving UP
    bowArc.moveTo(leftTip.dx, leftTip.dy);
    bowArc.quadraticBezierTo(bowOrigin.dx, bowOrigin.dy - 30, rightTip.dx, rightTip.dy);
    
    // Tense String V-Shape
    Path stringPath = Path();
    stringPath.moveTo(leftTip.dx, leftTip.dy);
    stringPath.lineTo(pullOrigin.dx, pullOrigin.dy);
    stringPath.lineTo(rightTip.dx, rightTip.dy);

    canvas.drawPath(bowArc, bowPaint);
    canvas.drawPath(stringPath, stringPaint);
  }

  @override
  bool shouldRepaint(covariant _BowPainter oldDelegate) {
    return oldDelegate.pullOrigin != pullOrigin;
  }
}

class _LandscapeBackgroundPainter extends CustomPainter {
  final bool isHighContrast;
  final double horizonY;
  _LandscapeBackgroundPainter(this.isHighContrast, this.horizonY);

  @override
  void paint(Canvas canvas, Size size) {
    if (isHighContrast) {
      canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height), Paint()..color = Colors.black);
      return;
    }
    
    // Sky down to horizon
    final skyRect = Rect.fromLTWH(0, 0, size.width, horizonY + 30);
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF87CEEB), Color(0xFFE0F6FF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    // Deep Green Field below horizon
    final grassRect = Rect.fromLTWH(0, horizonY, size.width, size.height - horizonY);
    final grassPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(grassRect);
    
    final path = Path()
      ..moveTo(0, horizonY + 20)
      ..quadraticBezierTo(size.width / 2, horizonY - 10, size.width, horizonY + 20)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, grassPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArcheryTargetPainter extends CustomPainter {
  final bool isHighContrast;
  _ArcheryTargetPainter(this.isHighContrast);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Standard Archery Colors
    paint.color = isHighContrast ? Colors.white : Colors.white;
    canvas.drawCircle(center, size.width * 0.5, paint); 
    
    paint.color = isHighContrast ? Colors.black : Colors.black87;
    canvas.drawCircle(center, size.width * 0.40, paint); 
    
    paint.color = const Color(0xFF2196F3); // Blue Ring
    canvas.drawCircle(center, size.width * 0.28, paint); 
    
    paint.color = const Color(0xFFEF4444); // Red Ring
    canvas.drawCircle(center, size.width * 0.16, paint); 
    
    paint.color = const Color(0xFFFFEB3B); // Yellow Bullseye
    canvas.drawCircle(center, size.width * 0.06, paint); 
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
