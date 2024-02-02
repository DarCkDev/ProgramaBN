format PE GUI 4.0
entry MyEntry

include '%fasminc%\Win32a.inc'

section '.data' data readable writeable

gIst dd 0
gWnd dd 0
btnRegistrar equ 2001
btnIniciar equ 2002
etJugador1 equ 3001
etJugador2 equ 3002
etRondas equ 3003
lblDescripcion equ 1002

maxCar equ 20
jugador1 db maxCar dup(' '),0
jugador2 db maxCar dup(' '),0
contador dd 1
rondas dd 0
puntos1 dd 0
puntos2 dd 0

;-------------------Pantalla2
lblJugador1 equ 1101
lblJugador2 equ 1102
lblRondas equ 1103
etPuntos1 equ 3101
etPuntos1 equ 3102
btnSiguiente equ 2101
;----------------------------

msjErrorJugador db "Debe ingresar un nombre de Jugador",0
msjErrorRondas db "Debe ingresar un número válido entre 1 y 9.",0
msjError db "Error",0
 
section '.code' code readable executable

MyEntry:
	invoke GetModuleHandle,eax
	mov [gIst],eax
	invoke DialogBoxParam,eax,1,0,DlgProc,0 
ExitApp:
	invoke ExitProcess,0

proc DlgProc,hWnd,uMsg,wParam,lParam	
	push edi esi ebx
	
	mov eax,[uMsg]
	cmp	eax,WM_COMMAND
	je	jCOMMAND
	cmp	eax,WM_INITDIALOG
	je	jINITDIALOG
	cmp	eax,WM_CLOSE
	je	jCLOSE
	xor eax,eax
	jmp finish

jINITDIALOG:
	mov eax,[hWnd]
	mov [gWnd],eax
	
	mov eax,1
	jmp finish
	
jCOMMAND:
	mov eax,[wParam]
	cmp	eax,1000
	je	a1000
	cmp eax,btnRegistrar
	je aBtnRegistrar
	cmp eax,btnIniciar
	je aBtnIniciar
	cmp eax,btnSiguiente
	je aBtnSiguiente
	xor eax,eax
	jmp finish

aBtnSiguiente:
	invoke MessageBox,[hWnd],jugador1,jugador2,MB_OK
	mov eax,1
	jmp finish
	
aBtnRegistrar:
	invoke SendDlgItemMessage,[gWnd],etJugador1,WM_GETTEXT,maxCar,jugador1
	invoke SendDlgItemMessage,[gWnd],etJugador2,WM_GETTEXT,maxCar,jugador2
	invoke GetDlgItemInt,[gWnd],etRondas,0,0
	mov [rondas],eax
	
	mov eax,1
	jmp finish

aBtnIniciar:
	invoke CreateDialogParam,[gIst],2,0,DlgProc,0
	invoke SendDlgItemMessage,[gWnd],lblJugador1,WM_SETTEXT,0,jugador1
	invoke SendDlgItemMessage,[gWnd],lblJugador2,WM_SETTEXT,0,jugador2
	invoke SetDlgItemInt,[gWnd],lblRondas,[contador],0
	mov eax,1
	jmp finish
	
a1000:
	invoke SendMessage,[hWnd],WM_CLOSE,0,0
	mov eax,1
	jmp finish
	
jCLOSE:	
	invoke EndDialog,[hWnd],0
	mov eax,1
	
finish:
	pop ebx esi edi
	ret
endp

;invoke CreateDialogParam,[gIst],2,0,DlgProc,0
;invoke MessageBox,[hWnd],jugador1,jugador2,MB_OK
;invoke GetDlgItem,[hWnd],lblRondaActual
;mov ebx,eax
;invoke ShowWindow,ebx,SW_HIDE
section '.idata' import data readable writeable

  library kernel, 'KERNEL32.DLL',\
	  user,   'USER32.DLL'

  import  kernel,\
	  GetModuleHandle,'GetModuleHandleA',\
	  ExitProcess,	  'ExitProcess'

  import  user,\
	  DialogBoxParam, 'DialogBoxParamA',\
	  EndDialog,	  'EndDialog',\
	  GetDlgItemInt, 'GetDlgItemInt',\
	  GetDlgItem, 'GetDlgItem',\
	  SetDlgItemInt, 'SetDlgItemInt',\
	  CreateDialogParam, 'CreateDialogParamA',\
	  ShowWindow, 'ShowWindow',\
	  SendDlgItemMessage, 'SendDlgItemMessageA',\
	  MessageBox, 'MessageBoxA',\
	  SendMessage,	  'SendMessageA'

section '.rsrc' resource from 'SegundoP.res' data readable
