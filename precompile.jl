using Gtk

GtkBuilder(filename="main.glade")
l = GtkLabel("build")
GAccessor.line_wrap(l, true)
GAccessor.xalign(l, 0.0)
b = GtkButton(l)
GAccessor.relief(b, Gtk.GConstants.GtkReliefStyle.NONE)
signal_connect(w->nothing, b, "clicked")
GtkFrame(b, "test")
