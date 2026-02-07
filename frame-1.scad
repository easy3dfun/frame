production_quality = false;

$fa = production_quality ?     2 :    4; // minimum angle of a fragment
$fs = production_quality ? 0.125 : 0.25; // minimum size of a fragment

lens_diameter    = 60;
tolerance        = 0.5;   // Gap on each side so the lens easily fits
frame_thickness  = 1.2;   // Walls of the frame
frame_height     = 5;

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
      for (i = [0 : nr-1]) {
          angle = i * 360 / nr;
          x = (diameter_with_tolerance/2+plus_dist*2) * cos(angle);
          y = (diameter_with_tolerance/2+plus_dist*2) * sin(angle);
          translate([x, y, z])
              rotate([90,0,angle])
              rotate_extrude()
                  translate([radius, 0, 0])
                  circle(r = thickness);
      }
  }
  tori();
}
