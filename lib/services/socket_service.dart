import 'package:socket_io_client/socket_io_client.dart' as IO;
import './location_service.dart';

LocationService locationService = LocationService();

class SocketService {
  IO.Socket socket;

  void createSocketConnection() {
    socket = IO.io('https://tracker1312.herokuapp.com/', <String, dynamic>{
      'transports': ['websocket'],
    });

    // * send location to socket
    this.socket.on("connect", (_) async {
      print('Connected');
      print(await locationService.getLocation());
      var location = await locationService.getLocation();
      for (var item in location) {
        this.socket.emit('location', item);
      }
    });
    this.socket.on("disconnect", (_) => print('Disconnected'));
  }
}
