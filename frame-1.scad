$fn = 100;

lens_diameter = 60;
lens_height = 1.7;
frame_thickness = 1;

// color([0.5,0.5,1]) lens();

color([0.2,0.2,0.2])
difference() {
    lens(
        lens_diameter + frame_thickness,
        lens_height   + frame_thickness,
    );
    lens();
    lens(
        lens_diameter - frame_thickness,
        lens_height   + frame_thickness,
    );
}

module lens(d=60, h=1.7) {
    cylinder(h=h, d=d, center=true);
}
