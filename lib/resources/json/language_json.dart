const String languageJsonString = '''
[
  {
    "code": "af-ZA",
    "language": "Afrikaans (South Africa)",
    "support": ["Plain text"]
  },
  {
    "code": "sq-AL",
    "language": "Albanian (Albania)",
    "support": ["Plain text"]
  },
  {
    "code": "am-ET",
    "language": "Amharic (Ethiopia)",
    "support": ["Plain text"]
  },
  {
    "code": "ar-DZ",
    "language": "Arabic (Algeria)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-BH",
    "language": "Arabic (Bahrain)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-EG",
    "language": "Arabic (Egypt)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text"]
  },
  {
    "code": "ar-IQ",
    "language": "Arabic (Iraq)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-IL",
    "language": "Arabic (Israel)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-JO",
    "language": "Arabic (Jordan)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-KW",
    "language": "Arabic (Kuwait)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-LB",
    "language": "Arabic (Lebanon)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-LY",
    "language": "Arabic (Libya)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-MA",
    "language": "Arabic (Morocco)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-OM",
    "language": "Arabic (Oman)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-PS",
    "language": "Arabic (Palestinian Authority)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-QA",
    "language": "Arabic (Qatar)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-SA",
    "language": "Arabic (Saudi Arabia)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Phrase list"]
  },
  {
    "code": "ar-SY",
    "language": "Arabic (Syria)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-TN",
    "language": "Arabic (Tunisia)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-AE",
    "language": "Arabic (United Arab Emirates)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ar-YE",
    "language": "Arabic (Yemen)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "hy-AM",
    "language": "Armenian (Armenia)",
    "support": ["Plain text"]
  },
  {
    "code": "as-IN",
    "language": "Assamese (India)",
    "support": ["Audio + human-labeled transcript"]
  },
  {
    "code": "az-AZ",
    "language": "Azerbaijani (Latin, Azerbaijan)",
    "support": ["Plain text"]
  },
  {
    "code": "bn-IN",
    "language": "Bengali (India)",
    "support": ["Plain text"]
  },
  {
    "code": "bs-BA",
    "language": "Bosnian (Bosnia and Herzegovina)",
    "support": ["Plain text"]
  },
  {
    "code": "bg-BG",
    "language": "Bulgarian (Bulgaria)",
    "support": ["Plain text"]
  },
  {
    "code": "my-MM",
    "language": "Burmese (Myanmar)",
    "support": ["Plain text"]
  },
  {
    "code": "ca-ES",
    "language": "Catalan",
    "support": ["Plain text", "Pronunciation"]
  },
  {
    "code": "zh-HK",
    "language": "Chinese (Cantonese, Traditional, Hong Kong)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "zh-CN",
    "language": "Chinese (Mandarin, Simplified, China)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "zh-TW",
    "language": "Chinese (Mandarin, Traditional, Taiwan)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "hr-HR",
    "language": "Croatian (Croatia)",
    "support": ["Plain text"]
  },
  {
    "code": "cs-CZ",
    "language": "Czech (Czechia)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "da-DK",
    "language": "Danish (Denmark)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "nl-BE",
    "language": "Dutch (Belgium)",
    "support": ["Plain text"]
  },
  {
    "code": "nl-NL",
    "language": "Dutch (Netherlands)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "en-AU",
    "language": "English (Australia)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "en-CA",
    "language": "English (Canada)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "en-GH",
    "language": "English (Ghana)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "en-HK",
    "language": "English (Hong Kong SAR)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "en-IN",
    "language": "English (India)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "en-IE",
    "language": "English (Ireland)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "en-KE",
    "language": "English (Kenya)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "en-NZ",
    "language": "English (New Zealand)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "en-NG",
    "language": "English (Nigeria)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "en-PH",
    "language": "English (Philippines)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "en-SG",
    "language": "English (Singapore)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "en-ZA",
    "language": "English (South Africa)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Pronunciation", "Phrase list"]
  },
  {
    "code": "en-TZ",
    "language": "English (Tanzania)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "en-GB",
    "language": "English (United Kingdom)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "en-US",
    "language": "English (United States)",
    "support": ["Audio + human-labeled transcript", "Audio", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "et-EE",
    "language": "Estonian (Estonia)",
    "support": ["Plain text"]
  },
  {
    "code": "fil-PH",
    "language": "Filipino (Philippines)",
    "support": ["Plain text"]
  },
  {
    "code": "fi-FI",
    "language": "Finnish (Finland)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "fr-BE",
    "language": "French (Belgium)",
    "support": ["Plain text", "Pronunciation", "Phrase list"]
  },
  {
    "code": "fr-CA",
    "language": "French (Canada)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Pronunciation"]
  },
  {
    "code": "fr-FR",
    "language": "French (France)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "fr-CH",
    "language": "French (Switzerland)",
    "support": ["Plain text"]
  },
  {
    "code": "gl-ES",
    "language": "Galician (Spain)",
    "support": ["Plain text"]
  },
  {
    "code": "ka-GE",
    "language": "Georgian (Georgia)",
    "support": ["Plain text"]
  },
  {
    "code": "de-AT",
    "language": "German (Austria)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "de-DE",
    "language": "German (Germany)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "de-CH",
    "language": "German (Switzerland)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Pronunciation", "Phrase list"]
  },
  {
    "code": "el-GR",
    "language": "Greek (Greece)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text"]
  },
  {
    "code": "gu-IN",
    "language": "Gujarati (India)",
    "support": ["Plain text"]
  },
  {
    "code": "he-IL",
    "language": "Hebrew (Israel)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Pronunciation", "Phrase list"]
  },
  {
    "code": "hi-IN",
    "language": "Hindi (India)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "hu-HU",
    "language": "Hungarian (Hungary)",
    "support": ["Plain text"]
  },
  {
    "code": "is-IS",
    "language": "Icelandic (Iceland)",
    "support": ["Plain text"]
  },
  {
    "code": "id-ID",
    "language": "Indonesian (Indonesia)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "ga-IE",
    "language": "Irish (Ireland)",
    "support": ["Plain text"]
  },
  {
    "code": "it-IT",
    "language": "Italian (Italy)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "it-CH",
    "language": "Italian (Switzerland)",
    "support": ["Plain text"]
  },
  {
    "code": "ja-JP",
    "language": "Japanese (Japan)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "jv-ID",
    "language": "Javanese (Indonesia)",
    "support": ["Plain text"]
  },
  {
    "code": "kn-IN",
    "language": "Kannada (India)",
    "support": ["Plain text"]
  },
  {
    "code": "kk-KZ",
    "language": "Kazakh (Kazakhstan)",
    "support": ["Plain text"]
  },
  {
    "code": "km-KH",
    "language": "Khmer (Cambodia)",
    "support": ["Plain text"]
  },
  {
    "code": "ko-KR",
    "language": "Korean (Korea)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "lo-LA",
    "language": "Lao (Laos)",
    "support": ["Plain text"]
  },
  {
    "code": "lv-LV",
    "language": "Latvian (Latvia)",
    "support": ["Plain text"]
  },
  {
    "code": "lt-LT",
    "language": "Lithuanian (Lithuania)",
    "support": ["Plain text"]
  },
  {
    "code": "mk-MK",
    "language": "Macedonian (North Macedonia)",
    "support": ["Plain text"]
  },
  {
    "code": "ms-MY",
    "language": "Malay (Malaysia)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Pronunciation"]
  },
  {
    "code": "ml-IN",
    "language": "Malayalam (India)",
    "support": ["Plain text"]
  },
  {
    "code": "mt-MT",
    "language": "Maltese (Malta)",
    "support": ["Plain text"]
  },
  {
    "code": "mr-IN",
    "language": "Marathi (India)",
    "support": ["Plain text"]
  },
  {
    "code": "mn-MN",
    "language": "Mongolian (Mongolia)",
    "support": ["Plain text"]
  },
  {
    "code": "ne-NP",
    "language": "Nepali (Nepal)",
    "support": ["Plain text"]
  },
  {
    "code": "no-NO",
    "language": "Norwegian (Norway)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Pronunciation", "Phrase list"]
  },
  {
    "code": "or-IN",
    "language": "Odia (India)",
    "support": ["Plain text"]
  },
  {
    "code": "ps-AF",
    "language": "Pashto (Afghanistan)",
    "support": ["Plain text"]
  },
  {
    "code": "fa-IR",
    "language": "Persian (Iran)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "pl-PL",
    "language": "Polish (Poland)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "pt-BR",
    "language": "Portuguese (Brazil)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "pt-PT",
    "language": "Portuguese (Portugal)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "pa-IN",
    "language": "Punjabi (India)",
    "support": ["Plain text"]
  },
  {
    "code": "qu-PE",
    "language": "Quechua (Peru)",
    "support": ["Plain text"]
  },
  {
    "code": "ro-RO",
    "language": "Romanian (Romania)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "ru-RU",
    "language": "Russian (Russia)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "sr-RS",
    "language": "Serbian (Serbia)",
    "support": ["Plain text"]
  },
  {
    "code": "sd-IN",
    "language": "Sindhi (India)",
    "support": ["Plain text"]
  },
  {
    "code": "si-LK",
    "language": "Sinhala (Sri Lanka)",
    "support": ["Plain text"]
  },
  {
    "code": "sk-SK",
    "language": "Slovak (Slovakia)",
    "support": ["Plain text"]
  },
  {
    "code": "sl-SI",
    "language": "Slovenian (Slovenia)",
    "support": ["Plain text"]
  },
  {
    "code": "so-SO",
    "language": "Somali (Somalia)",
    "support": ["Plain text"]
  },
  {
    "code": "es-AR",
    "language": "Spanish (Argentina)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-BO",
    "language": "Spanish (Bolivia)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-CL",
    "language": "Spanish (Chile)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-CO",
    "language": "Spanish (Colombia)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-CR",
    "language": "Spanish (Costa Rica)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-CU",
    "language": "Spanish (Cuba)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-DO",
    "language": "Spanish (Dominican Republic)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-EC",
    "language": "Spanish (Ecuador)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-SV",
    "language": "Spanish (El Salvador)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-GQ",
    "language": "Spanish (Equatorial Guinea)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-GT",
    "language": "Spanish (Guatemala)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-HN",
    "language": "Spanish (Honduras)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-MX",
    "language": "Spanish (Mexico)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "es-NI",
    "language": "Spanish (Nicaragua)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-PA",
    "language": "Spanish (Panama)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-PY",
    "language": "Spanish (Paraguay)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-PE",
    "language": "Spanish (Peru)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-PR",
    "language": "Spanish (Puerto Rico)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-ES",
    "language": "Spanish (Spain)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "es-US",
    "language": "Spanish (United States)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "es-UY",
    "language": "Spanish (Uruguay)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "es-VE",
    "language": "Spanish (Venezuela)",
    "support": ["Plain text", "Structured text", "Pronunciation"]
  },
  {
    "code": "su-ID",
    "language": "Sundanese (Indonesia)",
    "support": ["Plain text"]
  },
  {
    "code": "sw-KE",
    "language": "Swahili (Kenya)",
    "support": ["Plain text"]
  },
  {
    "code": "sw-TZ",
    "language": "Swahili (Tanzania)",
    "support": ["Plain text"]
  },
  {
    "code": "sv-SE",
    "language": "Swedish (Sweden)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Pronunciation", "Phrase list"]
  },
  {
    "code": "ta-IN",
    "language": "Tamil (India)",
    "support": ["Audio + human-labeled transcript", "Plain text"]
  },
  {
    "code": "ta-MY",
    "language": "Tamil (Malaysia)",
    "support": ["Plain text"]
  },
  {
    "code": "ta-SG",
    "language": "Tamil (Singapore)",
    "support": ["Plain text"]
  },
  {
    "code": "ta-LK",
    "language": "Tamil (Sri Lanka)",
    "support": ["Plain text"]
  },
  {
    "code": "te-IN",
    "language": "Telugu (India)",
    "support": ["Plain text"]
  },
  {
    "code": "th-TH",
    "language": "Thai (Thailand)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "tr-TR",
    "language": "Turkish (Turkey)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation", "Phrase list"]
  },
  {
    "code": "uk-UA",
    "language": "Ukrainian (Ukraine)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "ur-IN",
    "language": "Urdu (India)",
    "support": ["Plain text"]
  },
  {
    "code": "ur-PK",
    "language": "Urdu (Pakistan)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Pronunciation", "Phrase list"]
  },
  {
    "code": "uz-UZ",
    "language": "Uzbek (Uzbekistan)",
    "support": ["Plain text"]
  },
  {
    "code": "vi-VN",
    "language": "Vietnamese (Vietnam)",
    "support": ["Audio + human-labeled transcript", "Plain text", "Structured text", "Output format", "Pronunciation"]
  },
  {
    "code": "cy-GB",
    "language": "Welsh (United Kingdom)",
    "support": ["Plain text"]
  },
  {
    "code": "yi-DE",
    "language": "Yiddish (Germany)",
    "support": ["Plain text"]
  },
  {
    "code": "yo-NG",
    "language": "Yoruba (Nigeria)",
    "support": ["Plain text"]
  }
]
''';