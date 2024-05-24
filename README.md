# interactive-wallpaper-template-for-hidamari
an proof of concept that show how to make interactive livewallpapers for linux with hidamari.

Tested on: Ubuntu 22.04 wayland and xorg.
(default desktop enviroment)

**Instructions**
how to run:

install Hidamari on your system:
https://github.com/jeffshee/hidamari


open the directory where the demo files are in an terminal and type:
python3 -m http.server 9000
press enter

in case you are still runing an old version of pythoon you should type:
python -m SimpleHTTPServer 9000
press enter

open hidamari, chose Web Page
where it says webpage URL put the text below:
http://192.168.0.10:9000/web/
press the right arrow.

open the directory with the demo files, enter the X11 directory  and open:
server.x86_64

**DISCLAIMER:**
at that moment, you might lose the ability to click on anything of the screen, dont panic, you can just press alt+f4 (both keys at the same time) to quit it.
you can also alt tab.
you need this server runing to be able to send commands to the wallpaper (keyboard presses, mouse movments, gamepad button presses etc)
currently controler axis (sticks , L2, R2, motion sensores) arent supported.
read how it works for more information.

**How to quit:**
make sure the server.x86_64 is selected and press alt+f4, or close it as you do with any other program on the tray of your distribution.
select the terminal window where you  are runing SimpleHTTPServer and press control+c to stop it, or close the window.

**How it works:**
hidamari can display an page and this page can send/receive data from the network, but it cant capture input devices (mouse, keyboard, gamepads), so what this software does?
this software have 2 modes of operation, an server and an client:
**the server**
 act as an "screen logger" ,"key logger" and "gamepad logger", it detect what buttons, keys or mouse movments you are doing and send it to other programs, dont worry its only send to your own machine, so unless there is an malicious program listening on this port, you should be safe.
 the server is an full screen window, 100% transparent, that passthrough any mouse event to the other windows below it, its an technology usually used to make "desktop pets" but in this case, it was used to send any mouse command you do to the wallpaper.
 except that... you have to disable in in order to detect any mouse event... and there is a bug on godot that prevent it from being enabled again (i still have to report this bug, as soon as i can explain it)
 as an result of this bug, sometimes the server will prevent you from clicking in any window (hence why i wrote the disclaimer above) , and sometimes it will enable you to use the desktop as usual, but you wont be able to send mouse events (move, clicks) to the wallpaper.
 you can try to turn on the passtrhough mode by pressing N and off by pressing F,  or toggle between both modes pressing T.
 

**the client**
is the wallpaper that hidamari will display, currently its boring because its just an template showing that its working, you should replace it with anything you want.



currently both the server and the client are and godot project, you have to run 2 instances of an game engine runtime just to display an wallpaper wich might be resource hungry (hence why im calling it an work arround) , and the wallpaper need to be done on godot.
but dont worry, both the client and server should be easy to replace, you can replace just one of then with your own code so long as it can read the data in the correct websocket protocol on the right port and encode/decode the input details in the correct format to send/receive it.

or you can replace both client and server with your own code and use your own encode/decode format, this is just an reference implementation.
(im not sure if hidamari will accept any protocol, websocket and anything that an browser understand should be safe)


**how to edit:**
download godot 3.6 or latter 
https://godotengine.org/
drag and drop the project.godot file to godot window to edit it, or click in import , navigate to the directory containing this file and select it.
go to editor, manage export templates, click on download and install (you will need this to export the html files for hidamari)



i hope the instructions are clear, just open an issue if you have any questions.
if you liked this or any of my future projects, please consider an donation:
https://elmapul.itch.io/hidamari-live-wallpaper-template



