package games;
import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import java.io.*;
import java.net.*;
/**
* Insert the type's description here.
* Creation date: (3/3/00 7:12:40 PM)
* @author:
*/
public class HangMozart
extends java.applet.Applet
implements Runnable, MouseListener, KeyListener {
/* This is the maximum number of incorrect guesses. */
final int maxTries = 5;
/* This is the maximum length of a secret word. */
final int maxWordLen = 999;
/* This buffer holds the letters in the secret word. */
char secretWord[];
int increment;
int lastID;
/* This buffer holds the hint of the secret word. */
String hint;
/* This is the length of the secret word. */
int secretWordLen;
/* This is the length of the secret word. */
Label gameMessage = new Label();
/* This is the length of the secret word. */
Label authorMessage = new Label();
/* This is the length of the secret word. */
Label gameStats = new Label();
/* This buffer holds the letters which the user typed
but don't appear in the secret word. */
char wrongLetters[];
/* This is the current number of incorrect guesses. */
int wrongLettersCount;
/* This buffer holds letters that the user has successfully
guessed. */
char word[];
/* Number of correct letters in 'word'. */
int wordLen;
/* Number of words in the word list. */
int numberWords;
/* This is the font used to paint correctly guessed letters. */
Font wordFont;
FontMetrics wordFontMetrics;
/* This is the MediaTracker that looks after loading the images. */
MediaTracker tracker;
/* These are the various classes of images we load */
final int DANCECLASS = 0;
final int HANGCLASS = 1;
/* This is the sequence of images for Duke hanging on the gallows. */
Image hangImages[];
final int hangImagesWidth = 108;
final int hangImagesHeight = 231;
// Dancing Duke related variables
/* This thread makes Mozart dance. */
Thread danceThread;
/* These are the images that make up the dance animation. */
Image danceImages[];
private int //danceImageWidths[] = { 70, 85, 87, 90, 87, 85, 70 };
danceImageWidths[] = {108, 108, 108, 108, 108, 108};
/* This is the maximum width and height of all the dance images. */
int danceHeight = 250;
/* This variable holds the number of valid images in danceImages. */
int danceImagesLen = 0;
/* These offsets refer to the dance images.
The dance images
are not of the same size so we need to add these offset
in order to make the images "line" up. */
private int danceImageOffsets[] = { 0, 0, 0, 0, 0, 0, 0 };
private int ladNumber=0;
/* This represents the sequence to display the dance images
in order to make lad "dance".
*/
private int danceSequence[] = { 1, 2, 3, 2, 3, 2, 3, 4, 4, 4, 3,
4, 3, 2, 1, 0, 1, 2, 3, 4, 3, 2, 1 };
/* This is the current sequence number.
-1 implies
that lad hasn't begun to dance. */
int danceSequenceNum = -1;
/* This variable is used to adjust lad's x-position while
he's dancing. */
int danceX = 0;
/* This variable specifies the currently x-direction of
lad's dance.
1=>right and -1=>left. */
int danceDirection = 1;
/* This is the hangman's limited word list. */
String wordlist[]= new String[999];
int wordnumber;
/* This is the hangman's author word list. */
String authorlist[]= new String[999];
String backupwordlist[] = {
"violin",
"fiddle",
"bow",
"downbow",
"upbow",
"frog",
"treble clef",
"minor key",
"major key",
"vibratto",
"bridge"
};
String hintlist[] = new String[999];
String backuphintlist[] = {
"classical instrument",
"same as a violin",
"fiddle stick",
"frog to tip",
"tip to frog",
"lower part of the bow",
"same as G, and not bass",
"example is 3rd flatted",
"example is C, no sharps no flats",
"advanced violin technique",
"part of the violin"
};
String backupauthorlist[] = {
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
};
public int spaceCount;
public int gamesPlayed=0;
public int gamesWon=0;
public Button newgameButton = new Button("New Game");
public Button hintButton = new Button("Hint");
//Set action listeners for each of the command buttons
public void buttonListeners(){
newgameButton.addActionListener(new ActionListener() {
public void actionPerformed(ActionEvent e) {
requestFocus();
newGame();
}
});
hintButton.addActionListener(new ActionListener() {
public void actionPerformed(ActionEvent e) {
requestFocus();
gameMessage.setText(hint);
repaint();
}
});
}
// Added by Kevin A. Smith 10/25/95
public String getAppletInfo() {
return "Author: Patrick Chan\nVersion 1.5 Modifed by Michele Determan";
}
/**
* Initialize the applet. Resize and load images.
*/
public void init() {
this.setBackground(Color.white);
int i;
// create tracker
tracker = new MediaTracker(this);
// load in dance animation
//danceMusic = getAudioClip(getDocumentBase(), "audio/dance.au");
danceImages = new Image[40];
for (i = 1; i < 6; i++) {
Image im = getImage(getDocumentBase(), "games/hld" + i + ".gif");
tracker.addImage(im, DANCECLASS);
danceImages[danceImagesLen++] = im;
}
/*	for (i = 1; i < 6; i++) {
Image im = getImage(getDocumentBase(), "games/hldmike" + i + ".gif");
tracker.addImage(im, DANCECLASS);
danceImages[danceImagesLen++] = im;
}
for (i = 1; i < 6; i++) {
Image im = getImage(getDocumentBase(), "games/hlddave" + i + ".gif");
tracker.addImage(im, DANCECLASS);
danceImages[danceImagesLen++] = im;
}
for (i = 1; i < 6; i++) {
Image im = getImage(getDocumentBase(), "games/hldjian" + i + ".gif");
tracker.addImage(im, DANCECLASS);
danceImages[danceImagesLen++] = im;
}
*/
// load in hangman image sequnce
hangImages = new Image[maxTries*4];
for (i=0; i<maxTries; i++) {
Image im = getImage(this.getDocumentBase(), "games/hl" + (i+1) + ".gif");
tracker.addImage(im, HANGCLASS);
hangImages[i] = im;
}
/*
for (i=0; i<maxTries; i++) {
Image im = getImage(this.getDocumentBase(), "games/hlmike" + (i+1) + ".gif");
tracker.addImage(im, HANGCLASS);
hangImages[i+maxTries] = im;
}
for (i=0; i<maxTries; i++) {
Image im = getImage(this.getDocumentBase(), "games/hldave" + (i+1) + ".gif");
tracker.addImage(im, HANGCLASS);
hangImages[i+maxTries*2] = im;
}
for (i=0; i<maxTries; i++) {
Image im = getImage(this.getDocumentBase(), "games/hljian" + (i+1) + ".gif");
tracker.addImage(im, HANGCLASS);
hangImages[i+maxTries*3] = im;
}
*/
// initialize the word buffers.
wrongLettersCount = 0;
wrongLetters = new char[maxTries];
secretWordLen = 0;
secretWord = new char[maxWordLen];
word = new char[maxWordLen];
wordFont = new java.awt.Font("Courier", Font.BOLD, 24);
wordFontMetrics = getFontMetrics(wordFont);
resize((maxWordLen+1) * wordFontMetrics.charWidth('M') + maxWordLen * 3,
hangImagesHeight * 2 + wordFontMetrics.getHeight());
this.setLayout(null);
newgameButton.setBounds(300, 40, 75, 25);
hintButton.setBounds(300, 70, 75, 25);
gameMessage.setBounds(300, 100, 300, 20);
gameStats.setBounds(300, 10, 200, 20);
authorMessage.setBounds(300, 120, 300, 20);
gameMessage.setText("Guess a letter a-z");
this.add(gameStats);
this.add(newgameButton);
this.add(hintButton);
this.add(gameMessage);
this.add(authorMessage);
authorMessage.setText(" ");
addMouseListener(this);
addKeyListener(this);
buttonListeners();
//Get words from database
String siteURL = "readtable.asp?db=imamusic&table=hangwords&password=imamusic&field=Phrase&PN1=Reviewed&PO1==&P1=true";
try {
URL url = new URL(this.getDocumentBase(), siteURL);
URLConnection connection = url.openConnection();
connection.setDoInput( true );
BufferedReader input =
new BufferedReader(
new InputStreamReader(
connection.getInputStream()));
i = 0;
String line;
while ((line = input.readLine()) != null) {
wordlist[i] = line;
i++;
//System.out.println(line);
}
numberWords = i-1;
input.close();
}
catch( Exception e ) {
wordlist = backupwordlist;
hintlist = backuphintlist;
authorlist = backupauthorlist;
numberWords = backupwordlist.length;
}
siteURL = "readtable.asp?db=imamusic&table=hangwords&password=imamusic&field=Hint&PN1=Reviewed&PO1==&P1=true";
try {
URL url = new URL(this.getDocumentBase(), siteURL);
URLConnection connection = url.openConnection();
connection.setDoInput( true );
BufferedReader input =
new BufferedReader(
new InputStreamReader(
connection.getInputStream()));
i = 0;
String line;
while ((line = input.readLine()) != null) {
hintlist[i] = line;
i++;
//System.out.println(line);
}
numberWords = i-1;
input.close();
}
catch( Exception e ) {
wordlist = backupwordlist;
hintlist = backuphintlist;
authorlist = backupauthorlist;
numberWords = backupwordlist.length;
}
siteURL = "readtable.asp?db=imamusic&table=hangwords&password=imamusic&field=SuggestedBy&PN1=Reviewed&PO1==&P1=true";
try {
URL url = new URL(this.getDocumentBase(), siteURL);
URLConnection connection = url.openConnection();
connection.setDoInput( true );
BufferedReader input =
new BufferedReader(
new InputStreamReader(
connection.getInputStream()));
i = 0;
String line;
while ((line = input.readLine()) != null) {
authorlist[i] = line;
i++;
}
numberWords = i-1;
input.close();
}
catch( Exception e ) {
authorlist = backupauthorlist;
}
/*
wordlist = backupwordlist;
hintlist = backuphintlist;
authorlist = backupauthorlist;
numberWords = backupwordlist.length;
*/
wordnumber = (int)Math.floor(Math.random() * numberWords);
int UseInc;
int UseIncArray[] = {
357437, 357473, 357503, 357509, 357517, 357551, 357559, 357563, 357569, 357571};
lastID = wordnumber;
UseInc = (int)Math.floor(Math.random() * 9);
increment = UseIncArray[UseInc];
}
/* key tracking methods */
public void keyPressed(KeyEvent e) {
}
public void keyReleased(KeyEvent e) {
int i;
boolean found = false;
char key = e.getKeyChar();
// start new game if user has already won or lost.
if (secretWordLen-spaceCount == wordLen || wrongLettersCount == maxTries) {
newGame();
e.consume();
return;
}
// check if valid letter
if (key < 'a' || key > 'z') {
gameMessage.setText("Guess a letter a-z");
e.consume();
return;
}
// check if already in secret word
for (i=0; i<secretWordLen; i++) {
if (key == word[i]) {
found = true;
gameMessage.setText("You already guessed that letter");
e.consume();
return;
}
}
// check if already in wrongLetters
if (!found) {
for (i=0; i<maxTries; i++) {
if (key == wrongLetters[i]) {
found = true;
gameMessage.setText("You already guessed that letter");
e.consume();
return;
}
}
}
// is letter in secret word? If so, add it.
if (!found) {
for (i=0; i<secretWordLen; i++) {
if (key == secretWord[i]) {
word[i] = (char)key;
wordLen++;
found = true;
}
}
if (found) {
if (wordLen == secretWordLen-spaceCount) {
gameMessage.setText("Congratulations! You won!");
gamesWon++;
startLadDancing();
} else {
}
}
}
// wrong letter; add to wrongLetters
if (!found) {
if (wrongLettersCount < wrongLetters.length) {
wrongLetters[wrongLettersCount++] = (char)key;
if (wrongLettersCount < maxTries) {
} else {
gameMessage.setText("Sorry.
You lost this game.");
// show the answer
for (i=0; i<secretWordLen; i++) {
word[i] = secretWord[i];
}
}
}
}
if (wordLen == secretWordLen-spaceCount) {
danceSequenceNum = -1;
}
repaint();
e.consume();
return;
}
public void keyTyped(KeyEvent e) {
}
/* mouse tracking methods */
public void mouseClicked(MouseEvent e) {
}
public void mouseEntered(MouseEvent e) {
}
public void mouseExited(MouseEvent e) {
}
/**
* Grab the focus and restart the game.
*/
public void mousePressed(MouseEvent e) {
int i;
// grab focus to get keyDown events
requestFocus();
if (secretWordLen > 0 &&
(secretWordLen-spaceCount == wordLen || wrongLettersCount == maxTries)) {
newGame();
} else {
}
e.consume();
}
public void mouseReleased(MouseEvent e) {
}
/**
* Starts a new game.
Chooses a new secret word
* and clears all the buffers
*/
public void newGame() {
int i;
gamesPlayed++;
spaceCount = 0;
/* Only one image for this game
ladNumber++;
if (ladNumber > 3) {
ladNumber = 0;
}*/
ladNumber = 0;
gameMessage.setText("Guess a letter a-z");
// stop animation thread.
danceThread = null;
// pick secret word
wordnumber = (increment+lastID) % (numberWords);
lastID = wordnumber;
String s = wordlist[wordnumber];
hint = hintlist[wordnumber];
secretWordLen = Math.min(s.length(), maxWordLen);
for (i=0; i<secretWordLen; i++) {
secretWord[i] = s.charAt(i);
if (secretWord[i] == ' ') {
spaceCount++;
}
}
authorMessage.setText(" ");
if (authorlist[wordnumber].length() > 1 ) {
authorMessage.setText("Suggested by : " + authorlist[wordnumber]);
}
// clear word buffers
for (i=0; i<maxWordLen; i++) {
word[i] = 0;
}
wordLen = 0;
for (i=0; i<maxTries; i++) {
wrongLetters[i] = 0;
}
wrongLettersCount = 0;
repaint();
}
/**
* Paint the screen.
*/
public void paint(Graphics g) {
int imageW = hangImagesWidth;
int imageH = hangImagesHeight;
int baseH = 10;
int baseW = 30;
Font font;
FontMetrics fontMetrics;
int i, x, y;
gameStats.setText("You've won " + gamesWon + " out of " + gamesPlayed + " games");
// draw gallows pole
g.drawLine(baseW/2, 0, baseW/2, 2*imageH - baseH/2);
g.drawLine(baseW/2, 0, baseW+imageW/2, 0);
// draw gallows rope
g.drawLine(baseW+imageW/2, 0, baseW+imageW/2, imageH/3);
// draw gallows base
g.fillRect(0, 2*imageH-baseH, baseW, baseH);
// draw list of wrong letters
font = new java.awt.Font("Courier", Font.PLAIN, 15);
fontMetrics = getFontMetrics(font);
x = imageW + baseW;
y = fontMetrics.getHeight();
g.setFont(font);
g.setColor(Color.red);
for (i=0; i<wrongLettersCount; i++) {
g.drawChars(wrongLetters, i, 1, x, y);
x += fontMetrics.charWidth(wrongLetters[i])
+ fontMetrics.charWidth(' ');
}
if (secretWordLen > 0) {
// draw underlines for secret word
int Mwidth = wordFontMetrics.charWidth('M');
int Mheight = wordFontMetrics.getHeight();
g.setFont(wordFont);
g.setColor(Color.black);
x = 0;
y = getSize().height - 20;
for (i=0; i<secretWordLen; i++) {
if (secretWord[i] != ' ') {
g.drawLine(x, y, x + Mwidth, y);
}
x += Mwidth + 3;
}
// draw known letters in secret word
x = 0;
y = getSize().height - 22;
g.setColor(Color.blue);
for (i=0; i<secretWordLen; i++) {
if (word[i] != 0) {
g.drawChars(word, i, 1, x, y);
}
x += Mwidth + 3;
}
if (wordLen < secretWordLen-spaceCount && wrongLettersCount > 0) {
// draw lad on gallows
g.drawImage(hangImages[wrongLettersCount-1+(ladNumber*maxTries)],
baseW, imageH/3, this);
}
}
}
/**
* Run dancing animation. This method is called by class Thread.
* @see java.lang.Thread
*/
public void run() {
try {
tracker.waitForID(DANCECLASS);
} catch (InterruptedException e) {
}
Thread.currentThread().setPriority(Thread.MIN_PRIORITY);
// start the dancing music.
//danceMusic.loop();
// increment the sequence count and invoke the paint method.
while (getSize().width > 0 && getSize().height > 0 && danceThread != null) {
repaint();
try {Thread.sleep(100);} catch (InterruptedException e){}
}
// The dance is done so stop the music.
//danceMusic.stop();
}
/**
* Start the applet.
*/
public void start() {
requestFocus();
try {
tracker.waitForID(HANGCLASS);
} catch (InterruptedException e) {}
tracker.checkAll(true);
// Start a new game only if user has won or lost; otherwise
// retain the same game.
if (secretWordLen == wordLen || wrongLettersCount == maxTries) {
newGame();
}
}
/**
* Starts Lad dancing animation.
*/
private void startLadDancing () {
if (danceThread == null) {
danceThread = new Thread(this);
danceThread.start();
}
}
/**
* Stop the applet.
Stop the danceThread.
*/
public void stop() {
danceThread = null;
}
public void update(Graphics g) {
if (wordLen == 0) {
g.clearRect(0, 0, getSize().width, getSize().height);
paint(g);
} else if (wordLen == secretWordLen-spaceCount) {
if (danceSequenceNum < 0) {
g.clearRect(0, 0, getSize().width, getSize().height);
paint(g);
danceSequenceNum = 0;
}
updateDancingLad(g);
} else {
paint(g);
}
}
void updateDancingLad(Graphics g) {
int baseW = 30;
int imageH = hangImagesHeight;
int danceImageNum = danceSequence[danceSequenceNum];
// first, clear Lad's current image
g.clearRect(danceX+baseW, imageH*2 - danceHeight,
danceImageOffsets[danceImageNum]+danceImageWidths[danceImageNum],
danceHeight);
// update dance position
danceX += danceDirection;
if (danceX < 0) {
danceX = danceDirection = (int)Math.floor(Math.random() * 12) + 5;
} else if (danceX + baseW > getSize().width / 2) {
//danceDirection = -(int)Math.floor(Math.random() * 12) - 5;
danceDirection *= -1;
} else if (Math.random() > .9f) {
danceDirection *= -1;
}
// update dance sequence
danceSequenceNum++;
if (danceSequenceNum >= danceSequence.length) {
danceSequenceNum = 0;
}
// now paint lad's new image
danceImageNum = danceSequence[danceSequenceNum];
if ((danceImageNum < danceImagesLen) && (danceImages[danceImageNum+(ladNumber*5)] != null)) {
g.drawImage(danceImages[danceImageNum+(ladNumber*5)],
danceX+baseW+danceImageOffsets[danceImageNum],
imageH*2 - danceHeight, this);
}
}
}
