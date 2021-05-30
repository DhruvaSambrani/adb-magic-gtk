using Gtk
import Gtk: showall
using DataStructures

include("ADB.jl")
using .ADB

struct Instance
    adb_path::String
    builder::GtkBuilderLeaf
end

Instance(glade_file_path, adb_path="adb"; buff_size=50) = Instance(
    adb_path,
    GtkBuilder(filename=glade_file_path)
)

win(i::Instance) = i.builder["main_win"]

Gtk.showall(i::Instance) = showall(win(i))

function set_key_callbacks!(i::Instance)
    map(["up", "left", "down", "right",
        "enter", "call", "ecall",
        "power", "wake",
        "volu", "vold", "mute",
        "home", "back"
    ]) do button_action
        signal_connect(
            w->adb_key(button_action, i.adb_path),
            i.builder["button_"*button_action],
            "clicked"
        )
    end
end
function update_notifications(i::Instance)
    adb_notify()
end
function set_text_callback!(i::Instance)
    signal_connect(
        i.builder["textinput_entry"], 
        "activate"
    ) do widget
        text = get_gtk_property(widget, :text, String) 
        adb_text(text,
            i.adb_path,
            get_gtk_property(i.builder["checkbox_uni"], :active,Bool)
        )
        set_gtk_property!(widget, :text, "")
    end
end
function set_ui_callback!(i::Instance)
    signal_connect(i.builder["textinput_ui"], "activate") do widget
        adb_ui(
            get_gtk_property(widget, :text, String),
            i.adb_path
        )
        set_gtk_property!(widget, :text, "")
    end
end
function set_filepicker_callback!(i::Instance)
    signal_connect(i.builder["file_chooser"], "clicked") do widget
        filepath = replace(
            open_dialog("Send File"),
            "/home/dhruva/winhome" => "C://Users/dhruv"
        )
        println(filepath)
        adb_send(filepath, i.adb_path)
    end
end
function set_callbacks!(i::Instance)
    set_key_callbacks!(i)
    set_text_callback!(i)
    set_ui_callback!(i)
    set_filepicker_callback!(i)
end

waitfordestroy(i::Instance) = Gtk.waitforsignal(
    win(i),
    :destroy
)

function main()
    instance = Instance("main.glade")
    set_callbacks!(instance)
    showall(instance)
    if !isinteractive()
        @async Gtk.gtk_main()
        waitfordestroy(instance)
    end
end

main()
