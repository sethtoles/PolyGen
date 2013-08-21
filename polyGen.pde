boolean averageColorBackground = false; //if this is set to true, the default background color will be the average color of all pixels in the image. otherwise, it will be whatever is set

int imageWidth = 800;
int imageHeight = 800;

PImage masterImage;

int bgRed = 255;
int bgGreen = 255;
int bgBlue = 255;
int polyCount = 50;
int vertCount = 0;

int iteration = 0;

int imageAverageRed = 0;
int imageAverageGreen = 0;
int imageAverageBlue = 0;

long fitNew = 0;
long fitOld = 0;

int currentVert = 0;

int totalMutations = 0;
int desirableMutations = 0;

BufferedReader tracking;
BufferedReader input;

String line;
PrintWriter output;
PrintWriter tracker;


int[] redVal = new int[polyCount];
int[] greenVal = new int[polyCount];
int[] blueVal = new int[polyCount];
int[] alphaVal = new int[polyCount];
int[] vertList = new int[polyCount];
int[] verticesX = new int[0];
int[] verticesY = new int[0];

int vertCountP = 0;                   ///////these are all the parent variables - one for each image variable required for generation. the parent's genes are stored in these
int polyCountP = 0;

int[] redValP = new int[polyCount];
int[] greenValP = new int[polyCount];
int[] blueValP = new int[polyCount];
int[] alphaValP = new int[polyCount];
int[] vertListP = new int[polyCount];
int[] verticesXP = new int[0];
int[] verticesYP = new int[0];


////////////////////////////////////////////////////////////////////////////////METHODS

void createPolygons(int polygons){
  if (polyCount<polygons){
    for (int i=polyCount; i<polygons; i++){
      addPolygon();
    }
  }
  if (polyCount>polygons){
    for (int i=polyCount; i>polygons; i++){
      removePolygon();
    }
  }
}

void setColors(){
  for (int i=0; i<polyCount; i++){
    redVal[i] = (int)random(256);
    greenVal[i] = (int)random(256);
    blueVal[i] = (int)random(256);
    alphaVal[i] = (int)random(256);
  }
}

void numberVertices(){
  vertCount = 0;
  for (int i=0; i<polyCount; i++){
    int rand = (int)random(3,6);
    vertList[i] = rand;
    vertCount += rand;
  }
}

void setVertices(){
  for (int i=0; i<vertCount; i++){
    verticesX = append(verticesX, (int)random(imageWidth));
    verticesY = append(verticesY, (int)random(imageHeight));
  }
}

void resetAll(){
  createPolygons(50);
  setColors();
  numberVertices();
  setVertices();
}

void addPolygon(){
  int newVerts = (int)random(3,6);
  vertList = append(vertList, newVerts);
  for (int i=0; i<newVerts; i++){
    verticesX = append(verticesX, (int)random(imageWidth));
    verticesY = append(verticesY, (int)random(imageHeight));
  }
  redVal = append(redVal, (int)random(256));
  greenVal = append(greenVal, (int)random(256));
  blueVal = append(blueVal, (int)random(256));
  alphaVal = append(alphaVal, (int)random(256));
  vertCount += newVerts;
  polyCount++;
}

void removePolygon(){
  if (polyCount > 1){
    for (int i=0; i<vertList[polyCount-1]; i++){
     verticesX = shorten(verticesX);
     verticesY = shorten(verticesY);
   }
   redVal = shorten(redVal);
   greenVal = shorten(greenVal);
   blueVal = shorten(blueVal);
   alphaVal = shorten(alphaVal);
   vertCount -= vertList[polyCount-1];
   vertList = shorten(vertList);
   polyCount--;
  }
}
  
