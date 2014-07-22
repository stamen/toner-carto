@text_font_transport: 'PT Sans Narrow Regular','Arial Unicode MS Regular';
@text_font_transport_bold: 'PT Sans Narrow Bold','Arial Unicode MS Bold';
@text_font_physical_bold: 'PT Sans Narrow Bold','Arial Unicode MS Bold';
@text_font_administrative: 'PT Sans Narrow Regular','Arial Unicode MS Regular';
@text_font_administrative_bold: 'PT Sans Narrow Bold','Arial Unicode MS Bold';
@text_font_water: 'PT Sans Italic','Arial Unicode MS Italic';
@text_font_water_bold: 'PT Sans Bold Italic','Arial Unicode MS Bold Italic';
@text_font_city: 'PT Sans Narrow Regular','Arial Unicode MS Regular';
@text_font_city_bold: 'PT Sans Narrow Bold','Arial Unicode MS Bold';
@text_font_poi_bold: 'PT Sans Bold Italic','Arial Unicode MS Bold Italic';

@label_color_transport: #000;
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
@text_font_halo_radius_sm: 1;
@text_font_halo_radius_large: 2;

Map {
  font-directory: url("fonts/");
  buffer-size: 128;
}

#minor_road_labels,
#major_road_labels,
{
  text-name: [name];
  text-face-name: @text_font_transport;
  text-size: 18;
  text-placement: line;
  text-max-char-angle-delta: 20;
  text-fill: #444;
  text-halo-radius: 2;
  text-halo-fill: #f7f7e6;
  text-spacing: 256;
  text-avoid-edges: true;
}

#poi_station_labels {
  [zoom>=16][railway='station'] {
    shield-name: "[label]";
    shield-face-name: @text_font_transport_bold;
    shield-fill: white;
    shield-size: 12;
    shield-file: url('images/subway_shield_small.svg');
  }
}

/*
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
	text-face-name: @text_font_water_bold;
    text-placement: interior;
    text-max-char-angle-delta: 30;
    text-wrap-width: 40;
    text-halo-radius: 1;
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
*/

#green-areas-labels-low,
#green-areas-labels-med,
#green-areas-labels-high {
  [zoom=8][area>100000000],
  [zoom=9][area>100000000],
  [zoom=10][area>100000000],
  [zoom=11][area>5000000],
  [zoom=12][area>1000000],
  [zoom=13][area>400000],
  [zoom=14][area>200000],
  [zoom=15][area>50000],
  [zoom=16][area>10000],
  [zoom>=17] {
    text-name: [name];
    text-face-name: "PT Sans Narrow Regular";
    text-placement: interior;
    text-wrap-width: 96;
    text-wrap-before: true;
    text-line-spacing: -3;
    text-fill: #374c30;
    text-size: 15;

    [zoom>=11] {
      text-fill: #586e50;
      text-halo-fill: #d8f1ce;
      text-halo-radius: 2;
    }

    [zoom>=12] {
      text-halo-fill: #f7f7dc;
    }

    [zoom>=15] {
      text-size: 18;
    }
  }
}

#continents
{
  text-name: [name];
  text-face-name: "PT Sans Narrow Regular";
  text-wrap-width: 32;
  text-size: 32;
  text-line-spacing: -12;
  text-fill: black;
}

/*
#admin1-labels-50m-z4 {
  text-face-name: @text_font_administrative;
  text-wrap-width: 80;
  text-fill: @label_color_administrative;
  text-halo-radius: @text_font_halo_radius_large;
  text-halo-fill: @label_color_administrative_halo; 
  text-name: "[label_z4]";
  text-size: 16;
}
*/

/*
#admin1-labels-50m-z5 {
  text-face-name: @text_font_administrative;
  text-wrap-width: 80;
  text-fill: @label_color_administrative;
  text-halo-radius: @text_font_halo_radius_large;
  text-halo-fill: @label_color_administrative_halo; 
  text-name: "[label_z5]";
  text-size:  @text_font_size_medium_plus;
}
*/

/*
#admin1-labels-50m-z6 {
  text-face-name: @text_font_administrative;
  text-wrap-width: 80;
  text-fill: @label_color_administrative;
  text-halo-radius: @text_font_halo_radius_large;
  text-halo-fill: @label_color_administrative_halo; 
  text-name: "[label_z6]";
  text-size:  @text_font_size_large;
}
*/

/*
#admin1-labels-50m-z7 {
  text-face-name: @text_font_administrative;
  text-wrap-width: 80;
  text-fill: @label_color_administrative;
  text-halo-radius: @text_font_halo_radius_large;
  text-halo-fill: @label_color_administrative_halo; 
  text-name: "[label_z7]";
  text-size:  @text_font_size_large;
}
*/

#admin0-labels-z3[longfrom>3] {
    text-name: "[shortname]";
    text-face-name: @text_font_administrative;
    text-wrap-width: 80;
    text-size: 18;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo;
    text-min-distance: 5;
}

#admin0-labels-z3[longfrom<=3] {
    text-name: "[name]";
    text-face-name: @text_font_administrative;
    text-size: 24;
    text-line-spacing: -8;
    text-wrap-width: 100;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo;
}

#admin0-labels-z4 {
    text-name: [name];
    text-face-name: "PT Sans Regular";
    text-wrap-width: 80;
    text-size: 24;
    text-min-distance: 15;
    text-fill: @label_color_administrative;
    text-halo-radius: @text_font_halo_radius_large;
    text-halo-fill: @label_color_administrative_halo;
}

