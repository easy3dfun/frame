/* [Lens] */
lens_diameter   = 60;    // mm
lens_thickness  = 1;     // mm

/* [Holder] */
wall            = 2;     // wall thickness  (mm)
ledge           = 2;     // inner shelf width that supports the lens (mm)
base_height     = 1.2;     // solid ring below the 45° chamfer (mm)
tolerance       = 0.3;   // radial clearance for fit (mm)
num_tabs        = 32;     // number of retention / flex tabs
slot_width      = 2.4;   // gap between neighbouring tabs (mm)
retention_lip   = 0.6;   // how far tabs taper inward at top (mm)
tab_height      = 2.5;   // tab height above lens surface (mm)
entry_chamfer   = 0.8;   // lead-in chamfer at top rim (mm)

$fn = 180;

// ---- derived dimensions ----
inner_d         = lens_diameter + 2 * tolerance;
outer_d         = inner_d + 2 * wall;
ledge_inner_d   = inner_d - 2 * ledge;
chamfer_h       = ledge;                       // 45° ⇒ rise = run
seat_z          = base_height + chamfer_h;     // Z where lens rests
total_h         = seat_z + lens_thickness + tab_height;

// =============================================
//  MAIN BODY
// =============================================
difference()
{
    // --- solid outer cylinder ---
    cylinder(d = outer_d, h = total_h);

    // --- lens pocket (lens rests here on the ledge) ---
    translate([0, 0, seat_z])
        cylinder(d = inner_d, h = lens_thickness + 0.01);

    // --- tapered tab bore (retention – narrows toward top) ---
    //     taper angle ≈ atan(lip / tab_height) ≈ 13°, well within 45°
    translate([0, 0, seat_z + lens_thickness])
        cylinder(
            d1 = inner_d,
            d2 = inner_d - 2 * retention_lip,
            h  = tab_height + 0.1
        );

    // --- 45° chamfer under the ledge (makes ledge printable) ---
    translate([0, 0, base_height])
        cylinder(d1 = ledge_inner_d, d2 = inner_d, h = chamfer_h);

    // --- centre through-hole (let light through the lens!) ---
    translate([0, 0, -0.1])
        cylinder(d = ledge_inner_d, h = base_height + 0.2);

    // --- flex slots (allow tabs to bend outward on lens insertion) ---
    for (i = [0 : num_tabs - 1])
        rotate([0, 0, i * 360 / num_tabs])
            translate([0, -slot_width / 2, seat_z])
                cube([outer_d, slot_width, tab_height + lens_thickness + 1]);

    // --- entry chamfer at top rim (guides the lens in) ---
    translate([0, 0, total_h - entry_chamfer])
        cylinder(
            d1 = inner_d - 2 * retention_lip,
            d2 = inner_d - 2 * retention_lip + 2 * entry_chamfer,
            h  = entry_chamfer + 0.1
        );
}
