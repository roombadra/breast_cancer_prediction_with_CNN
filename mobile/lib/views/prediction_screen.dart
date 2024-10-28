import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../components/bottom_nav_bar.dart';
import '../controllers/prediction_controller.dart';
import 'prediction_result_screen.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final PredictionController _controller = Get.put(PredictionController());
  XFile? _imageFile;
  bool _isLoading = false; // Ajout d'un état de chargement

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _startPrediction() async {
    if (_imageFile == null) return;

    setState(() {
      _isLoading = true; // Début du chargement
    });

    await _controller.fetchPrediction(_imageFile!.path);

    // Vérification si le widget est toujours monté avant d'utiliser context
    if (!mounted) return;

    setState(() {
      _isLoading = false; // Fin du chargement
    });

    if (_controller.prediction.value != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PredictionResultScreen(),
        ),
      );
    }
  }

  void _reset() {
    setState(() {
      _imageFile = null; // Réinitialiser l'image sélectionnée
      _controller.prediction.value = null; // Réinitialiser la prédiction
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Make a prediction'),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Upload a mammogram for prediction',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Use images of your breast X-ray. The images should be in JPEG, JPG or PNG format.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Affichage de l'image sélectionnée
              if (_imageFile != null)
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: FileImage(File(_imageFile!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                // Image de placeholder si aucune image n'est sélectionnée
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Bouton pour choisir une image
              if (_imageFile ==
                  null) // Afficher le bouton seulement si aucune image n'est sélectionnée
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Choose from gallery',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              else ...[
                // Ligne avec les boutons Start Prediction et Reset
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _startPrediction, // Désactiver le bouton pendant le chargement
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors
                                  .white) // Afficher un indicateur de chargement
                          : const Text(
                              'Start Prediction',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                    ElevatedButton(
                      onPressed:
                          _reset, // Appeler la méthode de réinitialisation
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .grey, // Couleur du bouton de réinitialisation
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
