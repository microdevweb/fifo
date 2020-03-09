; --------------------------------------------------------
; PROJECT   : Fifo demonstration
; AUTHOR    : microdevWeb
; DATE      : 2020-03-09
; PROCESS   : in this small example, we look for 5000 first prime numbers 
; To a thread which will put it into a fifo List. 
; Another thread will reads numbers found And will be display those at the screen
; That just for test, the algorithm isn't optimised
; --------------------------------------------------------
XIncludeFile "include/fifo.pbi"
#N_TO_FOUND = 500

Global THRm,THRd,nb
Structure _pn
  pos.i
  value.i
EndStructure

Procedure THRmake(fifo.FIFO::object)
  Protected t,p.b,n = 1
  Repeat
    n+1
    t = n-1 
    p = #True
    While t < n And t >1
      If Not n % t 
        p = #False 
        Break
      EndIf
      t-1
    Wend
    If p
      Define *pn._pn = AllocateStructure(_pn)
      nb+1
      *pn\pos = nb
      *pn\value = n
      fifo\push(*pn)
    EndIf
  Until nb > = #N_TO_FOUND
  fifo\push(-1)
  KillThread(THRm)
EndProcedure

Procedure THRdisplay(fifo.FIFO::object)
  Protected *pn._pn
  Repeat
    *pn = fifo\pop()
    If *pn > -1
      Debug Str(*pn\pos)+") "+Str(*pn\value)
      FreeStructure(*pn)
    Else
      Break
    EndIf
  ForEver 
  fifo\free()
  KillThread(THRd)
EndProcedure

Global fifo.FIFO::object = FIFO::new(20)

THRm = CreateThread(@THRmake(),fifo)
THRd = CreateThread(@THRdisplay(),fifo)

WaitThread(THRd)


End


; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 44
; FirstLine = 39
; Folding = -
; EnableXP