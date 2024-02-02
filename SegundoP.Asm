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

maxCar equ 20
jugador1 db maxCar dup(' '),0
jugador2 db maxCar dup(' '),0
rondas dd 0

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
	xor eax,eax
	jmp finish

aBtnRegistrar:
	invoke SendDlgItemMessage,[gWnd],etJugador1,WM_GETTEXT,maxCar,jugador1
	invoke SendDlgItemMessage,[gWnd],etJugador2,WM_GETTEXT,maxCar,jugador2
	invoke GetDlgItemInt,[gWnd],etRondas,rondas,0
	;invoke MessageBox,[gWnd],jugador1,jugador2,MB_OK
	
	mov eax,1
	jmp finish

aBtnIniciar:
	invoke MessageBox,[gWnd],jugador1,jugador2,MB_OK
	
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

;mostrarErrorJugador:
;	invoke MessageBox,[gWnd],msjErrorJugador,msjError,MB_OK
	
;	mov eax,1
;	jmp finish
	
;mostrarErrorRondas:
;	invoke MessageBox,[gWnd],msjErrorRondas,msjError,MB_OK
;	mov eax,1
;	jmp finish

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
	  SendDlgItemMessage, 'SendDlgItemMessageA',\
	  MessageBox, 'MessageBoxA',\
	  SendMessage,	  'SendMessageA'

section '.rsrc' resource from 'SegundoP.res' data readable
