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

module frame_clamps_tori() {
  nr_clamps = 16;
  torus_thickness = 1;
  torus_radius = 1.5;
  module tori() {
    for (i = [1 : 360/nr_clamps : 360]) {
        x = (diameter_with_tolerance/2) * cos(i);
        y = (diameter_with_tolerance/2) * sin(i);
        translate([x, y, clamp_pos_z])
            rotate([90,0,i])
            rotate_extrude(convexity = 10)
                translate([torus_radius, 0, 0])
                circle(r = torus_thickness);
    }
  }
  tori();
}
