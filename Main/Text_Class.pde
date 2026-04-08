class Text{
  int textIndex;
  int xCoor;
  int yCoor;
  boolean textDone;
  String text;
  
  public Text(String tempText, int x, int y){
    textIndex = 0;
    xCoor = x;
    yCoor = y;
    textDone = false;
    text = tempText;
  }
  
  void displayText(){
    if(textTimer % 5 == 0 && textIndex < text.length() && textDone == false){
      textDone = false;
      textIndex++;
    }
    text(text.substring(0, textIndex), xCoor, yCoor);
    if(textIndex >= text.length()){
      textDone = true;
    }
  }
  
  boolean checkDone(){
    return textDone;
  }
}
