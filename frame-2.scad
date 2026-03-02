$fn = 120; // High resolution for smooth circular curves

// --- Lens Parameters ---
lens_diameter = 60.0;
lens_thickness = 1.0;

// --- Frame Parameters ---
tolerance = 0.3;       // Extra clearance in the groove to ensure the lens fits
lip_width = 2.0;       // How much the plastic lip overlaps the lens (retention)
wall_thickness = 2.5;  // Thickness of the outer solid wall
gap_angle = 3;        // Opening angle (slit) allowing the frame to flex

// --- Derived Dimensions ---
groove_radius = (lens_diameter / 2) + tolerance;
inner_radius  = groove_radius - lip_width;
outer_radius  = groove_radius + wall_thickness;

// Heights are calculated to create exactly 45-degree overhangs
// (In a 45-deg triangle, the height equals the width)
bottom_chamfer_h = lip_width;
slot_h           = lens_thickness + 0.3; // Slot height with slight vertical clearance
top_chamfer_h    = lip_width;
total_h          = bottom_chamfer_h + slot_h + top_chamfer_h;

// --- 2D Profile of the Ring ---
// Coordinates [X, Y] defined counter-clockwise starting from bottom-inner edge
frame_profile = [
    [inner_radius, 0],                                // Bottom inner edge
    [outer_radius, 0],                                // Bottom outer edge
    [outer_radius, total_h],                          // Top outer edge
    [inner_radius, total_h],                          // Top inner edge
    [groove_radius, bottom_chamfer_h + slot_h],       // Upper inner corner of groove
    [groove_radius, bottom_chamfer_h]                 // Lower inner corner of groove
];

    // 1. Main C-Ring Frame
    // Rotated so the gap is evenly centered on the X-axis
    rotate([0, 0, gap_angle / 2])
        rotate_extrude(angle = 360 - gap_angle, convexity = 10)
            polygon(frame_profile);


