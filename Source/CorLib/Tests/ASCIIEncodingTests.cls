VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ASCIIEncodingTests"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'
' TestASCIIEncoding
'
Option Explicit
Implements ITestCaseSource

Private en As Encoding

Private Sub ITestCaseSource_GetTestCases(ByVal Test As SimplyVBComp.TestCaseCollector)
    Select Case Test.MethodName
        Case "GetBytes_WithChars_ReturnsExpected"
            Test.Use vbNullChar, NewBytes(0)
            Test.Use vbTab, NewBytes(9)
            Test.Use Chr$(127), NewBytes(127)
            Test.Use Chr$(128), NewBytes(63)
            Test.Use ChrW$(&HFFFF), NewBytes(63)
            Test.Use "ABC", NewBytes(65, 66, 67)
            Test.Use NewIntegers(96, 97, 98), NewBytes(96, 97, 98)
            Test.Use "", NewBytes()
            Test.Use NewIntegers(), NewBytes()
            
        Case "GetBytes_WithIndexAndCount_ReturnsExpectedSubset"
            Test.Use "abcd", NewBytes(98, 99)
            Test.Use NewIntegers(97, 98, 99, 100), NewBytes(98, 99)
            
        Case "GetByteCount_WithCharacters_ReturnsExpected"
            Test.Use "abc", 3
            Test.Use "", 0
            Test.Use NewIntegers(97, 98, 99, 100), 4
            Test.Use NewIntegers(), 0
            
        Case "GetCharCount_WithBytes_ReturnsExpected"
            Test.Use NewBytes(1), 1
            Test.Use NewBytes(1, 2, 3, 4, 5), 5
            Test.Use NewBytes(), 0
        
        Case "GetString_WithBytes_ReturnsExpected"
            Test.Use NewBytes(48, 49, 50), "012"
            Test.Use NewBytes(), ""
            
    End Select
End Sub

Public Sub Setup()
    Set en = Encoding.ASCII
End Sub

Public Sub GetBytes_WithChars_ReturnsExpected(ByRef Chars As Variant, ByRef Expected() As Byte)
    Dim Encoding As New ASCIIEncoding
    
    Dim Actual() As Byte
    Actual = Encoding.GetBytes(Chars)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub GetBytes_WithIndexAndCount_ReturnsExpectedSubset(ByRef Chars As Variant, ByRef Expected() As Byte)
    Dim Encoding As New ASCIIEncoding
    
    Dim Actual() As Byte
    Actual = Encoding.GetBytes(Chars, 1, 2)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub GetBytes_WithNullArray_ThrowsArgumentNullException()
    Dim Encoding As New ASCIIEncoding
    Dim NullChars() As Integer
    
    On Error GoTo errTrap:
    Encoding.GetBytes NullChars
    
errTrap:
    AssertArgumentNullException Err, "Chars"
End Sub

Public Sub GetBytes_WithIndexLessThanZero_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap:
    Encoding.GetBytes "abc", -1, 0
    
errTrap:
    AssertArgumentOutOfRangeException Err, "Index"
End Sub

Public Sub GetBytes_WithCountLessThanZero_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap:
    Encoding.GetBytes "abc", 0, -1
    
errTrap:
    AssertArgumentOutOfRangeException Err, "Count"
End Sub

Public Sub GetBytes_WithIndexPlusCountExtendBeyondChars_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap:
    Encoding.GetBytes "abc", 1, 3
    
errTrap:
    AssertArgumentOutOfRangeException Err, "Chars"
End Sub

Public Sub GetBytes_WithMissingCount_ThrowsArgumentException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap:
    Encoding.GetBytes "abc", 0
    
errTrap:
    AssertArgumentException Err, "Count"
End Sub

Public Sub GetBytes_WithMissingIndex_ThrowsArgumentException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap:
    Encoding.GetBytes "abc", , 2
    
errTrap:
    AssertArgumentException Err, "Index"
End Sub

Public Sub GetByteCount_WithCharacters_ReturnsExpected(ByRef Chars As Variant, ByVal Expected As Long)
    Dim Encoding As New ASCIIEncoding
    
    Dim Actual As Long
    Actual = Encoding.GetByteCount(Chars)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub GetByteCount_WithIndexAndCount_ReturnsExpected()
    Dim Encoding As New ASCIIEncoding
    
    Dim Actual As Long
    Actual = Encoding.GetByteCount("abc", 1, 2)
    
    Assert.That Actual, Iz.EqualTo(2)
