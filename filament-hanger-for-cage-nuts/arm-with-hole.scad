/* = filament holder arm for m6 cage nuts
 * parts: arm v1.3
 * units: mm
 *
 * * * * *
 *
 *  This attaches to the filament holder top
 *
 * * * * */
 
screw_hole_diameter = 6.2; // mm

difference() {
    // turn the special clippy arm into a regular arm
    union() {
        translate([0,0,0]) rotate([0,0,0]) import("parts-from-others/Better-Hanging-Filament-Spool-Holder-Arm-v1.2.stl", convexity=3);
        translate([0,3.5,0]) cube([12,20,6]);
    }
    translate([-6,0,-1]) cube([6,20,8]);
    translate([12,0,-1]) cube([6,20,8]);
    
    // m6 hole
    translate([6,8,-1]) linear_extrude(8) circle(d=screw_hole_diameter, $fn=32);
}
