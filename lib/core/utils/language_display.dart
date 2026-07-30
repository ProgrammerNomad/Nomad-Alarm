/// Locale-independent language names for the settings picker.
/// Always shown in native script so users can recover from accidental switches.
String languageEndonym(String code) {
  return switch (code) {
    'en' => 'English',
    'hi' => 'हिन्दी',
    'ar' => 'العربية',
    'he' => 'עברית',
    _ => code,
  };
}