End Sub

Public Sub GetByteCount_WithMissingCount_ThrowsArgumentException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap
    Encoding.GetByteCount "abc", Count:=2
    
errTrap:
    AssertArgumentException Err, "Index"
End Sub

Public Sub GetByteCount_WithMissingIndex_ThrowsArgumentException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap
    Encoding.GetByteCount "abc", 0
    
errTrap:
    AssertArgumentException Err, "Count"
End Sub

Public Sub GetByteCount_WithIndexLessThanLBound_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap
    Encoding.GetByteCount "abc", -1, 1
    
errTrap:
    AssertArgumentOutOfRangeException Err, "Index"
End Sub

Public Sub GetByteCount_WithCountLessThanZero_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap
    Encoding.GetByteCount "abc", 0, -1
    
errTrap:
    AssertArgumentOutOfRangeException Err, "Count"
End Sub

Public Sub GetByteCount_WithIndexPlusCountExtendBeyondChars_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    
    On Error GoTo errTrap
    Encoding.GetByteCount "abc", 1, 3
    
errTrap:
    AssertArgumentOutOfRangeException Err, "Chars"
End Sub

Public Sub GetBytesEx_WithCharIndexLessThanLBound_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    Dim Chars(-2 To 0) As Integer
    Dim Bytes(0 To 2) As Byte
    
    On Error GoTo errTrap
    Encoding.GetBytesEx Chars, -3, 1, Bytes, 0
    
errTrap:
    AssertArgumentOutOfRangeException Err, "CharIndex"
End Sub

Public Sub GetBytesEx_WithCharCountLessThanZero_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    Dim Chars(0) As Integer
    Dim Bytes(0) As Byte
    
    On Error GoTo errTrap
    Encoding.GetBytesEx Chars, 0, -1, Bytes, 0
    
errTrap:
    AssertArgumentOutOfRangeException Err, "CharCount"
End Sub

Public Sub GetBytesEx_WithCharIndexPlusCharCountBeyondChars_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    Dim Chars(0) As Integer
    Dim Bytes(0) As Byte
    
    On Error GoTo errTrap
    Encoding.GetBytesEx Chars, 0, 2, Bytes, 0
    
errTrap:
    AssertArgumentOutOfRangeException Err, "Chars"
End Sub

Public Sub GetBytesEx_WithByteIndexLessThanLBound_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    Dim Chars(0) As Integer
    Dim Bytes(-1 To 0) As Byte
    
    On Error GoTo errTrap
    Encoding.GetBytesEx Chars, 0, 1, Bytes, -2
    
errTrap:
    AssertArgumentOutOfRangeException Err, "ByteIndex"
End Sub

Public Sub GetBytesEx_WithByteIndexGreaterThanUBound_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    Dim Chars(0) As Integer
    Dim Bytes(-1 To 0) As Byte
    
    On Error GoTo errTrap
    Encoding.GetBytesEx Chars, 0, 1, Bytes, 1
    
errTrap:
    AssertArgumentOutOfRangeException Err, "ByteIndex"
End Sub

Public Sub GetBytesEx_WithCharsThatFitIntoOutput_EncodesAllChars()
    Dim Encoding As New ASCIIEncoding
    Dim Bytes() As Byte
    ReDim Bytes(1 To 10)
    
    Dim ActualCount As Long
    ActualCount = Encoding.GetBytesEx("12345", 0, 5, Bytes, 1)
    
    Assert.That ActualCount, Iz.EqualTo(5)
    Assert.That Bytes, Iz.EqualTo(NewBytes(49, 50, 51, 52, 53, 0, 0, 0, 0, 0)).AsCollection
End Sub

Public Sub GetBytesEx_WithNotEnoughCapacity_ThrowsArgumentException()
    Dim Encoding As New ASCIIEncoding
    Dim Bytes() As Byte
    ReDim Bytes(1 To 3)
    
    On Error GoTo errTrap
    Encoding.GetBytesEx "12345", 0, 5, Bytes, 1
    
errTrap:
    AssertArgumentException Err, "Bytes"
