class User {
  final String id;            // generado por Firebase (UID)
  final String nombre;
  final String apellido;
  final String? cuit;
  final String userName;
  final String password;

  // ⚠️ La password no va acá, se maneja en Firebase Auth.
  // En tu modelo de dominio solo guardás datos de perfil.
  User({
    required this.id,
    required this.nombre,
    required this.apellido,
    this.cuit,
    required this.userName,
    required this.password,
  });
}