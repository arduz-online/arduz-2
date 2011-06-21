Attribute VB_Name = "modWebAndTeam"
Option Explicit

Type ePJ
    Nick As String
    clan As String
    desc As String
    frags As String
    Puntos As String
    muertes As String
    
    ekipo As eKip
    ID As Long
    gm As Boolean
    bot As Boolean
    Ping As Integer
End Type

Public Enum eKip
    eNone = 0
    eCUI = 1
    ePK = 2
End Enum

Public pjs(40) As ePJ
Public Ekipos(3) As ekipo

Type ekipo
    Nombre As String
    color As Long
    num As Integer
    personajes(40) As Integer
End Type

Public totalxs As Integer

Public hamachi As Boolean

Public renderasd As Boolean

Public passw As String * 32

Public Type tServers
    Item As String
    server As String
    Puerto As Long
    mapa As String
    Ping As String
    pjs As String
    priv As Boolean
End Type

Public servers As Collection
Public lstServers() As tServers
Public iplst As String

Public seltienepass As Boolean


