#include "my_application.h"

#include <clocale>
#include <cstdlib>

int main(int argc, char** argv) {
  unsetenv("LC_ALL");
  setenv("LC_NUMERIC", "C", 1);
  setlocale(LC_NUMERIC, "C");
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
