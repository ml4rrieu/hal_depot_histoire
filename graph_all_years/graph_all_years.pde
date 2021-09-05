ArrayList<Month> months = new ArrayList<Month>();

String[] monthname = {"janv", "fév", "mars", "avril", "mai", "juin", "juillet", "août", "sept", "oct", "nov", "déc"};
IntList values = new IntList();
int maxRectSize, margin, txtLegendColor;

void setup() {
  size(800, 500);
  background(250);

  Table data;
  data = loadTable("evol_depot_cumule.csv", "header");
  println("csv last row index", data.lastRowIndex());

  for (TableRow row : data.rows()) {
    String[] cut = row.getString(0).split("-");

    months.add(new Month(int(cut[0]), int(cut[1]), row.getInt(1), row.getInt(2)));
    values.append(row.getInt(1)+ row.getInt(2));
  }

  println("array list", months.size());

  // add month name 
  for (Month m : months)m.name = monthname[m.monthnb-1];

  // calc rapport file / notice for year
  FloatList getVals = new FloatList() ; 
  for (int i = 0; i < months.size(); i++) {
    Month m = months.get(i);
    float ctemp = (float)m.file/(m.notice+m.file)*100 ;

    if ( ! m.name.equals("déc")) {   
      getVals.append( ctemp);
    }
    if ( m.name.equals("déc")) {
      getVals.append( ctemp);

      float temp = getVals.sum() / getVals.size();
      temp = round(temp);
      m.rapport = str(int(temp))+" %";
      getVals.clear();
      println(m.year, m.rapport);
    }
  }



  //calculer les positions de x
  margin = 50;
  int yearSpace = 150;

  int nbOfYears = months.size()/12 ;
  println(nbOfYears);
  FloatList xpos = new FloatList() ; 
  float increm = (float)(width-margin-yearSpace)/(months.size()+nbOfYears);

  for ( int i = 0; i < months.size(); i++) {
    Month me = months.get(i);
    if (i == 0) {
      me.x = margin ;
      xpos.append(me.x);
      continue;
    }

    if (me.monthnb == 1) {
      me.x = xpos.get(i-1) + increm + yearSpace/nbOfYears ;
      xpos.append(me.x);
    }

    if (me.monthnb != 1) {
      me.x = xpos.get(i-1) + increm ;
      xpos.append(me.x);
    }
  }
}

void draw() {
  noLoop();
  strokeCap(SQUARE);
  textAlign(CENTER);
  txtLegendColor = 100;
  color fileColor = color(#1f618d);
  color noticeColor = color(#f1c40f);
  maxRectSize = 400;  


  addGlobalLegend(fileColor, noticeColor);
  addAxLegend(500000, "500k", width*0.3);
  addAxLegend(1000000, "1M", width*0.3);
  addAxLegend(2000000, "2M", width*0.3);


  strokeWeight(4);
  // pour tous les mois
  for ( int i = 0; i < months.size(); i++) {
    Month me = months.get(i);

    //si premier mois de l'année ajouter l'année
    if ( me.monthnb == 1) addYearLabel(str(me.year), me.x+ 10);    


    float calcy1 = map(me.file, 0, values.max(), 0, maxRectSize);
    stroke(fileColor);
    line(me.x, height-margin, me.x, height-margin-calcy1 );

    float calcy2 = map(me.notice, 0, values.max(), 0, maxRectSize);
    stroke(noticeColor);
    line(me.x, height-margin-calcy1, me.x, height-margin-calcy1-calcy2 );

    // ajouter le rapport file / notice+file
    if ( me.monthnb == 12)addRapportLabel(me.rapport, me.x, height-margin-calcy1-calcy2);
  }
  
  save("hal_evol_depo.png");
}

void addRapportLabel(String s, float x, float y ) {
  textSize(10);
  text(s, x-10, y-5);
}
void addGlobalLegend(color fileColor, color noticeColor) {

  float xlegend = margin;
  float ylegend = height*0.35;
  noStroke();
  textSize(14);

  fill(noticeColor);
  rect(xlegend, ylegend, 20, 20);
  fill(txtLegendColor);
  text("dépôt sans texte intégral", xlegend + 110, ylegend+15);

  fill(fileColor);
  rect(xlegend, ylegend+25, 20, 20);
  fill(txtLegendColor);
  text("dépôt avec texte intégral", xlegend + 110, ylegend+40);

  textSize(20);
  fill(0);
  text("HAL : nombre de dépôts cumulés par années", width/2, margin);
}

void addYearLabel(String s, float x) {
  pushMatrix();
  translate(x, height-margin/2);
  rotate(-PI/4);
  textSize(12);
  text(s, 0, 0 );
  popMatrix();
}

void addAxLegend( int l, String legend, float xposText) {
  float yaxe = map(l, 0, values.max(), 0, maxRectSize);
  yaxe = height - margin - yaxe;

  strokeWeight(1);
  stroke(180);

  for (int xpos = margin; xpos < width-margin; xpos+=13) {
    line(xpos, yaxe, xpos+8, yaxe);
  }

  fill(txtLegendColor);
  textSize(12);
  text(legend, xposText, yaxe-5);
}



// a class for Month
class Month {
  String name ; 
  int year, monthnb; 
  // value for years are added into IntList (implicit index)
  int notice, file;
  String rapport ; 
  float x;
  Month(int _year, int _monthnb, int _notice, int _file) {

    year = _year;
    monthnb = _monthnb;
    notice = _notice ; 
    file = _file ;
  }
}
