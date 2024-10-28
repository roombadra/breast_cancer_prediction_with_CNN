import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/prediction_controller.dart';

class PredictionResultScreen extends StatelessWidget {
  const PredictionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PredictionController controller = Get.find();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prediction Result'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Obx(() {
                if (controller.prediction.value == null) {
                  return const Center(child: Text('No prediction available.'));
                }

                final prediction = controller.prediction.value!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your results are ready!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 5,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your results will be available in seconds.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    _buildResultRow('Prediction Result', prediction.prediction),
                    _buildResultRow('Confidence Score',
                        '${(prediction.confidence * 100).toStringAsFixed(2)}%'),
                    _buildResultRow('Confidence Margin',
                        '${(prediction.confidenceMargin * 100).toStringAsFixed(2)}%'),
                    _buildResultRow('Uncertainty',
                        '${(prediction.uncertainty * 100).toStringAsFixed(2)}%'),
                    const SizedBox(height: 20),
                    const Text(
                      'Informations',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 10),
                    _buildInformationDetail(1,
                        'A high confidence score indicates the model is certain about its prediction, but it\'s not a diagnosis.'),
                    const SizedBox(height: 5),
                    _buildInformationDetail(2,
                        'If the prediction indicates a "malignant" result, consult a healthcare professional immediately.'),
                    const SizedBox(height: 5),
                    _buildInformationDetail(3,
                        'A "benign" result doesn\'t guarantee there\'s no risk. Regular check-ups are still important.'),
                    const SizedBox(height: 5),
                    _buildInformationDetail(4,
                        'A "Normal" predictions suggest no detected-normal, but routine screenings are still recommended.'),
                    const SizedBox(height: 5),
                    _buildInformationDetail(5,
                        'The confidence margin reflects the range of the model\'s prediction certainty. A narrow margin indicates high confidence.'),
                    const SizedBox(height: 5),
                    _buildInformationDetail(6,
                        'The uncertainty score helps gauge how much the model is unsure about its prediction. Higher uncertainty means lower reliability.'),
                    const SizedBox(height: 5),
                    _buildInformationDetail(7,
                        'Use the prediction results to have more informed discussions with your healthcare provider.'),
                    const SizedBox(height: 5),
                    _buildInformationDetail(8,
                        'This prediction tool is intended as a supplementary resource, not a substitute for a medical consultation.'),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Text _buildInformationDetail(int number, String detail) {
    return Text(
      '$number, \n$detail',
      style: const TextStyle(fontSize: 12, color: Colors.black),
    );
  }

  Widget _buildResultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
