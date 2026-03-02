// Parameters for a 60mm diameter, 1mm high lens
lens_diameter = 60;
lens_height = 1;
wall_thickness = 3;
base_lip = 2; // Support lip for the lens
clearance = 0.2; // Extra room for a snug fit

// High resolution for smooth circles
$fn = 100;

module lens_holder() {
    difference() {
        // Outer Body: Beveled for stability and aesthetics
        cylinder(h = lens_height + 4, 
                 d1 = lens_diameter + (wall_thickness * 2) + 2, 
                 d2 = lens_diameter + (wall_thickness * 2));

        // Lens Cavity: The space where the lens sits
        translate([0, 0, 2])
            cylinder(h = lens_height + 0.1, d = lens_diameter + clearance);

        // Viewing Aperture: Beveled at 45 degrees to avoid overhangs
        cylinder(h = 2.1, d1 = lens_diameter - (base_lip * 2), d2 = lens_diameter);
        
        // Top Entrance: Beveled for easy insertion
        translate([0, 0, lens_height + 2])
            cylinder(h = 2.1, d1 = lens_diameter + clearance, d2 = lens_diameter + clearance + 2);
    }
}

lens_holder();
