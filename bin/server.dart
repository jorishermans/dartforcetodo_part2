library dart_force_todo;

import "package:force/force_serverside.dart";
import "package:cargo/cargo_server.dart";

void main() {
  
  ForceServer fs = new ForceServer(clientFiles: "../build/web/", startPage: "dartforcetodo_part2.html");
  
  Cargo cargo = new Cargo(MODE: CargoMode.FILE, path: "../store/");
  
  fs.setupConsoleLog();
  
  fs.on("add", (fme, sender) {
    sender.send("update", fme.json);
    
    cargo.add("todos", fme.json);
  });
  
  fs.onSocket.listen((SocketEvent se) {
    cargo.getItem("todos").then((obj) {
      if (obj !=null && obj is List) {
        List list = obj;
        for (var item in list) {
          fs.sendTo(se.wsId, "update", item);
        }
      } 
    });
  });
  
  fs.start();
  
}