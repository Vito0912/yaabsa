#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#include <gio/gio.h>
#include <glib.h>

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

static void first_frame_cb(MyApplication* self, FlView* view) {
  gtk_widget_show(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

static void apply_system_color_scheme() {
  g_autoptr(GError) error = nullptr;
  g_autoptr(GDBusConnection) connection =
      g_bus_get_sync(G_BUS_TYPE_SESSION, nullptr, &error);

  if (connection == nullptr) {
    g_warning("Failed to connect to session D-Bus: %s",
              error != nullptr ? error->message : "unknown error");
    return;
  }

  g_autoptr(GVariant) result = g_dbus_connection_call_sync(
      connection, "org.freedesktop.portal.Desktop",
      "/org/freedesktop/portal/desktop", "org.freedesktop.portal.Settings",
      "ReadOne",
      g_variant_new("(ss)", "org.freedesktop.appearance", "color-scheme"),
      G_VARIANT_TYPE("(v)"), G_DBUS_CALL_FLAGS_NONE, 500, nullptr, &error);

  if (result == nullptr) {
    g_warning("Failed to read desktop color scheme: %s",
              error != nullptr ? error->message : "unknown error");
    return;
  }

  g_autoptr(GVariant) boxed = nullptr;
  g_variant_get(result, "(@v)", &boxed);
  g_autoptr(GVariant) value = g_variant_get_variant(boxed);

  if (!g_variant_is_of_type(value, G_VARIANT_TYPE_UINT32)) {
    return;
  }

  const guint32 color_scheme = g_variant_get_uint32(value);
  GtkSettings* settings = gtk_settings_get_default();
  if (settings == nullptr) {
    return;
  }

  switch (color_scheme) {
    case 1:
      g_object_set(settings, "gtk-application-prefer-dark-theme", TRUE,
                   nullptr);
      break;
    case 2:
      g_object_set(settings, "gtk-application-prefer-dark-theme", FALSE,
                   nullptr);
      break;
    default:
      break;
  }
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);

  apply_system_color_scheme();

  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  gtk_window_set_title(window, "yaabsa");
  gtk_window_set_default_size(window, 1280, 720);

  g_autoptr(FlDartProject) project = fl_dart_project_new();

  g_autofree gchar* executable_path = g_file_read_link("/proc/self/exe", nullptr);
  if (executable_path != nullptr) {
    g_autofree gchar* executable_dir = g_path_get_dirname(executable_path);
    g_autofree gchar* assets_path =
        g_build_filename(executable_dir, "data", "flutter_assets", nullptr);
    g_autofree gchar* icu_data_path =
        g_build_filename(executable_dir, "data", "icudtl.dat", nullptr);
    g_autofree gchar* aot_library_path =
        g_build_filename(executable_dir, "lib", "libapp.so", nullptr);

    if (g_file_test(assets_path, G_FILE_TEST_IS_DIR)) {
      fl_dart_project_set_assets_path(project, g_strdup(assets_path));
    }
    if (g_file_test(icu_data_path, G_FILE_TEST_EXISTS)) {
      fl_dart_project_set_icu_data_path(project, g_strdup(icu_data_path));
    }
    if (g_file_test(aot_library_path, G_FILE_TEST_EXISTS)) {
      fl_dart_project_set_aot_library_path(project, g_strdup(aot_library_path));
    }
  }

  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  g_signal_connect_swapped(view, "first-frame", G_CALLBACK(first_frame_cb), self);
  gtk_widget_realize(GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
     g_warning("Failed to register: %s", error->message);
     *exit_status = 1;
     return TRUE;
  }

  if (g_application_get_is_remote(application)) {
     return FALSE;
  }

  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  //MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  //MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     "flags", G_APPLICATION_HANDLES_COMMAND_LINE,
                                     nullptr));
}
