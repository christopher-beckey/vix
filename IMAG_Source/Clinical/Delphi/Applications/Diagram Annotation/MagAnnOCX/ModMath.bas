Attribute VB_Name = "ModMath"


Type point
    x As Double
    y As Double
End Type

Public Function arccos(x As Double) As Double
    Dim arccosrad As Double
    If x = 1 Then
        arccos = 0
    Else
        arccosrad = Atn(-x / Sqr(-x * x + 1)) + 2 * Atn(1)
        arccos = arccosrad
    End If
End Function

Public Function distance(begin As point, term As point) As Double
    distance = Sqr((begin.x - term.x) * (begin.x - term.x) + (begin.y - term.y) * (begin.y - term.y))
End Function

Public Function findHalfArrow(init As point, term As point, angle As Double) As point
Dim PI As Double
PI = 3.14159
Dim vec As point
Dim x As Double
Dim y As Double
'init vector
vec.x = term.x - init.x
vec.y = term.y - init.y
'create vec as unit vector
vec.x = vec.x / distance(init, term)
vec.y = vec.y / distance(init, term)
'for manipulation
x = vec.x
y = vec.y
'multiply the matrix against the vector
vec.x = Cos((angle) * (PI / 180)) * x - Sin((angle) * (PI / 180)) * y
vec.y = Sin((angle) * (PI / 180)) * x + Cos((angle) * (PI / 180)) * y
'make length 400
vec.x = vec.x * 400
vec.y = vec.y * 400
'vec.x = vec.x * 2800
'vec.y = vec.y * 2800
'return func
findHalfArrow = vec
End Function


