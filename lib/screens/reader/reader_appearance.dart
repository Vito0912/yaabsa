part of 'reader.dart';

extension _ReaderAppearance on _ReaderState {
  String get _currentEpubStyles {
    final themeBg = switch (_readerTheme) {
      'light' => '#fffefa',
      'sepia' => '#f4ecd8',
      'dark' => '#121212',
      'grey' => '#2e2e2e',
      _ => '#f4ecd8',
    };
    final themeColor = switch (_readerTheme) {
      'light' => '#000000',
      'sepia' => '#5b4636',
      'dark' => '#e0e0e0',
      'grey' => '#ffffff',
      _ => '#5b4636',
    };

    final settings = ref.read(settingsManagerProvider.notifier);
    final font = switch (settings.getGlobalSetting<String>(SettingKeys.readerFontFamily)) {
      'serif' => 'Georgia, "Times New Roman", serif',
      'sans' => 'Arial, Helvetica, sans-serif',
      _ => null,
    };
    final alignment = settings.getGlobalSetting<String>(SettingKeys.readerTextAlignment);
    final letterSpacing = settings.getGlobalSetting<double>(SettingKeys.readerLetterSpacing);

    return '''
      :root {
        --bg-color: $themeBg;
        --color: $themeColor;
      }
      body {
        background-color: $themeBg !important;
        color: $themeColor !important;
        font-size: ${(_fontSizeMultiplier * 100).toInt()}% !important;
        line-height: $_lineHeight !important;
        overflow-wrap: break-word;
        ${font != null ? 'font-family: $font !important;' : ''}
        ${alignment != 'publisher' ? 'text-align: $alignment !important;' : ''}
        ${letterSpacing > 0 ? 'letter-spacing: ${letterSpacing}em !important;' : ''}
      }
      p, li, blockquote, dd, dt {
        line-height: $_lineHeight !important;
        ${font != null ? 'font-family: $font !important;' : ''}
        ${alignment != 'publisher' ? 'text-align: $alignment !important;' : ''}
      }
      img, svg, video { max-width: 100%; object-fit: contain; }
      p { orphans: 2; widows: 2; }
      ::selection { background: #d6bf80; color: #241c13; }
      a { text-decoration: underline; }
      p, span, div, h1, h2, h3, h4, h5, h6, a {
        color: $themeColor !important;
      }
    ''';
  }
}
