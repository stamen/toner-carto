@text_font_transport_bold: 'Arial Unicode MS Bold';
@text_font_physical_bold: 'Arial Unicode MS Bold';
@text_font_administrative: 'Arial Unicode MS Regular';
@text_font_administrative_bold: 'Arial Unicode MS Bold';
@text_font_water: 'Arial Unicode MS Italic';
@text_font_water_bold: 'Arial Unicode MS Bold Italic';
@text_font_city: 'Arial Unicode MS Regular';
@text_font_city_bold: 'Arial Unicode MS Bold';
@text_font_poi_bold: 'Arial Unicode MS Bold Italic';

@label_color_transport: #000;
@text_font_halo_radius_sm: 1;
@label_color_transport_halo: #fff;
@label_color_physical: #000;
@label_color_physical_halo: #fff;
@label_color_administrative: #000;
@label_color_administrative_halo: #fff;
@label_color_city: #000;
@label_color_city_halo: #fff;
@label_color_poi: #000;
@label_color_poi_halo: #fff;

@text_font_size_xxsm: 10;
@text_font_size_xsm: 12;
@text_font_size_sm: 13;
@text_font_size_medium: 14;
@text_font_size_medium_plus: 16;
@text_font_size_large: 18;
@text_font_halo_radius_large: 2;

#minor_road_labels {
  text-name: "[name]";
  text-face-name: @text_font_transport_bold;
  text-placement: line;
  text-max-char-angle-delta: 30;
  text-fill: @label_color_transport;
  text-halo-radius: @text_font_halo_radius_sm;
  text-halo-fill: @label_color_transport_halo;
  text-avoid-edges: true;
  
  [zoom=16] {
    text-dy: 10; 
    text-spacing: 124; 
    text-size: @text_font_size_xxsm; 
    text-halo-radius: @text_font_halo_radius_large; 
  }
  [zoom=17] {
    text-dy: 13; 
    text-spacing: 180; 
    text-size: @text_font_size_xsm;
    text-halo-radius: @text_font_halo_radius_large; 
  }
  [zoom>=18] {
    text-size: @text_font_size_xsm; 
    text-spacing: 400; 
    text-halo-radius: @text_font_halo_radius_large; 
  }
}

#major_road_labels {
  text-name: "[name]";
  text-face-name: @text_font_transport_bold;
  text-placement: line;
  text-max-char-angle-delta: 30;
  text-fill: @label_color_transport;
  text-halo-radius: @text_font_halo_radius_sm;
  text-halo-fill: @label_color_transport_halo;
  text-spacing: 100;
  text-avoid-edges: true;

  [zoom>=16][highway='primary'] {
	text-halo-radius: @text_font_halo_radius_large;
  }
  [is_tunnel=1][zoom>=15] {
	text-fill: #777;
  }
  [zoom=12] {
    text-dy: 7;
    text-size: @text_font_size_xsm;
    text-min-distance: 4;
  }
  [zoom=13] {
    text-dy: 8;
    text-min-distance: 5;
    [highway='trunk'] {
		text-size: @text_font_size_sm;
    }
    [highway='primary'] {
		text-size: 13;
    }
  }

  [zoom=14] {
    text-min-distance: 5;
    [highway='trunk'],[highway='primary'] {
		text-dy: 9;
      	text-size: @text_font_size_medium;
    } 
    [highway='secondary'] {
		text-dy: 7;
      	text-size: @text_font_size_xsm;
    }
  }

  [zoom=15] {
    text-min-distance: 10;
    [highway='trunk'],[highway='primary'] {
		text-dy: @text_font_size_xsm;
      	text-size: 15;
    }
    [highway='secondary'],[highway='tertiary'] {
		text-dy: 11;
      	text-size: @text_font_size_sm;
    }
  }

  [zoom=16] {
    text-min-distance: 12;
    text-dy: 13;
    [highway='trunk'],[highway='primary'] { 
      	text-size: @text_font_size_medium;
    }
    [highway='secondary'],[highway='tertiary'] {	
      	text-spacing: 124;
      	text-size: @text_font_size_sm;
      	text-halo-radius: @text_font_halo_radius_large;
    }
  }

  [zoom=17] {
    text-min-distance: 12;
    [highway='trunk'] {
		text-dy: 16;
      	text-size: @text_font_size_medium_plus;
    }
    [highway='primary'] {
		text-dy: 14;
      	text-size: @text_font_size_medium;
    }
    [highway='secondary'] {
		text-dy: 14; 
      	text-spacing: 180;
      	text-size: @text_font_size_medium;
      	text-halo-radius: @text_font_halo_radius_large;
    }
    [highway='tertiary'] {
		text-dy: 13; 
      	text-spacing: 180;
      	text-size: @text_font_size_xsm; 
      	text-halo-radius: @text_font_halo_radius_large;
    }
  }

  [zoom>=18] {
    text-min-distance: 12;
    [highway='trunk'] {
		text-size: @text_font_size_medium_plus;
    }
    [highway='primary'] {
		text-size: @text_font_size_medium;
    }
    [highway='secondary'] {
		text-size: @text_font_size_medium; 
		text-spacing: 300;
		text-halo-radius: @text_font_halo_radius_large;
    }
    [highway='tertiary'] {
        text-size: @text_font_size_xsm;
        text-spacing: 400;
      	text-halo-radius: @text_font_halo_radius_large;
    }
  }
}

