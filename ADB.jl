module ADB
using Base64
export adb_key, adb_ui, adb_text, adb_send

_name_key_map=Dict(
                   "home"=>"KEYCODE_HOME",
                   "back"=> "KEYCODE_BACK",
                   "clear"=> "KEYCODE_CLEAR",
                   "call"=> "KEYCODE_CALL",
                   "ecall"=> "KEYCODE_ENDCALL",
                   "up"=>  "KEYCODE_DPAD_UP",
                   "down"=> "KEYCODE_DPAD_DOWN",
                   "left"=> "KEYCODE_DPAD_LEFT",
                   "right"=> "KEYCODE_DPAD_RIGHT",
                   "enter"=> "KEYCODE_ENTER",
                   "power"=> "KEYCODE_POWER",
                   "vold"=> "KEYCODE_VOLUME_DOWN",
                   "mute"=> "KEYCODE_VOLUME_MUTE",
                   "volu"=> "KEYCODE_VOLUME_UP",
                   "wake"=> "KEYCODE_WAKEUP"
                  )

struct Notification
    activity_name::String
    notification_text::String
    function Notification(match::RegexMatch)
        new(match.captures[1], match.captures[2])
    end
end

function run_activity(n::Notification, adbpath="adb")
    run(Cmd([adbpath, "shell", "monkey", "-p", n.activity_name, "1"]))
end

function adb_notify(adbpath="adb")
    notif_string = readchomp(Cmd([
        adbpath, "shell",
        "dumpsys","notification", "--noredact"
    ]))
    map(Notification, eachmatch(
        r"NotificationRecord.*?pkg=(.*?)\ u.*?text=.*?\((.*?)\)"is,
        notif
    ))
end

function _preprocess(text, unicode)
    unesc = unescape_string(text)
    if unicode
        base64encode(unesc)
    else
        replace(unesc, "`"=>"\\`")
    end
end

_adb_holder(text) = println(text)

function adb_key(keyval, adbpath="adb")
    run(Cmd([adbpath, "shell", "input", "keyevent", _name_key_map[keyval]]), wait=false)
end

function adb_ui(searchtext, adbpath="adb")
    @async begin
        run(Cmd([adbpath, "shell", "uiautomator", "dump"]))
        xml = readchomp(Cmd([adbpath, "shell", "cat", "/sdcard/window_dump.xml"]))
        m = match(Regex(
            "text=\".*"*searchtext*".*?bounds=\"\\[(.*?)\\]\"", "is"
        ), xml)
        point = sum(parse.(Int, reshape(filter(i->!isempty(i), split(m.captures[1], r"[\],\[]")), 2, 2)),dims=2) .÷ 2
        lkl = [adbpath, "shell", "input", "tap"] 
        append!(lkl, string.(point))
        run(Cmd(lkl))
    end
end

function adb_text(text, adbpath="adb", unicode=true)
    if unicode
        run(Cmd([
                 adbpath,
                 "shell",
                 "am",
                 "broadcast",
                 "-a",
                 "ADB_INPUT_B64",
                 "--es",
                 "msg",
                 "\""*_preprocess(text, unicode)*"\""
                ]),
            wait = false
           )
    else
        run(Cmd([
                 adbpath,
                 "shell",
                 "input",
                 "keyboard",
                 "text",
                 "\""*_preprocess(text, unicode)*"\""
                ]),
            wait = false
           )
    end
    adb_key("enter", adbpath)
end

function adb_send(filepath, adbpath="adb")
    begin
        run(Cmd([adbpath, "push", filepath, "/sdcard/Download"]))
        run(Cmd([
                 adbpath,
                 "shell",
                 "am",
                 "start",
                 "-a",
                 "android.intent.action.SEND",
                 "-t",
                 "text/plain",
                 "--eu",
                 "android.intent.extra.STREAM",
                 "file:///storage/emulated/0/Download/"*basename(filepath)
                ]
               )
           )
    end
end

end
