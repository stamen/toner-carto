@text_font_transport_bold: 'Arial Bold';
@label_color_transport: #000;
@text_font_halo_radius_sm: 1;
@label_color_transport_halo: #fff;
@text_font_size_xxsm: 10;
@text_font_size_xsm: 12;
@text_font_size_sm: 13;
@text_font_size_medium: 14;
@text_font_size_medium_plus: 16;
@text_font_halo_radius_large: 2;

#minor_road_labels {
  text-name: "[name]";
  text-face-name: @text_font_transport_bold;
  text-placement: line;
  text-max-char-angle-delta: 30;
  text-fill: @label_color_transport;
  text-halo-radius: @text_font_halo_radius_sm;
  text-halo-fill: @label_color_transport_halo;
  text-spacing: 100;
  
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

  [zoom>=16][highway='primary'] {
	text-halo-radius: @text_font_halo_radius_large;
  }
  [is_tunnel=1][zoom>=15] {
	text-fill: #777;
  }
  [zoom=12] {
    text-dy: 7;
    text-size: @text_font_size_xsm;
  }
  [zoom=13] {
    text-dy: 8;
    [highway='trunk'] {
		text-size: @text_font_size_sm;
    }
    [highway='primary'] {
		text-size: 13;
    }
  }

  [zoom=14] {
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

