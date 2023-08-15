/* = filament holder top for cage nuts
 * parts: top v1.3
 * units: mm
 *
 * * * * *
 *
 *  This slips inside of a filament roll, with two cage nuts being
 * slipped into the square cutouts in the sides.
 *
 * * * * */


cutout_size = 9.53; // mm

difference() {
    translate([0,0,0]) rotate([0,0,0]) import("parts-from-others/Better-Hanging-Filament-Spool-Holder-Tube-v1.2.stl", convexity=3);

    // cut off ends so that the thickness remaining works for cage nuts
    translate([0,-2,-2]) cube([11,54,30]);
    translate([89,-2,-2]) cube([11,54,30]);

    // main hole for the cage nuts to fit into
    translate([0,25 - cutout_size/2,10.5 - cutout_size / 2]) cube([100,cutout_size, cutout_size]);
}

// median cage nut wall thickness test pieces
//translate([11,0,-3]) cube([2.3,2.3,2.3]);
//translate([87,0,-3]) cube([2.3,2.3,2.3]);
