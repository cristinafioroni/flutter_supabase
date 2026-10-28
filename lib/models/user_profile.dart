class UserProfile {
  final String id;
  final String name;
  final String? avatarUrl;
  final DateTime birthDate;

  UserProfile({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.birthDate,
  });

  // metodo getter che calcola l'età attuale in base alla data di nascita e la data di oggi
  int get age {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    //verifica se il compleanno è già passato
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      avatarUrl: map['avatarUrl'],
      birthDate: DateTime.parse(map['birthDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,

      //inserire la data di nascita in formato ISO con il quale viene salvata nel database
      'birthDate': birthDate.toIso8601String(),
    };
  }
}