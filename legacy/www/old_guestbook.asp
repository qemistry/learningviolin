<% Response.Buffer = TRUE %>
<!-- #include file="globalinc.asp" -->
<%
adOpenStatic = 3
adOpenDynamic = 2
adOpenKeyset = 1
Set GBTable = CreateObject("ADODB.Recordset")
GBTable.Open "SELECT * FROM Communityk ORDER BY ID Desc", "DSN=imamusic;", adOpenStatic
If NOT(GBTable.EOF) Then
GBTable.MoveLast
NumOfRecords = GBTable.RecordCount
GBTable.MoveFirst
End If
pagelines = NumOfRecords*10
%>
<!-- #include file="metainc.asp" -->
<! The side directory>
<!-- #include file="sidedirectoryinc.asp" -->
<! The Main Page Table>
<a href=signcommunityform.asp>Add your own comment</a>
<%
i = 1
Do Until GBTable.EOF
dim webPage
webPage = GBTable.Fields("Homepage")
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
