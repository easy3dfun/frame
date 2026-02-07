production_quality = false;

$fa = production_quality ?     2 :    4; // minimum angle of a fragment
$fs = production_quality ? 0.125 : 0.25; // minimum size of a fragment

lens_diameter    = 60;
tolerance        = 0.5;   // Gap on each side so the lens easily fits
frame_thickness  = 1.2;   // Walls of the frame
frame_height     = 5;
corner_radius    = 8;     // Radius for the rounded corners of the square box

/* Calculations */
diameter_with_tolerance = lens_diameter + 2*tolerance;

frame();

frame_clamps_tori(12, 1, -2);

frame_clamps_tori(12, 0.75, 3);


module frame() {
    difference() {
        // Outer part of the ring
        cylinder(
            h = frame_height,
            d = diameter_with_tolerance + frame_thickness * 2,
            center = true
        );
    
        // Inner part to be removed
        cylinder(
            h = frame_height+2,
            d = diameter_with_tolerance,
            center = true
        );

    }
}

module frame_clamps_tori(
    nr        = 12,
    plus_dist = 0.75,
    z         = 0,
    ) {
    thickness = 1;
    radius = 1.5;
    module tori() {
      for (i = [1 : 360/nr : 360]) {
          x = (diameter_with_tolerance/2+plus_dist*2) * cos(i);
          y = (diameter_with_tolerance/2+plus_dist*2) * sin(i);
          translate([x, y, z])
              rotate([90,0,i])
              rotate_extrude()
                  translate([radius, 0, 0])
                  circle(r = thickness);
      }
  }
  tori();
}
