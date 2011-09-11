<% Response.Buffer = TRUE %>
<!-- #include file="globalinc.asp" -->
<%
adOpenStatic = 3
adOpenDynamic = 2
adOpenKeyset = 1
Set FAQTable = CreateObject("ADODB.Recordset")
FAQTable.Open "SELECT * FROM FAQ ORDER BY FAQ_Number", "DSN=imamusic;", adOpenStatic
If NOT(FAQTable.EOF) Then
FAQTable.MoveLast
NumOfRecords = FAQTable.RecordCount
FAQTable.MoveFirst
End If
pagelines = NumOfRecords*7
%>
<!-- #include file="metainc.asp" -->
<! The side directory>
<!-- #include file="sidedirectoryinc.asp" -->
<! The Main Page Table>
Ask me any question you have about music, violin, or fiddle.
Below are some frequently asked questions and my answers.
To ask me your own question, <a href=mailto:ima@learningviolin.com>email me</a>.
<image src=ima6.jpg>
<%
i = 1
Do Until FAQTable.EOF
%>
<%=FAQTable.Fields("FAQ_Answer")%>
<%
FAQTable.MoveNext
i = i + 1
Loop
FAQTable.Close
%>
<!-- #include file="bottominc.asp" -->
