import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/app_startup_view.dart';

import 'preview_theme.dart';

@Preview(name: 'Startup / loading', size: Size(360, 640), wrapper: yaabsaPreviewLight)
Widget startupLoadingPreview() => const AppStartupView();

@Preview(name: 'Startup / error / phone', size: Size(360, 640), wrapper: yaabsaPreviewLight)
@Preview(name: 'Startup / error / desktop', size: Size(1000, 700), wrapper: yaabsaPreviewDark)
Widget startupErrorPreview() {
  return const AppStartupView(
    error: 'org.freedesktop.DBus.Error.ServiceUnknown: Unable to register the media player on the session bus.',
  );
}
