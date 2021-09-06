ArrayList<Month> months = new ArrayList<Month>();

PFont font;
Table data; 
IntList values = new IntList();
String[] monthname = {"janv", "fév", "mars", "avril", "mai", "juin", "juillet", "août", "sept", "oct", "nov", "déc"};
int margin, maxRectSize, txtLegendColor;

void setup() {
  size(900, 800);
  background(255);
  strokeCap(SQUARE);

  data = loadTable("hal_depot_2019_2021.csv", "header");
  println("nb of rows", data.lastRowIndex());

  // parse data to arraylist 
  for (TableRow row : data.rows()) {
    // extract year and month
    String[] cut = row.getString(0).split("-");
    int itermonth = int(cut[1]);

    // find instances
    Boolean finded = false;
    for (Month m : months) {
      if (m.monthnb == itermonth) {
        m.update(int(cut[0]), int(row.getString(1)), int(row.getString(2)));
        finded = true;
        break;
      }
    }
    if (!finded) {
      months.add( new Month(int(cut[1]), int(row.getString(1)), int(row.getString(2))));
    }
  }

  // add month name and deduce max value
  for (Month m : months) {
    m.name = monthname[m.monthnb-1];
    for (int tempNotice : m.notice) {
      for (int tempFile : m.file) {
        values.append(tempNotice + tempFile);
      }
    }
  }

  print("min", values.min(), "max", values.max());
  println("\n\n");

  for (Month m : months) {
   println(m.name, m.notice);
   }
}

void draw() {
  noLoop();
  font = loadFont("NotoSans-Regular-24.vlw");
  textFont(font);
  color fileColor = color(#1f618d);
  color noticeColor = color(#f1c40f);
  textAlign(CENTER, UP);
  textSize(12);
  maxRectSize = 600;
  txtLegendColor = 90;
  margin = 50;
  int nbOfYear = 3 ;

  // add legend
  addAxLegend(10000, "10k", width/5.6);
  addAxLegend(20000, "20k", width/3.85 );
  addAxLegend(30000, "30k", width/2.95 );
  addAxLegend(40000, "40k", width/2.37 );

  smallAxe(100000, "100k", width/2.37, 60);
  smallAxe(150000, "150k", width/2.05, 30);

  addGlobalLegend(fileColor, noticeColor);

  for (int i = 0; i < months.size(); i++) {
    Month m = months.get(i);

    float xpos = map(i, 0, months.size()-1, margin, width-margin);
    int distBetweenRect = 16;

    // month name
    textSize(13);
    fill(20);
    textAlign(CENTER, CENTER);
    text(m.name, xpos, height-margin/2);

    for (int year = 0; year < nbOfYear; year++) {

      float yfile = map(m.file.get(year), 0, values.max(), 0, maxRectSize); 
      float ynotice = map(m.notice.get(year), 0, values.max(), 0, maxRectSize);

      float changeXpos = map(year, 0, nbOfYear-1, -distBetweenRect, distBetweenRect);
      float alpha = map(year, 0, nbOfYear-1, 50, 255);

      strokeWeight(14);
      stroke(fileColor, alpha);
      line(xpos + changeXpos, height-margin, xpos+changeXpos, height-margin-yfile);

      stroke( noticeColor, alpha);
      line(xpos + changeXpos, height-margin-yfile, xpos+changeXpos, height-margin-yfile-ynotice);
    }
  }
  
  save("hal_depot_3_annees_year_year.png");
}

void smallAxe(int l, String legend, float xposText, float axSize) {
  float yaxe = map(l, 0, values.max(), 0, maxRectSize);
  yaxe = height - margin - yaxe;
  for (float xpos = xposText-axSize; xpos < xposText+ axSize; xpos +=13) {
    line(xpos, yaxe, xpos+8, yaxe);
  }
  fill(txtLegendColor);
  text(legend, xposText, yaxe-5);
}


void addAxLegend( int l, String legend, float xposText) {
  float yaxe = map(l, 0, values.max(), 0, maxRectSize);
  yaxe = height - margin - yaxe;
  strokeWeight(1);
  stroke(220);
  for (int xpos = margin; xpos < width-margin; xpos+=13) {
    line(xpos, yaxe, xpos+8, yaxe);
  }

  fill(txtLegendColor);
  text(legend, xposText, yaxe-5);
}


void addGlobalLegend(color fileColor, color noticeColor) {
  float xlegend = 3.5*width/5.0;
  float ylegend = height/5;
  noStroke();
  textSize(14);

  fill(noticeColor);
  rect(xlegend, ylegend, 20, 20);
  fill(txtLegendColor);
  text("dépôt sans texte intégral", xlegend + 115, ylegend+15);

  fill(fileColor);
  rect(xlegend, ylegend+25, 20, 20);
  fill(txtLegendColor);
  text("dépôt avec texte intégral", xlegend + 115, ylegend+40);

  ylegend += 130;
  xlegend += 0 ; 
  String[] year = {"2019", "2020", "2021"};
  for (int i = 0; i < year.length; i ++) {
    float tempx = map(i, 0, year.length-1, 0, 40);
    float tempalpha = map(i, 0, year.length-1, 50, 255);

    fill(fileColor, tempalpha);
    rect(xlegend+tempx, ylegend-50, 10, 20);

    fill(noticeColor, tempalpha);
    rect(xlegend+tempx, ylegend-70, 10, 20);

    pushMatrix();
    translate(xlegend+tempx, ylegend-5);
    rotate(-PI/3.0);
    fill(txtLegendColor);
    text(year[i], 0, 0 );
    popMatrix();
  }
  
  textSize(25);
  fill(0);
  text("Comparaison par mois des dépôts HAL \neffectués les trois précédentes années", width/2, margin/2);
}