#poi_station_labels {
  [zoom=17][railway='station'] { 
	point-file: url('images/subway_sm.png'); 
  }
  
  [zoom>=18][railway='station'] { 
	point-file: url('images/subway.png'); 
  }
}

#water-bodies-labels-low,
#water-bodies-labels-med,
#water-bodies-labels-high {
  [zoom=9][area>100000000],
  [zoom=10][area>100000000],
  [zoom=11][area>25000000],
  [zoom=12][area>5000000],
  [zoom=13][area>2000000],
  [zoom=14][area>200000],
  [zoom=15][area>50000],
  [zoom=16][area>10000],
  [zoom>=17] {
 	text-name: "[name]";
	text-face-name: @text_font_water;
    text-placement: point;
    text-max-char-angle-delta: 30;
    text-wrap-width: 40;
    text-halo-radius: @text_font_halo_radius_large;
    text-fill: @label_color_physical_halo;
    text-halo-fill: @label_color_physical;
    text-size: @text_font_size_xsm;
    
    [zoom>9][zoom<12] {
      text-spacing: 200;
      text-wrap-width: 50;
    }
    [zoom=12] {
      text-size: @text_font_size_xsm;
      text-spacing: 200;
      text-wrap-width: 70;
    }
    [zoom=13] {
      text-size: @text_font_size_xsm;
      text-spacing: 100;
      text-wrap-width: 70;
    }
    [zoom=14] {
      text-size: @text_font_size_xsm;
      text-spacing: 100;
      text-wrap-width: 70;
    }
    [zoom>=15] {
      text-size: @text_font_size_sm;
      text-spacing: 100;
      text-wrap-width: 40; 
    }
  }
}

#green-areas-labels-low,
#green-areas-labels-med,
#green-areas-labels-high {
  [zoom=9][area>100000000],
  [zoom=10][area>100000000],
  [zoom=11][area>25000000],
  [zoom=12][area>5000000],
  [zoom=13][area>2000000],
  [zoom=14][area>200000],
  [zoom=15][area>50000],
  [zoom=16][area>10000],
  [zoom>=17] {
 	text-name: "[name]";
	text-face-name: @text_font_water;
    text-placement: point;
    text-max-char-angle-delta: 30;
    text-wrap-width: 40;
    text-halo-radius: @text_font_halo_radius_large;
    
    text-fill: @label_color_physical;
    text-halo-fill: @label_color_physical_halo;
    
    text-line-spacing: -1;
    text-min-distance: 10;
    text-size: @text_font_size_xsm;
    
    [zoom>9][zoom<12] {
      text-spacing: 200;
      text-wrap-width: 50;
    }
    
    [zoom=12] {
      text-size: @text_font_size_xsm;
      text-spacing: 200;
      text-wrap-width: 70;
    }
    [zoom=13] {
      text-size: @text_font_size_xsm;
      text-spacing: 100;
      text-wrap-width: 70;
    }
    [zoom=14] {
      text-size: @text_font_size_xsm;
      text-spacing: 100;
      text-wrap-width: 70;
    }
    [zoom>=15] {
      text-size: @text_font_size_sm;
      text-spacing: 100;
      text-wrap-width: 40; 
    }
  }
}

#continents[zoom>=1][zoom<3]
{
  	text-name: "[name]";
    text-face-name: @text_font_physical_bold;
    text-wrap-width: 32;
    text-size: @text_font_size_medium;
    text-fill: @label_color_physical;
    text-halo-radius: 3;
    text-halo-fill: @label_color_physical_halo;
}

#admin1-labels-50m-z4 {
    text-face-name: @text_font_administrative;
    text-wrap-width: 80;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo; 
    text-name: "[label_z4]";
    text-size:  @text_font_size_xsm;
}

#admin1-labels-50m-z5 {
    text-face-name: @text_font_administrative;
    text-wrap-width: 80;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo; 
    text-name: "[label_z5]";
    text-size:  @text_font_size_medium_plus;
}

#admin1-labels-50m-z6 {
    text-face-name: @text_font_administrative;
    text-wrap-width: 80;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo; 
    text-name: "[label_z6]";
    text-size:  @text_font_size_large;
}

#admin1-labels-50m-z7 {
    text-face-name: @text_font_administrative;
    text-wrap-width: 80;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo; 
    text-name: "[label_z7]";
    text-size:  @text_font_size_large;
}

