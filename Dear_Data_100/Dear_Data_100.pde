// -- The variables used for the data
String [] transport;
String [][] data;
float transportSize = 40; // <-- determines the sizes of the marks used to represent data items

// -- The variables that are used for the scrollbar
float scrollbarX;   // X position of scrollbar
float scrollbarY = 0;     // Y position of the scrollbar
float knobY = 0;
float knobHeight = 40;
boolean dragging = false;
float scrollOffset = 0;

void setup () {
  fullScreen(P3D);
  textAlign(RIGHT);
  textSize(18);
  ellipseMode(CENTER);

  // -- load the data from the .csv file into an array of Strings with loadStrings():
  transport = loadStrings("Dear Data Project.csv");

  // -- initialising the data array, to contain an array for each line of the .csv file:
  data = new String [transport.length][];

  // -- loop through each line of the data array in turn:
  for (int i=0; i< transport.length; i++)
  {
    String [] dataItems = split(transport[i], ","); // <-- splitting the line at each comma
    data [i] = new String [dataItems.length];

    for (int d=0; d< dataItems.length; d++)
    {
      data[i][d] = dataItems[d];
    }
  }
}

void draw()
{
  background(250);

  // Place scrollbar at the far right edge
  scrollbarX = width - 20;   // 20 = scrollbar width
  float scrollbarHeight = height;

  // Draw scrollbar track
  stroke(0);
  fill(200);
  rect(scrollbarX, scrollbarY, 20, scrollbarHeight);

  // Drawing the knob used for scrolling
  fill(100);
  rect(scrollbarX, knobY, 20, knobHeight);

  // Scroll percentage
  float scrollPercent = (knobY - scrollbarY) / (scrollbarHeight - knobHeight);

  // Map scrollPercent to content offset
  float contentHeight = transport.length * transportSize; 
  float maxOffset = max(0, contentHeight - height);
  scrollOffset = scrollPercent * maxOffset;
  
  fill(0);
  textAlign(RIGHT, TOP);
  text("Click anywhere, then press Esc to exit", width - 60, 10);
  text("Drag the scrollbar and release to scroll", width - 60, 40);
  text("Left arrow key makes the circles smaller", width - 60, 70);
  text("Right arrow key makes the circles larger", width - 60, 100);
  

  // -- Loop through each row in the data array in turn:
  for (int i=0; i<data.length; i++)
  {
    float x = transportSize*1.5;         
    float y = transportSize + i*transportSize - scrollOffset; // <-- apply scrollOffset here
    String dayName = data[i][0];     
    color fillColour = color(255, 255, 255); 
    fill(32, 128);
    text(dayName, transportSize*1.5, y); // <-- day name also scrolls

    // -- Loop through each column in this row of the data array in turn:
    for (int d=1; d<data[i].length; d++)
    {
      boolean dataAvailable = true;  
      String mode = data[i][d];  
      String modeText = "";     

      // -- Condition to set colours and text depending on data values:
      if (mode.equals("train")) {
        fillColour = color(0, 0, 255);
        modeText = "Train";
      } else if (mode.equals("walk")) {
        fillColour = color(255, 160, 32);
        modeText = "Walking";
      } else if (mode.equals("ElizabethLine")) {
        fillColour = color(105, 80, 161);
        modeText = "Elizabeth Line";
      } else if (mode.equals("noElizabethLine")) {
        fillColour = color(240, 120, 70);
        modeText = "Didn't get the Elizabeth Line";
      } else if (mode.equals("CircleLine")) {
        fillColour = color(250, 250, 5);
        modeText = "Circle Line";
      } else if (mode.equals("HammersmithLine")) {
        fillColour = color(255, 145, 168);
        modeText = "Hammersmith and City Line";
      } else if (mode.equals("DLR")) {
        fillColour = color(0, 175, 173);
        modeText = "DLR";
      } else if (mode.equals("noTrain")) {
        fillColour = color(2, 119, 1);
        modeText = "Didn't get the train";
      } else if (mode.equals("noBus")) {
        fillColour = color(240, 64, 64);
        modeText = "Didn't get the bus";
      } else if (mode.equals("NorthernLine")) {
        fillColour = color(0, 0, 0);
        modeText = "Northern Line";
      } else if (mode.equals("4")) {
        fillColour = color(153, 0, 18);
        modeText = "Bus 4";
      } else if (mode.equals("56")) {
        fillColour = color(70, 120, 90);
        modeText = "Bus 56";
      } else if (mode.equals("153")) {
        fillColour = color(130, 165, 200);
        modeText = "Bus 153";
      } else if (mode.equals("99")) {
        fillColour = color(65, 28, 36);
        modeText = "Bus 99";
      } else if (mode.equals("89")) {
        fillColour = color(33, 238, 49);
        modeText = "Bus 89";
      } else if (mode.equals("428")) {
        fillColour = color(248, 221, 86);
        modeText = "Bus 428";
      } else if (mode.equals("341")) {
        fillColour = color(273, 42, 177);
        modeText = "Bus 341";
      } else {
        dataAvailable = false;
      }

      // -- only draw a circle (representing a mode) on the canvas if there is a valid String from the .csv file
      if (dataAvailable)
      {
        x += transportSize;                 
        noStroke();
        fill(fillColour); // use mapped colour
        circle(x, y, transportSize * 0.8);

        // Check if mouse is inside the square
        if (dist(mouseX, mouseY, x, y) < transportSize * 0.4)
        {
          stroke(32, 128);
      
          // Isolate transformations
          pushMatrix();
          translate(x, y); // move to the circle's position
      
          // Apply rotation based on frameCount
          rotateX(radians(frameCount * 0.2));
          rotateY(radians(frameCount * 1.8));
          rotateZ(radians(frameCount * 0.6));
      
          // Draw the sphere with the same colour
          float hoverScale = 1.3; // 30% bigger
          fill(fillColour);
          sphere(transportSize * 0.4 * hoverScale); 
          popMatrix();
      
          // Draw text near the mouse
          pushMatrix();
          translate(0, -transportSize * 0.4 - 20); 
          fill(0); // text colour (black for contrast)
          text(modeText, mouseX, mouseY - 10);
          popMatrix();
        }
      }
    }
  }

  noLoop();  //  <-- switch the draw() loop off to save resources
}

void mouseMoved ()
{
  loop();  //  <-- switch the draw() loop on when mouse is moved (for interaction).
}
// This method controls the actions performed when the left and right arrow keys are clicked
void keyPressed() {
  if (key == CODED)
  {
    if (keyCode == RIGHT)
    {
      transportSize = transportSize * 1.1;
    } else if (keyCode == LEFT)
    {
      transportSize = transportSize / 1.1;
    }
  }
  loop();  // update canvas
}

// The following methods are the actions performed when using the scrollbar

void mousePressed()
{
  if (mouseX > scrollbarX && mouseX < scrollbarX + 20 && mouseY > knobY && mouseY < knobY + knobHeight)
  {
    dragging = true;
  }
}

void mouseDragged()
{
  if (dragging) 
  {
    float scrollbarHeight = height;
    knobY = constrain(mouseY - knobHeight/2, scrollbarY, scrollbarY + scrollbarHeight - knobHeight);
  }
}

void mouseReleased()
{
  dragging = false;
}