void moveToEnd(int polyNumber){
  int[] vertStoreX = new int[vertList[polyNumber]];
  int[] vertStoreY = new int[vertList[polyNumber]];
  int[] vertCopy = new int[vertCount];
  int[] polyCopy = new int[polyCount];
  
  int temp = 0;
  int vertNumber = 0;
  for (int i=0; i<polyNumber; i++){
    for (int j=0; j<vertList[i]; j++){
      vertNumber++;
    }
  }
  
  for (int i=0; i<vertList[polyNumber]; i++){
    vertStoreX[i] = verticesX[vertNumber+i];
    vertStoreY[i] = verticesY[vertNumber+i];
  }
  
  arrayCopy(verticesX, 0, vertCopy, 0, vertNumber);
  arrayCopy(verticesX, vertNumber+vertList[polyNumber], vertCopy, vertNumber, vertCount-vertNumber-vertList[polyNumber]);
  arrayCopy(vertStoreX, 0, vertCopy, vertCount-vertList[polyNumber], vertList[polyNumber]);
  arrayCopy(vertCopy, verticesX);

  arrayCopy(verticesY, 0, vertCopy, 0, vertNumber);
  arrayCopy(verticesY, vertNumber+vertList[polyNumber], vertCopy, vertNumber, vertCount-vertNumber-vertList[polyNumber]);
  arrayCopy(vertStoreY, 0, vertCopy, vertCount-vertList[polyNumber], vertList[polyNumber]);
  arrayCopy(vertCopy, verticesY);
  
  temp = vertList[polyNumber];
  arrayCopy(vertList, 0, polyCopy, 0, polyNumber);
  arrayCopy(vertList, polyNumber+1, polyCopy, polyNumber, polyCount-polyNumber-1);
  polyCopy[polyCount-1] = temp;
  arrayCopy(polyCopy, vertList);
  
  temp = redVal[polyNumber];
  arrayCopy(redVal, 0, polyCopy, 0, polyNumber);
  arrayCopy(redVal, polyNumber+1, polyCopy, polyNumber, polyCount-polyNumber-1);
  polyCopy[polyCount-1] = temp;
  arrayCopy(polyCopy, redVal);
  
  temp = greenVal[polyNumber];
  arrayCopy(greenVal, 0, polyCopy, 0, polyNumber);
  arrayCopy(greenVal, polyNumber+1, polyCopy, polyNumber, polyCount-polyNumber-1);
  polyCopy[polyCount-1] = temp;
  arrayCopy(polyCopy, greenVal);
  
  temp = blueVal[polyNumber];
  arrayCopy(blueVal, 0, polyCopy, 0, polyNumber);
  arrayCopy(blueVal, polyNumber+1, polyCopy, polyNumber, polyCount-polyNumber-1);
  polyCopy[polyCount-1] = temp;
  arrayCopy(polyCopy, blueVal);
  
  temp = alphaVal[polyNumber];
  arrayCopy(alphaVal, 0, polyCopy, 0, polyNumber);
  arrayCopy(alphaVal, polyNumber+1, polyCopy, polyNumber, polyCount-polyNumber-1);
  polyCopy[polyCount-1] = temp;
  arrayCopy(polyCopy, alphaVal);
}

void changeColor(int polyNumber){
  redVal[polyNumber] = (int)random(256);
  greenVal[polyNumber] = (int)random(256);
  blueVal[polyNumber] = (int)random(256);
}

void changeAlpha(int polyNumber){
  alphaVal[polyNumber] = (int)random(256);
}

void changePosition(int polyNumber){
  int vertNumber = 0;
  for (int i=0; i<polyNumber; i++){
    for (int j=0; j<vertList[i]; j++){
      vertNumber++;
    }
  }
  int changeX = (int)random(imageWidth)-verticesX[vertNumber];
  int changeY = (int)random(imageHeight)-verticesY[vertNumber];
  for (int i=0; i<vertList[polyNumber]; i++){
    verticesX[vertNumber+i] += changeX;
    verticesY[vertNumber+i] += changeY;
  }
}

