VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsAntiDos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

 
Private Const MaximoConexionesPorIP = 10
Private m_coleccion As New Collection
 
Public Function MaxConexiones(sIp As String) As Boolean
 
Dim i As Integer
Dim oIp As New UserAddress
 
oIp.Address = sIp
oIp.Conexiones = 1
m_coleccion.Add oIp
 
For i = 1 To m_coleccion.count
    If m_coleccion.Item(i).Address = sIp Then
        m_coleccion.Item(i).Conexiones = m_coleccion.Item(i).Conexiones + 1
        MaxConexiones = (m_coleccion.Item(i).Conexiones >= MaximoConexionesPorIP)
        Exit Function
    End If
Next
 
MaxConexiones = False
 
End Function
 
Public Function RestarConexion(sIp As String)
On Error GoTo errhandler
Dim i As Integer
 
For i = 1 To m_coleccion.count
   If m_coleccion.Item(i).Address = sIp Then
      m_coleccion.Item(i).Conexiones = m_coleccion.Item(i).Conexiones - 1
      If m_coleccion.Item(i).Conexiones = 0 Then Call m_coleccion.Remove(i)
      Exit Function
   End If
Next
 
Exit Function
 
errhandler:
    Call LogError("Error en RestarConexion " & Err.Description)
   
End Function
