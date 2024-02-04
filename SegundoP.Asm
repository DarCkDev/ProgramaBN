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
jugadorInicial db maxCar dup(' '),0
contador dd 1
rondas dd 0
puntos1 dd 0
puntos2 dd 0

;-------------------Ventana Puntos
hVentanaPuntos dd 0
hVentanaResultados dd 0
lblJugador1 equ 1101
lblJugador2 equ 1102
lblRondas equ 1103
etPuntos1 equ 3101
etPuntos2 equ 3102
btnSiguiente equ 2101
;----------------------------

;-------------------Ventana Resultados
lblFinDelJuego equ 1201
lblMensaje equ 1202
lblMensajeGanador equ 1203
lblNombreGanador equ 1204
lblPuntosGanador equ 1205

;-------------------------------------

msjEmpate db "Empate.",0
msjGanador db "Ganador",0
msjErrorJugador db "Debe ingresar un nombre de Jugador",0
msjErrorRondas db "Debe ingresar un número válido entre 1 y 9.",0
msjError db "Error",0
msjErrorValidacion db "Debe ingresar un número válido entre 1 y 9.",0
msjFin db "Fin del juego.",0
msjFinGanador db "Ambos jugadores mostraron mucha destreza, pero los puntajes no mienten.",0
msjFinEmpate db "Increíble, los dos fueron geniales y lograron puntajes iguales.",0
msjFelicidadesGanador db "Felicidades, el ganador es: ",0
msjFelicidadesEmpate db "Felicidades, empataron.",0
 
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
	
a1000:
	invoke SendMessage,[hWnd],WM_CLOSE,0,0
	mov eax,1
	jmp finish

aBtnSiguiente:
	mov eax,[rondas]
	mov ebx,[contador]
	cmp ebx,eax
	jb guardarEIncrementar
	je guardarYMostrar
	
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
	mov eax,[rondas]
	mov ebx,1
	cmp eax,ebx
	jb mostrarDialogoError
	mov eax,[rondas]
	mov ebx,9
	cmp eax,ebx
	ja mostrarDialogoError
	
	invoke GetDlgItem,[hWnd],btnRegistrar
	invoke EnableWindow,eax,FALSE
	
	invoke GetDlgItem,[hWnd],btnIniciar
	invoke EnableWindow,eax,FALSE
	
	invoke CreateDialogParam,[gIst],2,0,DlgProc,0
	mov [hVentanaPuntos], eax
	invoke SendDlgItemMessage,[gWnd],lblJugador1,WM_SETTEXT,0,jugador1
	invoke SendDlgItemMessage,[gWnd],lblJugador2,WM_SETTEXT,0,jugador2
	invoke SetDlgItemInt,[gWnd],lblRondas,[contador],0
	mov eax,1
	jmp finish
	
guardarEIncrementar:
	;Agregar puntos jugador 1
	invoke GetDlgItemInt,[gWnd],etPuntos1,0,0
	
	mov ebx,0
	cmp eax,ebx
	jb mostrarDialogoError
	mov ebx,9
	cmp eax,ebx
	ja mostrarDialogoError
	
	mov ebx,[puntos1]
	add eax,ebx
	mov [puntos1],eax
	
	;Agregar puntos jugador 2
	invoke GetDlgItemInt,[gWnd],etPuntos2,0,0
	
	mov ebx,0
	cmp eax,ebx
	jb mostrarDialogoError
	mov ebx,9
	cmp eax,ebx
	ja mostrarDialogoError
	
	mov ebx,[puntos2]
	add eax,ebx
	mov [puntos2],eax
	
	;Incrementar contador de rondas
	mov ebx,1
	add ebx,[contador]
	mov [contador],ebx
	invoke SetDlgItemInt,[gWnd],lblRondas,[contador],0
	
	;Reinciar etPuntos
	invoke SetDlgItemInt,[gWnd],etPuntos1,0,0
	invoke SetDlgItemInt,[gWnd],etPuntos2,0,0
	
	mov eax,1
	jmp finish