void swapVertex(int vertex1,int vertex2){
  int tempX = verticesX[vertex1];
  int tempY = verticesY[vertex1];
  verticesX[vertex1] = verticesX[vertex2];
  verticesY[vertex1] = verticesY[vertex2];
  verticesX[vertex2] = tempX;
  verticesY[vertex2] = tempY;
}

void changeVertex(int vertNumber){
  verticesX[vertNumber] = (int)random(imageWidth);
  verticesY[vertNumber] = (int)random(imageHeight);
}

void mutate(){
  
    int select = (int)random(7);
    
    if (select == 6){
      addPolygon();
    }
    if (select == 7) {
      removePolygon();
    }
    if (select == 0) {
      moveToEnd((int)random(polyCount));
    }
    if (select == 1) {
      changePosition((int)random(polyCount));
    }
    if (select == 2) {
      changeColor((int)random(polyCount));
    }
    if (select == 3) {
      changeAlpha((int)random(polyCount));
    }
    if (select == 4) {
      changeVertex((int)random(vertCount));
    }
    if (select == 5) {
      swapVertex((int)random(vertCount),(int)random(vertCount));
    }
}

////////////////////////////////////////////////////////////////////////////////SETUP
 void setup(){
  frameRate(100);
  PImage masterImage = loadImage("masterImage.jpg");
  masterImage.loadPixels();
  imageWidth = masterImage.width;
  imageHeight = masterImage.height;
  
  if(averageColorBackground == true){
  for (int i=0; i<imageWidth*imageHeight; i++){
    imageAverageRed += (masterImage.pixels[i] >> 16) & 0xFF;
    imageAverageGreen += (masterImage.pixels[i] >> 8) & 0xFF;
    imageAverageBlue += (masterImage.pixels[i] & 0xFF);
  }
    bgRed = imageAverageRed / (imageWidth*imageHeight+1);
    bgGreen = imageAverageGreen / (imageWidth*imageHeight+1);
    bgBlue = imageAverageBlue / (imageWidth*imageHeight+1);
}

  size(imageWidth, imageHeight);
  background(bgRed, bgGreen, bgBlue);
  noStroke();
  tracking = createReader("started.txt");
  try {
    line = tracking.readLine(); 
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  iteration = Integer.parseInt(line);
  if(iteration == 1){
    inputDNA();
  }
  else {
    resetAll();
  }
  writeParent();
}

void writeParent(){ //create parent from new genes
  redValP = new int[redVal.length];
  arraycopy(redVal, redValP);
  greenValP = new int[greenVal.length];
  arraycopy(greenVal, greenValP);
  blueValP = new int[blueVal.length];
  arraycopy(blueVal, blueValP);
  alphaValP = new int[alphaVal.length];
  arraycopy(alphaVal, alphaValP);
  vertListP = new int[vertList.length];
  arraycopy(vertList, vertListP);
  verticesXP = new int[verticesX.length];
  arraycopy(verticesX,verticesXP);
  verticesYP = new int[verticesY.length];
  arraycopy(verticesY, verticesYP);
  polyCountP = polyCount;
  vertCountP = vertCount;
}
void readParent(){ //recall parent from old genes
  redVal = new int[redValP.length];
  arraycopy(redValP, redVal);
  greenVal = new int[greenValP.length];
  arraycopy(greenValP, greenVal);
  blueVal = new int[blueValP.length];
  arraycopy(blueValP, blueVal);
  alphaVal = new int[alphaValP.length];
  arraycopy(alphaValP, alphaVal);
  vertList = new int[vertListP.length];
  arraycopy(vertListP, vertList);
  verticesX = new int[verticesXP.length];
  arraycopy(verticesXP,verticesX);
  verticesY = new int[verticesYP.length];
  arraycopy(verticesYP, verticesY);
  polyCount = polyCountP;
  vertCount = vertCountP;
  }

void inputDNA(){ //input an old DNA file if it exists in the directory so you can continue from where you left off
  input = createReader("dna.txt");
    try {
      line = input.readLine();
      polyCount = Integer.parseInt(line);
      if (polyCount<50){
        for (int i=0; i<50-polyCount; i++){
          redVal = shorten(redVal);
          greenVal = shorten(greenVal);
          blueVal = shorten(blueVal);
          alphaVal = shorten(alphaVal);
          vertList = shorten(vertList);
        }
      }
      if (polyCount>50){
        for (int i=0; i<polyCount-50; i++){
          redVal = append(redVal, 0);
          greenVal = append(greenVal, 0);
          blueVal = append(blueVal, 0);
          alphaVal = append(alphaVal, 0);
          vertList = append(vertList, 0);
        }
      }
      line = input.readLine();
      vertCount = Integer.parseInt(line);
      for (int i=0; i<vertCount; i++){
        verticesX = append(verticesX, 0);
        verticesY = append(verticesY, 0);
      }
      for (int i=0; i<polyCount; i++){
        line = input.readLine();
        vertList[i] = Integer.parseInt(line);
        line = input.readLine();
        redVal[i] = Integer.parseInt(line);
        line = input.readLine();
        greenVal[i] = Integer.parseInt(line);
        line = input.readLine();
        blueVal[i] = Integer.parseInt(line);
        line = input.readLine();
        alphaVal[i] = Integer.parseInt(line);
      }
      for (int i=0; i<vertCount; i++){
        line = input.readLine();
        verticesX[i] = Integer.parseInt(line);
        line = input.readLine();
        verticesY[i] = Integer.parseInt(line);
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
  
////////////////////////////////////////////////////////////////////////////////DRAW

void draw(){  
  
  totalMutations++;
  background(bgRed, bgGreen, bgBlue);
  readParent();
  mutate();
  
  for (int i=0; i<polyCount; i++){
    fill(redVal[i], greenVal[i], blueVal[i], alphaVal[i]);
    beginShape();
    for (int j=0; j<vertList[i]; j++){
      vertex(verticesX[currentVert], verticesY[currentVert]);
      currentVert++;
    }
    endShape(CLOSE);
  }
  currentVert = 0;

  PImage masterImage = loadImage("masterImage.jpg");
  masterImage.loadPixels();
  loadPixels();
  
  for (int i=0; i<imageWidth*imageHeight; i++){
    fitNew += pow((((masterImage.pixels[i] >> 16) & 0xFF)-((pixels[i] >> 16) & 0xFF)),2) + pow((((masterImage.pixels[i] >> 8) & 0xFF)-((pixels[i] >> 8) & 0xFF)),2) + pow(((masterImage.pixels[i] & 0xFF)-(pixels[i] & 0xFF)),2);
  }
  
  if(fitOld == 0){
    fitOld = fitNew;
  }
  else{
    if(fitNew < fitOld){
      desirableMutations++;
      fitOld = fitNew;
      writeParent();
    }
  }
  fitNew -= fitNew;
  
  if(keyPressed) {
    if (key == 's') {
      save("result.png");
      output = createWriter("results.txt");
      output.println("Polygon Count: "+polyCount);
      output.println("Vertex Count: "+vertCount);
      output.println("Total Mutations: "+totalMutations);
      output.println("Desirable Mutations:  "+desirableMutations); 
      output.flush();
      output.close();
      output = createWriter("dna.txt");    
      output.println(polyCount);
      output.println(vertCount);
  
      for (int i=0; i<polyCount; i++){
        output.println(vertList[i]);
        output.println(redVal[i]);
        output.println(greenVal[i]);
        output.println(blueVal[i]);
        output.println(alphaVal[i]);
      }
      for (int i=0; i<vertCount; i++){
        output.println(verticesX[i]);
        output.println(verticesY[i]);
      }
      output.flush();
      output.close();
      
      output = createWriter("started.txt");
      output.println(1);
      output.flush();
      output.close();
        }
  }
  if(totalMutations%1000 == 0 || totalMutations == 1){
    save(totalMutations+".png");
  }
}