#admin0-labels-z3[longfrom>3] {
  	text-name: "[shortname]";
    text-face-name: @text_font_administrative;
    text-wrap-width: 80;
    text-size: @text_font_size_sm;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo;
  	text-min-distance: 1;
}

#admin0-labels-z3[longfrom<=3] {
  	text-name: "[name]";
    text-face-name: @text_font_administrative;
    text-wrap-width: 80;
    text-size: @text_font_size_sm;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo;
}

#admin0-labels-z4 {
  	text-name: "[name]";
    text-face-name: @text_font_administrative_bold;
    text-wrap-width: 80;
    text-size: @text_font_size_medium;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo;
}

#admin0-labels-z5 {
  	text-name: "[name]";
    text-face-name: @text_font_administrative_bold;
    text-wrap-width: 80;
    text-size: @text_font_size_medium_plus;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo;
}

#admin0-labels-z6 {
  	text-name: "[name]";
    text-face-name: @text_font_administrative_bold;
    text-wrap-width: 80;
    text-size: @text_font_size_large;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo;
}

#ne_110m_geography_marine_polys[zoom=2][scalerank=0],
#ne_110m_geography_marine_polys[zoom=3],
#ne_50m_geography_marine_polys[zoom=4][scalerank<4] {
    text-name: "[name]";
	text-face-name: @text_font_water_bold;
    text-wrap-width: 80;
    text-size: @text_font_size_medium;
    text-fill: @label_color_physical_halo;
    text-halo-radius: @text_font_halo_radius_sm;
    text-halo-fill: @label_color_physical;
}

#ne_50m_geography_marine_polys[zoom=5],
#ne_10m_geography_marine_polys[zoom>=6][zoom<=8]
{
  	text-name: "[name]";
    text-face-name: @text_font_water;
    text-wrap-width: 80;
    text-size: @text_font_size_medium;
    text-fill: @label_color_physical_halo;
    text-halo-radius: @text_font_halo_radius_sm;
    text-halo-fill: @label_color_physical;
}

#city_labels_z4,
#city_labels_z5,
#city_labels_z6 {
  	text-name: "[name]";
    text-face-name: @text_font_city;
    text-fill: @label_color_city;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_city_halo;
  	text-min-distance: 5;
  
  	#city_labels_z4 {
      text-size: @text_font_size_xxsm;
      [font_size=14] {
          text-size: @text_font_size_medium;  
      }
    }
  
   	#city_labels_z5 {
      text-size: @text_font_size_xsm;
      [font_size=16] {
          text-size: @text_font_size_medium_plus;  
      }
    }
  
    #city_labels_z6 {
      text-size: @text_font_size_xsm;
      [font_size=18] {
          text-size: @text_font_size_large;  
      }
   }
  
    [justified='left'] {
    	text-horizontal-alignment: middle;
    	text-dx: -5;
    }
    [justified='right'] {
    	text-horizontal-alignment: middle;
    	text-dx: 5;
    }
}

#city_labels_z7,
#city_labels_z8, {
	text-name: "[name]";
    text-face-name: @text_font_city_bold;
    text-fill: @label_color_city;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_city_halo;  
	text-size: @text_font_size_sm;
    [font_size=20] { text-size: @text_font_size_large; }  
  
  	#city_labels_z7 {
   	  text-size: @text_font_size_xsm;
      [font_size=18] {
          text-size: @text_font_size_large;  
      }
    }
  
  	[justified='left'] {
    	text-horizontal-alignment: middle;
    	text-dx: -5;
    }
    [justified='right'] {
    	text-horizontal-alignment: middle;
    	text-dx: 5;
    }
}

#city_labels_z9,
#city_labels_z10,
#city_labels_z11,
#city_labels_z12, {
  	text-name: "[name]";
    text-face-name: @text_font_city_bold;
    text-fill: @label_color_city;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_city_halo;  
	text-size: @text_font_size_sm;
    [font_size=20] { text-size: @text_font_size_large; }  
}


#city_points_z4,
#city_points_z5, 
#city_points_z6,
#city_points_z7,
#city_points_z8 {
  	marker-ignore-placement: true;
  	marker-width: 7;
  	marker-fill: black;
  	marker-line-color: white;
  	marker-line-width: 2;
}

#airports[zoom>=10][zoom<=13] {
 	//marker-width: 5;
  	//marker-fill: red;
  	//marker-file: url("images/airplane-19-reverse.png");
	point-file: url('images/airplane-19-reverse.png');
}

#airports[zoom>=13][scalerank<=12]
{
  	text-name: "[name]";
    text-face-name: @text_font_poi_bold;
    text-fill: @label_color_poi;
    text-size: @text_font_size_medium;
    text-halo-fill: @label_color_poi_halo;
    text-halo-radius: @text_font_halo_radius_large;
    text-wrap-width: 128;
    text-dy: 14;
    text-allow-overlap: true;
  
  	[zoom>=14] {
    	text-dy: 0;
    }
}