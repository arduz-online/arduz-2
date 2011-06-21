VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "UserAddress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_ip As String * 32
Private m_conexiones As Integer
Private m_personajes_creados As Integer
Public Property Get PersonajesCreados() As Integer: PersonajesCreados = m_personajes_creados: End Property
Public Property Let PersonajesCreados(Cant As Integer): m_personajes_creados = Cant: End Property
Public Property Get Address() As String: Address = m_ip: End Property
Public Property Let Address(ByVal Address As String): m_ip = Address: End Property
Public Property Let Conexiones(Cantidad As Integer): m_conexiones = Cantidad: End Property
Public Property Get Conexiones() As Integer: Conexiones = m_conexiones: End Property
