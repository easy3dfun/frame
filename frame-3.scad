color ([0.5,0.5,0.5]) lens_rim();





// --- Hook Parameters ---
hook_width      = 3.2;     // Width of each hook (X-axis)
hook_thickness  = 1.2;   // Thickness of the hook material
frame_thickness = 2.4; // Depth of existing glasses frame
hook_drop       = 6;   // How far the hook reaches down behind the frame
rim_top_y       = 23;    // Y-coordinate where the top edge of your rim is
hook_overlap    = 0.4;     // How far down the hook base goes to fuse safely with the rim
hook_angle      = 14;     // Slight angle to match the top curve of existing glasses


lens_rim();
hooks();


/* =========================================
   MODULE DEFINITIONS
   ========================================= */

module hooks() {
    translate([22, 22, 10])
        rotate([90, 0, 145])
            single_hook();

    translate([-14, -31, 10])
        rotate([90, 0, 145])
            single_hook();
}

module single_hook() {

            linear_extrude(height = hook_width) {
                // Draw the hook profile counter-clockwise
                polygon([
                    [0, -hook_overlap],                                  // 0: inner base (fused inside rim)
                    [0, 0],                                              // 1: inner front (rests against front of frame)
                    [frame_thickness, 0],                                // 2: inner corner (rests on top of frame)
                    [frame_thickness, -hook_drop],                       // 3: inner tip (drops behind frame)
                    [frame_thickness + hook_thickness, -hook_drop],      // 4: outer tip
                    [frame_thickness + hook_thickness, hook_thickness],  // 5: outer top 
                    [-hook_thickness, hook_thickness],                   // 6: front top
                    [-hook_thickness, -hook_overlap]                     // 7: front base
                ]);
            }
}







module lens_rim() {

    /* [Lens] */
    lens_diameter   = 60;    // mm
    lens_thickness  = 1;     // mm

    /* [Holder] */
    wall            = 2;     // wall thickness  (mm)
    ledge           = 2;     // inner shelf width that supports the lens (mm)
    base_height     = 1.2;   // solid ring below the 45° chamfer (mm)
    tolerance       = 0;     // radial clearance for fit (mm)
    num_tabs        = 32;    // number of retention / flex tabs
    slot_width      = 2.4;   // gap between neighbouring tabs (mm)
    retention_lip   = 1.2;   // how far tabs taper inward at top (mm)
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

}
