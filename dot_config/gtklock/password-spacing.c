/*
 * gtklock password-spacing module
 *
 * Adds the CSS class "password-hidden" to the password entry while it is
 * masked, so style.css can space the dots without affecting normal text
 * after the reveal (eye) button is pressed.
 *
 * Built without GTK headers on purpose; the symbols are provided by gtklock
 * at load time. Rebuild after a gtklock major version change.
 *
 *   gcc -shared -fPIC -O2 -Wall -o password-spacing.so password-spacing.c
 */

#include <stddef.h>

typedef struct _GtkWidget GtkWidget;
typedef struct _GtkStyleContext GtkStyleContext;
typedef struct _GtkEntry GtkEntry;
typedef struct _GdkMonitor GdkMonitor;
typedef struct _GObject GObject;
typedef struct _GParamSpec GParamSpec;

typedef int gboolean;
typedef char gchar;
typedef unsigned long gulong;
typedef void (*GCallback)(void);

extern void gtk_style_context_add_class(GtkStyleContext *context,
                                        const gchar *class_name);
extern void gtk_style_context_remove_class(GtkStyleContext *context,
                                           const gchar *class_name);
extern GtkStyleContext *gtk_widget_get_style_context(GtkWidget *widget);
extern gboolean gtk_entry_get_visibility(GtkEntry *entry);

extern gulong g_signal_connect_data(void *instance,
                                    const gchar *detailed_signal,
                                    GCallback c_handler, void *data,
                                    void *destroy_data, int connect_flags);

/* Must match struct Window in gtklock v4 include/window.h */
struct Window {
  GdkMonitor *monitor;
  GtkWidget *window;
  GtkWidget *overlay;
  GtkWidget *window_box;
  GtkWidget *body_revealer;
  GtkWidget *body_grid;
  GtkWidget *input_label;
  GtkWidget *input_field;
  GtkWidget *message_revealer;
  GtkWidget *message_scrolled_window;
  GtkWidget *message_box;
  GtkWidget *unlock_button;
  GtkWidget *error_label;
  GtkWidget *warning_label;
  GtkWidget *info_box;
  GtkWidget *time_box;
  GtkWidget *clock_label;
  GtkWidget *date_label;
  void *module_data[];
};

unsigned int module_major_version = 4;
unsigned int module_minor_version = 0;

static void update_class(GtkWidget *entry) {
  GtkStyleContext *context = gtk_widget_get_style_context(entry);
  if (gtk_entry_get_visibility((GtkEntry *)entry))
    gtk_style_context_remove_class(context, "password-hidden");
  else
    gtk_style_context_add_class(context, "password-hidden");
}

static void on_visibility_notify(GObject *object, GParamSpec *pspec,
                                 void *data) {
  (void)pspec;
  (void)data;
  update_class((GtkWidget *)object);
}

void on_window_create(void *gtklock, struct Window *win) {
  (void)gtklock;
  if (!win || !win->input_field)
    return;

  update_class(win->input_field);
  g_signal_connect_data(win->input_field, "notify::visibility",
                        (GCallback)on_visibility_notify, NULL, NULL, 0);
}
