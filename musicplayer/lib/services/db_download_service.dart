import 'package:musicplayer/model/MusicListModel.dart';
import 'package:musicplayer/utils/web_service.dart';

class DBDownloadService {
  static Future<MusicListModel> fetchAllRadios(String url) async {
    try {
      final serviceResponse = await WebService().getData(url);
      return serviceResponse;
    } on Exception catch (exception) {
    } catch (error) {
    }
  }
}
