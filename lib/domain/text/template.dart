/// The pet's pronouns, chosen during onboarding.
enum Pronouns {
  she('she', 'her', 'her'),
  he('he', 'him', 'his'),
  they('they', 'them', 'their');

  const Pronouns(this.subject, this.object, this.possessive);

  final String subject;
  final String object;
  final String possessive;

  static Pronouns fromId(String id) => Pronouns.values.asNameMap()[id] ?? Pronouns.they;
}

final _placeholder = RegExp(r'\{([a-zA-Z][a-zA-Z0-9]*)\}');

/// Every placeholder that content strings may use.
const templateVarNames = {
  'userName',
  'petName',
  'they',
  'They',
  'them',
  'their',
  'currency',
  'currencyPlural',
};

/// Replaces `{name}` placeholders with [vars]. Unknown placeholders are left
/// as-is so a typo shows up on screen instead of silently disappearing.
String fillTemplate(String template, Map<String, String> vars) =>
    template.replaceAllMapped(_placeholder, (m) => vars[m[1]!] ?? m[0]!);

/// The standard variables for [fillTemplate].
Map<String, String> templateVars({
  required String userName,
  required String petName,
  required Pronouns pronouns,
  required String currency,
  required String currencyPlural,
}) {
  final name = userName.trim();
  return {
    'userName': name.isEmpty ? 'friend' : name,
    'petName': petName,
    'they': pronouns.subject,
    'They': pronouns.subject[0].toUpperCase() + pronouns.subject.substring(1),
    'them': pronouns.object,
    'their': pronouns.possessive,
    'currency': currency,
    'currencyPlural': currencyPlural,
  };
}

/// Placeholder names in [template] that aren't in [templateVarNames].
Set<String> unknownPlaceholders(String template) => {
      for (final m in _placeholder.allMatches(template))
        if (!templateVarNames.contains(m[1])) m[1]!,
    };
