<% Response.Buffer = TRUE %>
<!-- #include file="globalinc.asp" -->
<%
adOpenStatic = 3
adOpenDynamic = 2
adOpenKeyset = 1
Set GigTable = CreateObject("ADODB.Recordset")
GigTable.Open "SELECT * FROM Gig ORDER BY Gig_Date", "DSN=imamusic;", adOpenStatic
If NOT(GigTable.EOF) Then
GigTable.MoveLast
NumOfRecords = GigTable.RecordCount
GigTable.MoveFirst
End If
pagelines = NumOfRecords*5+15
%>
<!-- #include file="metainc.asp" -->
<! The Main Page Table>
&Iacute;ma Jonsdottir
Telephone: (617) 734-3599
Fax: (617) 266-7643
Email: <a href=mailto:ima@learningviolin.com>ima@learningviolin.com</a>
<img src=imaprosmall.jpg>
www.andromeda4.com
</a>or <a href="http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewAlbum?playListId=115172107" target="_blank">iTunes</a>&nbsp;for
my latest CD
<%
i = 1
Do Until GigTable.EOF
%>
<%=GigTable.Fields("Gig_Description")%>
<%
GigTable.MoveNext
i = i + 1
Loop
GigTable.Close
if i = 1 then
%>
No Upcoming Gigs.
Please check back later.
<%
end if
%>
<!-- #include file="bottominc.asp" -->
