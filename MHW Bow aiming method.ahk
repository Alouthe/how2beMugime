#SingleInstance Force
global Lmouse_time := 0
global Rmouse_time := 0
global Space_time := 0
global V_time := 0
Run, E:\MHW AHK\monster-hunter.ahk

#IfWinActive ahk_exe MonsterHunterWorld.exe
{
  $*f9::
    Suspend
    return
  
  $*Space::
    space()
    KeyWait, Space
    return
  
  $*Space Up::space_up()
  
  $*LButton::
    send {ctrl down}
    return
  
  $*RButton::
    Send, {v down}
    SetTimer, rbutton, 0
    return
  
  $*LButton Up::lbutton_up()
  
  $*RButton Up::
    setRmouse_time(500)
    SetTimer, rbutton, off
    SetTimer, v, 0
    return
}

space(){
  Hotkey, $*Space Up, On
  Send, {space up}
  Send, {v down}
  setSpace_time(80)
  SetTimer, space, 0
  return
}

space_up(){
  SetTimer, space, off
  send, {space down}
  sleep 1
  send, {space up}
  setV_time(600)
  SetTimer, v, 0
  return
}

space:
  if (!getSpace_time()){
    Hotkey, $*Space Up, off
    space_up()
  }
  return

lbutton_up(){
  SetTimer, lbutton, off
  if !(getRmouse_time()){
    Send, {v down}
  }
  send {ctrl up}
  setLmouse_time(17)
  setV_time(17)
  SetTimer, lbutton, 0
  return
}

lbutton:
  if (!getLmouse_time()){
    SetTimer, lbutton, off
    setV_time(700)
    SetTimer, v, 0
  }
  return

rbutton:
  setV_time(70)
  send, {NumpadAdd down}
  send, {NumpadAdd up}
  return

v:
  if (!getV_time()){
    SetTimer, v, Off
    send, {v up}
  }
  return

setLmouse_time(delay){
  global Lmouse_time := A_TickCount + delay
  return
}
getLmouse_time(){
  return global Lmouse_time > A_TickCount
}

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

setV_time(delay){
  if (A_TickCount + delay > global V_time){
    global V_time := A_TickCount + delay
  }
  return
}
getV_time(){
  return global V_time > A_TickCount
}
  