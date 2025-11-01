class ApiConfig {
  static const String baseUrl = "http://10.98.18.36:8080";

  // Auth
  static Uri loginUrl() => Uri.parse("$baseUrl/auth/login.php");
  static Uri registerUrl() => Uri.parse("$baseUrl/auth/register.php");

  // Pegawai
  static Uri listPegawaiUrl() => Uri.parse("$baseUrl/pegawai/list.php");
  static Uri createPegawaiUrl() => Uri.parse("$baseUrl/pegawai/add.php");
  static Uri updatePegawaiUrl() => Uri.parse("$baseUrl/pegawai/edit.php");
  static Uri deletePegawaiUrl() => Uri.parse("$baseUrl/pegawai/delete.php");
}