#admin0-labels-z5 {
  text-name: [name];
  text-face-name: "PT Sans Regular";
  text-wrap-width: 80;
  text-size: 24;
  text-fill: @label_color_administrative;
  text-halo-radius: @text_font_halo_radius_large;
  text-halo-fill: @label_color_administrative_halo;
}

#admin0-labels-z6 {
  text-name: [name];
  text-face-name: "PT Sans Regular";
  text-wrap-width: 80;
  text-size: 24;
  text-fill: @label_color_administrative;
  text-halo-radius: @text_font_halo_radius_large;
  text-halo-fill: @label_color_administrative_halo;
}

// HACK! All the problematic water bodies with accents
// e.g. "Bahia de Campeche" with an accented i,
// have an empty "changed" string. So abuse this for now.

/*
#ne_110m_geography_marine_polys[zoom=2][scalerank=0][changed!=''],
#ne_110m_geography_marine_polys[zoom=3][changed!=''],
#ne_50m_geography_marine_polys[zoom=4][scalerank<4][changed!=''] {
  text-name: [name];

  [namealt!=''] {
    text-name: [name] + '\n(' + [namealt] + ')';
  }

  text-face-name: @text_font_water_bold;
  text-wrap-width: 80;
  text-size: @text_font_size_medium;
  text-fill: @label_color_physical;
  text-halo-radius: @text_font_halo_radius_sm;
  text-halo-fill: @label_color_physical_halo;
  text-line-spacing: -2;

  [zoom=4][scalerank>2] {
    text-face-name: @text_font_water;
    text-size: @text_font_size_xsm;
  }
}
*/

/*
#ne_50m_geography_marine_polys[zoom=5][changed!=''],
#ne_10m_geography_marine_polys[zoom>=6][zoom<=8][changed!='']
{
    text-name: [name];
    [namealt!=''] {
      text-name: [name] + '\n(' + [namealt] + ')';
    }
    text-face-name: @text_font_water;
    text-wrap-width: 80;
    text-size: @text_font_size_sm;
    text-fill: @label_color_physical;
    text-halo-radius: @text_font_halo_radius_sm;
    text-halo-fill: @label_color_physical_halo;
}
*/

#city_labels_z4,
#city_labels_z5,
#city_labels_z6 {
  text-placement: interior;
  text-name: [name];
  text-vertical-alignment: bottom;
  text-face-name: @text_font_city;
  text-fill: @label_color_city;
  text-min-distance: 5;

  [zoom>=4] {
    text-size: 14;
  }

  [zoom>=6] {
    text-size: 15;
  }

  [font_size=14] {
    text-size: 18;
  }

  [font_size=16] {
    text-size: 19;
  }

  [font_size=18] {
    text-size: 20;
  }
}

#city_labels_z7,
#city_labels_z8, {
  text-name: [name];
  text-vertical-alignment: bottom;
  text-face-name: @text_font_city;
  text-fill: @label_color_city;
  text-size: @text_font_size_sm;

  [zoom>=7] {
    text-size: 16;
  }

  [zoom>=8] {
    text-size: 18;
  }

  [font_size=18] {
    text-size: 22;
  }

  [font_size=20] {
    text-size: 24;
  }
}

#city_labels_z9,
#city_labels_z10 {
  text-name: [name];
  text-face-name: @text_font_city;
  text-fill: @label_color_city;
  text-size: 18;

  [font_size=20] {
    text-size: 32;
  }

  [zoom>=12] {
    text-halo-fill: #f7f7e6;
    text-halo-radius: 2;
  }
}

#city_points_z4,
#city_points_z5, 
#city_points_z6,
#city_points_z7,
#city_points_z8 {
  // outline merged points rather than stacking them
  ::outline {
    marker-ignore-placement: true;
    marker-width: 7;
    marker-fill: white;
    marker-line-width: 0;
  }

  marker-ignore-placement: true;
  marker-width: 5;
  marker-fill: black;
  marker-line-width: 0;
}

#airports
{
  [zoom=8] {
    [type='major'] {
      marker-file: url('icons/airport_big_l.png');
    }

    [type='mid'] {
      marker-file: url('icons/airport_little_l.png');
    }

    [type='spaceport'] {
      marker-file: url('icons/intergalactic_l.png');
    }

    [type=~'.*military.*'] {
      marker-file: url('icons/airport_military_l.png');
    }
  }

  [zoom>=9] {
    shield-name: [abbrev];
    shield-face-name: 'PT Sans Narrow Regular';
    shield-fill: #444;
    shield-size: 18;
    shield-halo-fill: #f7f7e6;
    shield-halo-radius: 2;
    shield-wrap-width: 128;
    shield-text-dy: 12;
    shield-unlock-image: true;
    shield-file: url("icons/airport_big_l.png");

    [type=~'.*military.*'] {
      shield-file: url('icons/airport_military_l.png');
    }

    [type='major'] {
      shield-file: url('icons/airport_big_l.png');
    }

    [type='mid'] {
      shield-file: url('icons/airport_little_l.png');
    }

    [type='spaceport'] {
      shield-file: url('icons/intergalactic_l.png');
    }
  }

  [zoom>=14] {
    shield-name: [name];
    shield-file: url("icons/airport_big_xl.png");
    shield-text-dy: 20;

    [type=~'.*military.*'] {
      shield-file: url('icons/airport_military_xl.png');
    }

    [type='major'] {
      shield-file: url('icons/airport_big_xl.png');
    }

    [type='mid'] {
      shield-file: url('icons/airport_little_xl.png');
    }

    [type='spaceport'] {
      shield-file: url('icons/intergalactic_xl.png');
    }
  }
}