End Sub

Public Sub GetBytesEx_WithSubsetSpecified_EncodesSubset()
    Dim Encoding As New ASCIIEncoding
    Dim Bytes() As Byte
    ReDim Bytes(1 To 10)
    
    Dim ActualCount As Long
    ActualCount = Encoding.GetBytesEx("12345678", 1, 4, Bytes, 1)
    
    Assert.That ActualCount, Iz.EqualTo(4)
    Assert.That Bytes, Iz.EqualTo(NewBytes(50, 51, 52, 53, 0, 0, 0, 0, 0, 0)).AsCollection
End Sub

Public Sub GetBytesEx_WithEmptyCharacters_DoesNotFill()
    Dim Encoding As New ASCIIEncoding
    Dim Bytes() As Byte
    ReDim Bytes(1 To 10)
    
    Dim ActualCount As Long
    ActualCount = Encoding.GetBytesEx("", 0, 0, Bytes, 1)
    
    Assert.That ActualCount, Iz.EqualTo(0)
    Assert.That Bytes, Iz.All.EqualTo(0)
End Sub

Public Sub GetCharCount_WithNullArray_ThrowsArgumentNullException()
    Dim Encoding As New ASCIIEncoding
    Dim Bytes() As Byte
    
    On Error GoTo errTrap
    Encoding.GetCharCount Bytes
    
errTrap:
    AssertArgumentNullException Err, "Bytes"
End Sub

Public Sub GetCharCount_WithBytes_ReturnsExpected(ByRef Bytes() As Byte, ByVal Expected As Long)
    Dim Encoding As New ASCIIEncoding
    
    Dim Actual As Long
    Actual = Encoding.GetCharCount(Bytes)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub GetCharCount_WithIndexLessThanLBound_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    Dim Bytes(0 To 10) As Byte
    
    On Error GoTo errTrap
    Encoding.GetCharCount Bytes, -1, 1
    
errTrap:
    AssertArgumentOutOfRangeException Err, "Index"
End Sub

Public Sub GetCharCount_WithCountLessThanZero_ThrowsArgumentOutOfRangeException()
    Dim Encoding As New ASCIIEncoding
    Dim Bytes(0 To 10) As Byte
    
    On Error GoTo errTrap
    Encoding.GetCharCount Bytes, 0, -1
    
errTrap:
    AssertArgumentOutOfRangeException Err, "Count"
End Sub

Public Sub GetCharCount_WithMissingIndex_ThrowsArgumentException()
    Dim Encoding As New ASCIIEncoding
    Dim Bytes(0) As Byte
    
    On Error GoTo errTrap
    Encoding.GetCharCount Bytes, , 1
    
errTrap:
    AssertArgumentException Err, "Index"
End Sub

Public Sub GetCharCount_WithMissingCount_ThrowsArgumentException()
    Dim Encoding As New ASCIIEncoding
    Dim Bytes(0) As Byte
    
    On Error GoTo errTrap
    Encoding.GetCharCount Bytes, 0
    
errTrap:
    AssertArgumentException Err, "Count"
End Sub

Public Sub GetString_WithBytes_ReturnsExpected(ByRef Bytes() As Byte, ByVal Expected As String)
    Dim Encoding As New ASCIIEncoding
    
    Dim Actual As String
    Actual = Encoding.GetString(Bytes)
    
    Assert.That Actual, Iz.EqualTo(Expected)
End Sub

Public Sub TestGetString()
    Dim b(10) As Byte
    Dim i As Long
    
    For i = 0 To 9
        b(i) = 48 + i
    Next i
    b(10) = 237
    
    Assert.AreEqual "0123456789?", en.GetString(b)
End Sub

Public Sub TestGetStringWords()
    Dim b() As Byte
    b = Cor.NewBytes(&H48, &H65, &H6C, &H6C, &H6F, &H20, &H74, &H68, &H65, &H72, &H65)
    
    Dim s As String
    s = en.GetString(b)
    Assert.AreEqual "Hello there", s
End Sub

Public Sub TestGetStringFromPartOfArray()
    Dim b() As Byte
    b = StrConv("Now is the time for", vbFromUnicode)
    
    Assert.AreEqual "Now is t", en.GetString(b, 0, 8)
End Sub

