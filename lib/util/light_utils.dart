import '../model/room.dart';
import '../model/light.dart';
import 'database_helper.dart';


void generatelightsAndSaveToDb(int roomId) async {
    var db = DatabaseHelper();
    
    Room room = await db.getRoom(roomId);
    print(room.toMap());

    //int noOfLights = room.noOfLights;
    //print(noOfLights);
    for (int i = 0; i < room.noOfLights; i++) {
      Light light = Light(roomId, "Light ${i+ 1}", "false");
      int res = await db.saveLight(light);
      if (res == 0) {
        print("error error...");
      } 
    }
  }