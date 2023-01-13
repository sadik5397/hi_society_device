String baseUrl = "http://192.168.68.125:3000"; //Localhost
// String baseUrl = "https://g01.fusionbdtech.com"; //TestServer
// String baseUrl = "http://ncbapi.smicee.com"; //LiveServer
// String baseUrl = "http://10.0.2.2:3000"; //LocalhostAndroidEmulator
Map<String, String> primaryHeader = {"Content-Type": "application/json", "charset": "utf-8"};

Map<String, String> authHeader(String accessToken) {
  return {"Content-Type": "application/json", "Authorization": "Bearer $accessToken", "charset": "utf-8"};
}
