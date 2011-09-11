<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<% Response.Buffer = TRUE %>
<!-- #include file="globalinc.asp" -->
<%
adOpenStatic = 3
adOpenDynamic = 2
adOpenKeyset = 1
Set GBTable = CreateObject("ADODB.Recordset")
GBTable.Open "SELECT * FROM GuestBook ORDER BY ID Desc", "DSN=imamusic;", adOpenStatic
If NOT(GBTable.EOF) Then
GBTable.MoveLast
NumOfRecords = GBTable.RecordCount
GBTable.MoveFirst
End If
pagelines = NumOfRecords*10
%>
<!-- #include file="metainc.asp" -->
<! The Main Page Table>
<a href=signguestbookform.asp>Sign the GuestBook</a>
<%
i = 1
Do Until GBTable.EOF
dim webPage
webPage = GBTable.Fields("GuestBook_Homepage")
if not instr(webPage, "http://") > 0 then
webPage = "http://" & webPage
end if
%>
<%
GBTable.MoveNext
i = i + 1
Loop
GBTable.Close
%>
<!-- #include file="bottominc.asp" -->
