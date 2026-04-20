import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class CaseSelectionView extends StatelessWidget {
  const CaseSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final isHighContrast = game.isHighContrast;

    return Container(
      decoration: BoxDecoration(
        color: isHighContrast ? Colors.transparent : null,
        gradient: isHighContrast ? null : const RadialGradient(
          colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)], // Soft slate light gradient
          center: Alignment.center,
          radius: 1.5,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.language == 'hindi' 
                  ? 'नमस्ते, ${game.userName ?? "डिटेक्टिव"}!' 
                  : 'Welcome, ${game.userName ?? "Detective"}!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isHighContrast ? Colors.white : const Color(0xFF1E293B), // Dark slate instead of white
                ),
              ),
              const SizedBox(height: 8),
              Text(
                game.language == 'hindi'
                  ? 'अपनी जांच शुरू करने के लिए कोई केस चुनें।'
                  : 'Select a file to begin your investigation.',
                style: TextStyle(
                  fontSize: 16,
                  color: isHighContrast ? Colors.grey[300] : Colors.grey[700], // Darker grey suitable for light mode
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigoAccent.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Card(
                  color: isHighContrast ? Colors.grey[900] : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isHighContrast ? Colors.grey[700]! : Colors.indigoAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.read<GameProvider>().startDartGame();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.indigoAccent.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.sports_score,
                              color: Colors.indigoAccent,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.language == 'hindi' ? 'डार्ट फाइनेंस चैलेंज' : 'Dart Finance Challenge',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isHighContrast ? Colors.white : const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  game.language == 'hindi' ? 'मिनी-गेम खेलें और अपनी वित्तीय साक्षरता का परीक्षण करें।' : 'Play a mini-game to test your financial literacy.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isHighContrast ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.indigoAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: game.availableCases.length,
                  itemBuilder: (context, index) {
                    final caseItem = game.availableCases[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Card(
                        color: isHighContrast ? Colors.grey[900] : Colors.white, // Crisp white card
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isHighContrast ? Colors.grey[700]! : Colors.blueAccent.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            context.read<GameProvider>().startCase(caseItem);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.security,
                                    color: Colors.blueAccent,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        caseItem.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: isHighContrast ? Colors.white : const Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        caseItem.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isHighContrast ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.blueAccent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
