production_quality = false;


$fa = production_quality ?     2 :    4; // minimum angle of a fragment
$fs = production_quality ? 0.125 : 0.25; // minimum size of a fragment

lens_diameter    = 60;
tolerance        = 0.5;   // Gap on each side so the lens easily fits
frame_thickness   = 1.2;   // Walls of the frame
frame_height       = 7;
clamp_pos_z     = 4;     // Vertical position of the spheres
corner_radius    = 8;     // Radius for the rounded corners of the square box

/* Calculations */
diameter_with_tolerance = lens_diameter + 2*tolerance;

frame();

frame_clamps_tori();

module frame() {
    difference() {
        // Outer part of the ring
        cylinder(
            h = frame_height,
            d = diameter_with_tolerance,
            center = true
        );
    
        // Inner part to be removed
        cylinder(
            h = frame_height+2,
            d = diameter_with_tolerance - frame_thickness * 2,
            center = true
        );

    }
}

module frame_clamps_tori() {
  torus_thickness = 1;
  torus_radius = 1.5;
  bound = diameter_with_tolerance+frame_thickness;
  module tori() {
    for (i = [1 : 20 : 180]) {
        angle = i*10;
        x = (diameter_with_tolerance/2+1.6) * cos(angle);
        y = (diameter_with_tolerance/2+1.6) * sin(angle);
        translate([x, y, clamp_pos_z])
            rotate([90,0,i*10])
            rotate_extrude(convexity = 10)
                translate([torus_radius, 0, 0])
                circle(r = torus_thickness);
    }
  }
  intersection() {
    tori();
    // translate([-bound/2,-bound/2,0]) cube([bound,bound,10]);
  }
}
