<% Response.Buffer = TRUE %>
<%
'Only one quiz for Ima
Session.Value("myquiz_QuizID") = 1
QuizID = 1
'Session.Value("myquiz_QuizID") = Request.QueryString("QuizID")
'QuizID = Session.Value("myquiz_QuizID")
'If QuizID="" or QuizID= null or QuizID = " " Then
'	Response.Redirect("myquizAllQuiz.asp")
'End If
Set AdminTable = CreateObject("ADODB.Recordset")
AdminTable.Open "SELECT DISTINCTROW TOP 1 * FROM QuizAdminOptions Where ID=" & QuizID, "DSN=imamusic;"
QuizTitle = AdminTable.Fields("QuizTitle")
QuizDesc = AdminTable.Fields("QuizDescription")
QuizBackground = AdminTable.Fields("Background")
QuizImage = AdminTable.Fields("QuizImage")
QuizAllowQ = AdminTable.Fields("AllowQuestions")
QuizAllowComments = AdminTable.Fields("AllowComments")
QuizAllowProtests = AdminTable.Fields("AllowProtests")
QuizHardScore = AdminTable.Fields("HardScore")
QuizMediumScore = AdminTable.Fields("MediumScore")
QuizEasyScore = AdminTable.Fields("EasyScore")
QuizWebMaster = AdminTable.Fields("WebmasterName")
QuizWebMasterEmail = AdminTable.Fields("WebmasterEmail")
QuizTopScores = AdminTable.Fields("ShowTopScores")
QuizRecentScores = AdminTable.Fields("ShowRecentScores")
AdminTable.Close
%>
<%
adOpenStatic = 3
adOpenDynamic = 2
adOpenKeyset = 1
%>
<!-- #include file="globalinc.asp" -->
<%
pagelines = 40
%>
<!-- #include file="metainc.asp" -->
<! The side directory>
<!-- #include file="sidedirectoryinc.asp" -->
<! The Main Page Table>
<img src=musicquiz.gif>
Test your musical knowledge by playing this fun game.
<form action="myquiz.asp"
method="POST">
<input type="radio" name="playlevel" value="E"> Easy
<input type="radio" name="playlevel" value="M"> Medium
<input type="radio" name="playlevel" value="H"> Hard
<input type="radio" name="playlevel" value="X" checked> Mix it Up
<input type="submit" value="Let's Play!">
</form>
<%
if QuizAllowQ = true then
%>
Challenge your friends.
<a href=myquiznewq.asp>Submit your own question to the game.</a>
<%
Set RecentQTable = CreateObject("ADODB.Recordset")
RecentQTable.Open "SELECT DISTINCTROW TOP 1 * FROM Quiz WHERE QuizID = " & QuizID & " ORDER BY SubmittedDate DESC", "DSN=imamusic;"
If Not RecentQTable.EOF Then
SubmittedDate = Server.HTMLEncode(RecentQTable.Fields("SubmittedDate") & "" )
ThanksTo = Server.HTMLEncode(RecentQTable.Fields("ThanksTo") & "" )
If SubmittedDate = "" or IsNull(SubmittedDate) Then
SubmittedDate = "Unknown"
End If
If ThanksTo = " " or ThanksTo = "" or IsNull(ThanksTo) Then
ThanksTo = "QuizMaster"
End If
%>
<%
if ThanksTo <> "QuizMaster" Then
%>
<i>by <%=ThanksTo%></i>
<%
End If
End If
RecentQTable.Close
end if
if QuizTopScores > 0 Then
%>
<%
Set TopPlayerTable = CreateObject("ADODB.Recordset")
TopPlayerTable.Open "SELECT DISTINCT TOP " &
QuizTopScores & " Player, Max(Score) AS MaxScore, Max(Date) as MaxDate FROM QuizPlayers WHERE Now() - Date <=1 and QuizID = " & QuizID & " GROUP BY Player ORDER BY Max(Score) DESC, Max(Date) DESC", "DSN=imamusic;"
dim i
i = 1
Do Until TopPlayerTable.EOF or i>QuizTopScores
%>
<%
TopPlayerTable.MoveNext
i = i + 1
Loop
%>
<%
TopPlayerTable.Close
end if
if QuizRecentScores > 0 Then
%>
<%
Set RecentPlayerTable = CreateObject("ADODB.Recordset")
RecentPlayerTable.Open "SELECT DISTINCTROW TOP " & QuizRecentScores & " * FROM QuizPlayers Where QuizID =" & QuizID & " ORDER BY Date DESC", "DSN=imamusic;"
i = 1
Do Until RecentPlayerTable.EOF
%>
<%
RecentPlayerTable.MoveNext
i = i + 1
Loop
RecentPlayerTable.Close
%>
<%
end if
%>
<!-- #include file="bottominc.asp" -->
