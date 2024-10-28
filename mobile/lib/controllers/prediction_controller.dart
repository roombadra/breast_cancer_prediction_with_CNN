import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';

class PredictionController extends GetxController {
  var isLoading = false.obs;
  var prediction = Rxn<PredictionModel>();

  Future<void> fetchPrediction(String filePath) async {
    isLoading(true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://breast-cancer-prediction-ycpt.onrender.com/predict/'), // Ajout du slash final
      );
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        prediction.value = PredictionModel.fromJson(data);
      } else {
        Get.snackbar(
          "Error",
          "Failed to get prediction: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Exception occurred: $e");
    } finally {
      isLoading(false);
    }
  }
}
