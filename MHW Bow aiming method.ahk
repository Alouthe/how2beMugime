f9::
  Suspend
return


global Lmouse_time := 0
global Space_time := 0
#IfWinActive ahk_exe MonsterHunterWorld.exe
{
  
  track := 0
  capslock::
    send {ENTER down}
    return
  
  capslock Up::
    send {ENTER up}
    return
  
  LWin::return
  RWin::return
  f8::
    WinClose, ahk_class ConsoleWindowClass ahk_exe HelloWorld-142-5-2-1543571672.exe
    Run, C:\Users\Administrator\Desktop\MHW mods\HelloWorld-142-5-2-1543571672.exe
    WinRestore, ahk_exe MonsterHunterWorld.exe
    WinActivate, ahk_exe MonsterHunterWorld.exe
    return
  
  ;space
  $*Space::Space()
    ;~ send, {v down}
    ;~ sleep 84
    ;~ send, {SPACE down}
    ;~ SoundBeep 523, 2
    return
  
  
  ;space up
  ;~ *Space UP::
    ;~ return
  
  
  ;Lmouse button
  *LButton::
    send {ctrl down}
    ;~ SoundBeep 523, 2
    return
  
  
  ;Rmouse button
  $*RButton::
    Send, {v down}
    while (GetKeyState("RButton", "P")){
      send, {NumpadAdd down}
      sleep 50
      send, {NumpadAdd up}
      sleep 50
      ;~ SoundBeep 523, 2
    } 
    return
  
  ;Lmouse button up
  *LButton Up::LButton_UP()
    ;~ Send, {v down}
    ;~ sleep 1
    MsgBox %A_ThisLabel%
    send  {ctrl up}
    ;~ SoundBeep 523, 2
    ;~ setLmouse_time(295)
    ;~ sleep, 300
    ;~ if (GetKeyState("RButton", "P")){
      ;~ return
    ;~ }
    ;~ Send, {v up}
    return
  
  
  ;Rmouse button up
  *RButton Up::
    if (GetKeyState("Space")){
      return
    }
    Send, {v up}
    return
  
}

Space(){
  send, {v down}
  sleep 10
  setSpace_time(90)
  while (getSpace_time()){
    if (!GetKeyState("Space", "P")){
      ;~ SoundBeep 523, 2
      break
    }
    sleep 17
  }
  send, {SPACE down}
  if (GetKeyState("RButton", "P") or getLmouse_time()){
      return
    }
  send, {v up}
  send, {SPACE up}
  ;~ SoundBeep 523, 2
  KeyWait, Space
}

LButton_UP(){
  LButton_state := false
  Send, {v down}
  sleep 17
  send  {ctrl up}
  ;~ SoundBeep 523, 2
  setLmouse_time(450)
  
  ;sleep for Lmouse_time, check if LButton is pressed and released
  while (getLmouse_time()){
    if GetKeyState("LButton", "P"){
      LButton_state := true
    }
    else if (LButton_state and !GetKeyState("LButton", "P")){
      return LButton_UP()
    }
    sleep 10
  }
  
  if (GetKeyState("RButton", "P")){
    return
  }
  Send, {v up}
  return
}
  
setLmouse_time(delay := 100){
  ;~ MsgBox %A_TickCount% %delay%
  global Lmouse_time := A_TickCount + delay
  return
}

getLmouse_time(){
  ;~ Lmouse_time := global Lmouse_time
  ;~ MsgBox %Lmouse_time%
  return global Lmouse_time > A_TickCount
}

setSpace_time(delay := 100){
  global Space_time := A_TickCount + delay
  return
}

getSpace_time(){
  return global Space_time > A_TickCount
}