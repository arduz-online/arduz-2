Attribute VB_Name = "Diseño"
Public Const PI = 64
Public Const PA = 96
Public Const es = 32
Public Const TE = 128

Public Function HacerIndex(medgx As Integer, medgy As Integer, medgrhx As Integer, medgrhy As Integer, anim As Integer, es As Integer, xi As Integer, yi As Integer, xf As Integer, yf As Integer, posicion As Integer, grafico As Integer) As String
ngrhx = 0
ngrhy = 0
pix = 0
piy = 0
movx = 0
movy = 0
X = 0
Y = 0
Cont = 0
contsino = 0
res = 0

'struct puntos
'{
'char cadena[20];
'}cardinales[4];
'*/
'/*ofstream ent("Graficos.txt");lo quitamos para que se pueda seguir indexando sin que se cierre el programa*/

HacerIndex = ""

ngrhx = medidax / medgx
ngrhy = mediday / medgy

If (pocicion = 1) Then ngrhy = yf

If (ngrhx = 1 And ngrhy = 1 And Not anim = 1) Then contsino = 1

For Y = yi To Y < ngrhy
    If Y = 2 And anim = 1 And es = 0 Then ngrhx = ngrhx - 1
    piy = medgy * Y
    movy = piy
    If anim = 1 Then
        HacerIndex = HacerIndex & vbCrLf & "******** Parte " & (Y + 1) & "********" & vbCrLf
    End If
    If (Y = (ngrhy - 1) And posicion = 1) Then ngrhx = xf
    
    For X = xi To X < ngrhx
        pix = medgx * X
        movx = pix
        movy = piy
        Cont = Cont + 1
        conmax = Cont
        If anim <> 1 Then HacerIndex = HacerIndex & vbCrLf
        
        Do While (movy < medgy * (Y + 1))
            Do While (movx < medgx * (X + 1))
                HacerIndex = HacerIndex & vbCrLf & "Grh" & ni & "=1-" & z & "-" & movx & "-" & movy & "-" & medgrhx & "-" & medgrhy & "-" & Nombre & " "
                If contsino = 0 Then HacerIndex = HacerIndex & Cont
                If anim = 1 Then
                    HacerIndex = HacerIndex & vbCrLf & ni & vbCrLf
                End If
                movx = movx + medgrhx
                ni = ni + 1
            Loop
            movx = pix
            movy = movy + medgrhy
        Loop
    Next
    If posicion = 1 Then xi = 0
Next

MsgBox HacerIndex

End Function

