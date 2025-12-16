class UserPreferences {
  final String diet;
  final List<String> allergies;
  final List<String> goals;
  final bool darkMode;

  const UserPreferences({
    this.diet = 'Balanced',
    this.allergies = const [],
    this.goals = const ['Healthy eating'],
    this.darkMode = true,
  });

  UserPreferences copyWith({
    String? diet,
    List<String>? allergies,
    List<String>? goals,
    bool? darkMode,
  }) {
    return UserPreferences(
      diet: diet ?? this.diet,
      allergies: allergies ?? this.allergies,
      goals: goals ?? this.goals,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

