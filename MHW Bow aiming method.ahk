#NoEnv
;~ Process, Priority, , H
SetBatchLines, -1
ListLines Off
#KeyHistory 0
SetTitleMatchMode 2
SetTitleMatchMode Fast
;~ SetKeyDelay, -1, -1, Play
;~ SetMouseDelay, -1
;~ SetWinDelay, 0		; Changed to 0 upon recommendation of documentation
;~ SetControlDelay, 0	; Changed to 0 upon recommendation of documentation
;~ SetDefaultMouseSpeed, 0
#SingleInstance Force

;~ global Lmouse_time := 0
global Rmouse_time := 0
global Space_time := 0
global V_time := 0
;~ global V_start := 0
global V_persist := false

#IfWinActive ahk_exe MonsterHunterWorld.exe
{
    Run, E:\MHW AHK\monster-hunter.ahk
    
    Suspend, On
    
    $*f9::
        Suspend
        return
        
	$*Space::
        Hotkey, $*Space Up, On          ;re-enables space up hotkey
        Send, {space up}                ;release the space key upon pressing space, otherwise it jams with spam
        ;~ Send, {v down}
        if (!getV_time() and !getRmouse_time() and !getSpace_time()){              ;determines the correct delay for sending space down to compensate game mechanic
            gosub, check_dir
        }else  {
            Send, {v down}
            gosub, space_up
        }
        KeyWait, Space                  ;prevent auto-repeat of space key while holding space, works while #MaxThreads = 1 (default)
        return
        
	$*Space Up::
        gosub, space_up
        return
        
	$*LButton::
        send {NumpadSub up}
        send {NumpadSub down}
        return
        
	$*LButton Up::
        if !(getRmouse_time()){         ;only send v when a certain amount of time has passed after the release of RButton
            Send, {v down}
        }
        setV_time(300)
        setSpace_time(750)
        ;~ send {NumpadSub up}
        SetTimer, lbutton, -16          ;delay for releasing LButton to compensate game mechanic
        return
        
	$*RButton::
        Send, {v down}
        send, {NumpadAdd down}
        SetTimer, rbutton, 16           ;rapid fire routine that repeats every 2/60 seconds (2 frames)
        setV_persist(true)              ;prevents "v" routine from releasing v while rapid fire is on
        return
        
	$*RButton Up::
        SetTimer, rbutton, off
        send, {NumpadAdd up}
        setRmouse_time(500)
        setSpace_time(1100)
        setV_persist(false)
        setV_time(100)
        return
    
    $*y::
        DllCall("mouse_event", uint, 1, int, 1265, int, 0)
        sleep 50
        DllCall("mouse_event", uint, 1, int, -1265, int, 0)
        KeyWait, y
        return
    
    f::MouseMove -5, 0, 50, R
    
    ;~ $*s::
        ;~ Send, {s down}
        ;~ Send, {v down}
        ;~ setV_persist(true)
        ;~ KeyWait, s
        ;~ return
    
    ;~ $*s Up::
        ;~ Send, {s up}
        ;~ setV_persist(false)
        ;~ setV_time(100)
        ;~ return
    
	;~ $*c::
        ;~ send, {v up}
        ;~ KeyWait, c
        ;~ return
}
    
space_up:                               ;timed/hotkey routine, most of the code is to maintain mutex of the two methods of calling this routine, per space press/release
    SetTimer, space_up, off
    send, {space down}
    setV_time(406)
    setSpace_time(1200)
    settimer, space, -16
    Hotkey, $*Space Up, off             ;prevents this routine from running twice in one key press
	return

space:
    send, {space up}
	return

lbutton:
    send {NumpadSub up}
	return

rbutton:
    send, {NumpadAdd down}
    send, {NumpadAdd up}
	return

v:                                      ;timed subroutine to release v key, as long as no RF routine is on
    if (not global V_persist){
        send, {v up}
    }
	return

check_dir:
    if (GetKeyState("w", "P")){
        ;~ send, {w up}
        key := "w"
        dx := 0
    }
    else if (GetKeyState("a", "P")){
        ;~ send, {a up}
        key := "a"
        dx := 3795
    }
    else if (GetKeyState("s", "P")){
        ;~ send, {s up}
        key := "s"
        dx := 2530
    }
    else if (GetKeyState("d", "P")){
        ;~ send, {d up}
        key := "d"
        dx := 1265
    }
    else{
        Send, {v down}
        gosub, space_up
        return
    }
    DllCall("mouse_event", uint, 1, int, dx, int, 0)
    Send, {v down}
    ;~ send, {w down}
    SetTimer, re_center, -1
    gosub, space_up
    
    return

re_center:
    ;~ Send, {w up}
    ;~ Send, {%key% down}
    DllCall("mouse_event", uint, 1, int, -dx, int, 0)
    return

setV_persist(persist){
    global V_persist := persist
    return
}

;~ setLmouse_time(delay){
    ;~ global Lmouse_time := A_TickCount + delay
    ;~ return
;~ }
;~ getLmouse_time(){
    ;~ return global Lmouse_time > A_TickCount
;~ }

setRmouse_time(delay){
    global Rmouse_time := A_TickCount + delay
    return
}
getRmouse_time(){
    return global Rmouse_time > A_TickCount
}

setSpace_time(delay){
    global Space_time := A_TickCount + delay
    return
}
getSpace_time(){
    return global Space_time > A_TickCount
}

setV_time(delay){                      ;
    if (A_TickCount + delay > global V_time){
        global V_time := A_TickCount + delay
        SetTimer, v, -%delay%
    }
    return
}
getV_time(){
    if GetKeyState("v","P")
        return true
    return global V_time > A_TickCount
}              