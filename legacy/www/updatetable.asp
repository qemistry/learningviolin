<% Response.Buffer = TRUE %>
<!-- #include file="globalinc.asp" -->
<%
pagelines = 10
%>
<!-- #include file="metainc.asp" -->
<! The side directory>
<!-- #include file="sidedirectoryinc.asp" -->
<! The Main Page Table>
<%
RequestURL = Request.ServerVariables("HTTP_REFERER")
TableName = Request.Form("TableName")
DbName = Request.Form("DBName")
Password = Request.Form("Password")
FieldCount = Request.Form("FieldCount")
RecordAction = Request.Form("RecordAction")
DeleteFlag = Request.Form("Delete")
If DeleteFlag = "True" Then
RecordAction = "Delete"
End If
dim i
FieldCount = CInt(FieldCount)
dim Fields(99)
i = 1
If Password = "1mamus1c" Then
j = 0
Do Until j = FieldCount
Fields(j) = Request.Form("Field"&j)
If Fields(j) = "" or IsNull(Fields(j)) Then
Fields(j) = " "
End If
j = j + 1
Loop
If RecordAction = "Add" Then
Set ATable = CreateObject("ADODB.Recordset")
ATable.Open TableName, "DSN=" & DBName & ";", 1, 3, 2
ATable.AddNew
j = 0
Do Until j = FieldCount
If ATable.Fields.Item(j).Name <> "ID" Then
If ATable.Fields.Item(j).Type = 11 Then
If Fields(j) = "1" Then
ATable.Fields.Item(j).Value = True
Else
ATable.Fields.Item(j).Value = False
End If
Else
ATable.Fields.Item(j).Value = Fields(j)
End If
End If
j = j + 1
Loop
ATable.Update
ATable.Close
End If
If RecordAction = "Delete" Then
Set ATable = CreateObject("ADODB.Recordset")
ATable.Open TableName, "DSN=" & DBName & ";"
j = 0
Do Until j = FieldCount
If ATable.Fields.Item(j).Name = "ID" Then
ID = Fields(j)
End If
j = j + 1
Loop
ATable.Close
Set ATable = CreateObject("ADODB.Recordset")
ATable.Open TableName & " WHERE ID=" & ID, "DSN=" & DBName & ";", 1, 3, 2
ATable.Delete
ATable.Close
End If
If RecordAction = "Update" Then
Set ATable = CreateObject("ADODB.Recordset")
ATable.Open TableName, "DSN=" & DBName & ";"
j = 0
Do Until j = FieldCount
If ATable.Fields.Item(j).Name = "ID" Then
ID = Fields(j)
End If
j = j + 1
Loop
ATable.Close
Set ATable = CreateObject("ADODB.Recordset")
ATable.Open TableName & " WHERE ID=" & ID, "DSN=" & DBName & ";", 1, 3, 2
j = 0
Do Until j = FieldCount
If ATable.Fields.Item(j).Name <> "ID" Then
If ATable.Fields.Item(j).Type = 11 Then
If Fields(j) = "1" Then
ATable.Fields.Item(j).Value = True
Else
ATable.Fields.Item(j).Value = False
End If
Else
ATable.Fields.Item(j).Value = Fields(j)
End If
End If
j = j + 1
Loop
ATable.Update
ATable.Close
End If
End If
Response.Redirect(RequestURL)
%>
<!-- #include file="bottominc.asp" -->