guardarYMostrar:
	;Agregar puntos jugador 1
	invoke GetDlgItemInt,[gWnd],etPuntos1,0,0
	
	mov ebx,0
	cmp eax,ebx
	jb mostrarDialogoError
	mov ebx,9
	cmp eax,ebx
	ja mostrarDialogoError
	
	mov ebx,[puntos1]
	add eax,ebx
	mov [puntos1],eax
	
	;Agregar puntos jugador 2
	invoke GetDlgItemInt,[gWnd],etPuntos2,0,0
	
	mov ebx,0
	cmp eax,ebx
	jb mostrarDialogoError
	mov ebx,9
	cmp eax,ebx
	ja mostrarDialogoError
	
	mov ebx,[puntos2]
	add eax,ebx
	mov [puntos2],eax
	
	mov ebx,[puntos1]
	mov eax,[puntos2]
	cmp eax,ebx
	jb mostrarGanador1
	cmp eax,ebx
	ja mostrarGanador2
	jmp mostrarEmpate
	
	mov eax,1
	jmp finish

mostrarDialogoError:
	invoke MessageBox,[gWnd],msjErrorValidacion,msjError,MB_OK
	mov eax,1
	jmp finish
	
mostrarEmpate:
	invoke CreateDialogParam,[gIst],3,0,DlgProc,0
	mov [hVentanaResultados],eax
	
	invoke GetDlgItem, [gWnd], lblFinDelJuego
    invoke SendMessage,eax,WM_SETFONT,48
    invoke GetDlgItem, [gWnd], lblMensajeGanador
    invoke SendMessage,eax,WM_SETFONT,20
	
	invoke SendDlgItemMessage,[gWnd],lblMensaje,WM_SETTEXT,0,msjFinEmpate
	invoke SendDlgItemMessage,[gWnd],lblMensajeGanador,WM_SETTEXT,0,msjFelicidadesEmpate
	
	invoke EndDialog,[hVentanaPuntos],0
	
	mov eax,1
	jmp finish

mostrarGanador1:
	invoke CreateDialogParam,[gIst],3,0,DlgProc,0
	mov [hVentanaResultados],eax
	
	invoke GetDlgItem, [gWnd], lblFinDelJuego
    invoke SendMessage,eax,WM_SETFONT,48
    invoke GetDlgItem, [gWnd], lblMensajeGanador
    invoke SendMessage,eax,WM_SETFONT,20
    
	invoke SendDlgItemMessage,[gWnd],lblNombreGanador,WM_SETTEXT,0,jugador1
	invoke SendDlgItemMessage,[gWnd],lblMensaje,WM_SETTEXT,0,msjFinGanador
	invoke SendDlgItemMessage,[gWnd],lblMensajeGanador,WM_SETTEXT,0,msjFelicidadesGanador
	invoke SetDlgItemInt,[gWnd],lblPuntosGanador,[puntos1],0
	
	invoke EndDialog,[hVentanaPuntos],0
	
	mov eax,1
	jmp finish

mostrarGanador2:
	invoke CreateDialogParam,[gIst],3,0,DlgProc,0
	mov [hVentanaResultados],eax
	
	invoke GetDlgItem, [gWnd], lblFinDelJuego
    invoke SendMessage,eax,WM_SETFONT,48
    invoke GetDlgItem, [gWnd], lblMensajeGanador
    invoke SendMessage,eax,WM_SETFONT,20
	
	invoke SendDlgItemMessage,[gWnd],lblPuntosGanador,WM_SETTEXT,0,jugador2
	invoke SendDlgItemMessage,[gWnd],lblMensaje,WM_SETTEXT,0,msjFinGanador
	invoke SendDlgItemMessage,[gWnd],lblMensajeGanador,WM_SETTEXT,0,msjFelicidadesGanador
	invoke SetDlgItemInt,[gWnd],lblPuntosGanador,[puntos2],0
	
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
	  EnableWindow, 'EnableWindow',\
	  CreateDialogParam, 'CreateDialogParamA',\
	  ShowWindow, 'ShowWindow',\
	  SendDlgItemMessage, 'SendDlgItemMessageA',\
	  MessageBox, 'MessageBoxA',\
	  SendMessage,	  'SendMessageA'

section '.rsrc' resource from 'SegundoP.res' data readable
