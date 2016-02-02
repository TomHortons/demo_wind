import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;
import processing.opengl.*;
import igeo.*;

/* reference: 
Array: http://igeo.jp/tutorial/6.html
random: http://www.cp.cmc.osaka-u.ac.jp/~kikuchi/kougi/simulation2009/processing10.html
Points and Vectors: http://igeo.jp/tutorial/3.html
MySQL Driver: http://www.task-notes.com/entry/20150414/1428980400
Coding for processing: http://tkitao.hatenablog.com/entry/2014/02/23/183931
*/

MySQL msql;
int up_time = 0;
int count = 0;
final int vel_len = 4;
double vec_len;
IVec[] locations = new IVec[9];
IVec[] vectors = new IVec[9];
IPoint[] points = new IPoint[9];
IVec[] velocities = new IVec[9];

void setup() {
  size( 480*3, 360*3, IG.GL );

  String user      = "imanishi";
  String pass      = "K21kjwe2mysql";
  String database  = "wind";
  String dbhost    = "localhost";
  msql = new MySQL( this, "localhost", database, user, pass );
  
  
  if (msql.connect())
  {
    //now read it back out
    msql.query("SELECT * FROM sensors;");
      
    while (msql.next()){
      int id = msql.getInt("id");
      float x = msql.getFloat("x");
      float y = msql.getFloat("y");
      float z = msql.getFloat("z");
      float temp = msql.getFloat("temp");
        
      println(x);
    }
  }
  else 
  {
    println("connection failed");
  }
  
  // Draw surface
  IVec v1 = new IVec(0, 0, 0);
  IVec v2 = new IVec(20, 0, 0);
  IVec v3 = new IVec(20, 20, 0);
  IVec v4 = new IVec(0, 20, 0);

  new ISurface(v1, v2, v3, v4);
  
  count = 0;
  for(int i=0; i < 3; i++) {
    for(int j=0; j < 3; j++) {
      locations[count] = new IVec(j*10, i*10, 0);
      count++;
    }
  }
  
  for(int x = 0; x < 9; x++){
    vectors[x] = new IVec(int(random(3)), int(random(3)), int(random(3)));
    vec_len = vectors[x].len();
    points[x] = new IPoint(locations[x]).hsb(0.5, 0.5, 0.5).weight(10);
    velocities[x] = new IVec(vectors[x]).len(vel_len);
    velocities[x].show(locations[x]).hsb(vec_len*0.1,1.,1.);
  }
  
}


void draw() {

  if (up_time > 6) {
    for(int x = 0; x < 9; x++){
      vectors[x] = new IVec(int(random(3)), int(random(3)), int(random(3)));
      velocities[x].set(vectors[x]).len(vel_len);
      vec_len = vectors[x].len();
      velocities[x].show(locations[x]).hsb(vec_len*0.1,1.,1.);
    }
    up_time = 0;
  }

  up_time++;
}

