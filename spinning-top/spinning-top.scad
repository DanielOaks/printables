/* = printable spinning top
 * parts: main + tip v0.0.1
 * units: mm
 *
 * * * * *
 *
 * Designed by Daniel Oaks <https://danieloaks.net>.
 *
 * To the extent possible under law, the person who associated CC0 with
 * this file and design has waived all copyright and related or
 * neighboring rights to this file and design.
 * You should have received a copy of the CC0 legalcode along with this
 * work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 *
 * * * * *
 *
 *  Spinning top! In OpenSCAD! Who could imagine this!
 *
 *  Shapes and dimensions are inspired by this spinning top:
 * https://www.thingiverse.com/thing:672473
 * It's super fun to print and play with, give it a shot!
 *
 * * * * */

Ring_inner_radius = 24;
Ring_outer_radius = 32;
Ring_height = 10;
Ring_twist = 20;
Ring_top_scale = 1.15;
Ring_top_flat_width = 2;
Ring_strut_width = 4.5;

Stem_radius = 7.5;
Stem_height = 50;
Stem_top_scale = 0.65;
Stem_cuts_radius = Stem_radius * .7;
Stem_cuts_distance = Stem_radius * 1.2;
Stem_cuts_twist = 185;

Tip_radius = 3.5;
Tip_expected_compliance_flex = 0.1;
Tip_depth = 8;
Tip_extended_depth = 2;
Tip_tapered_length = 11;

Compliance_distance = 0.5;
Compliance_width = 0.6;
Compliance_depth = Tip_depth;

// How detailed should curves be?
Detail_level = 4;
$fn=16 * Detail_level;

difference() {
    union() {
        difference() {
            linear_extrude(height = Ring_height, twist = Ring_twist, scale = Ring_top_scale)
            union() {
                // main outer ring
                difference() {
                    circle(r = Ring_outer_radius);

                    circle(r = Ring_inner_radius);
                }
                
                // struts to the inside
                square([Ring_strut_width, Ring_inner_radius * 2 + 2], center = true);
                rotate([0,0,90]) square([Ring_strut_width, Ring_inner_radius * 2 + 2], center = true);
            }
            
            // cute curve on top of the ring
            translate([0,0,Ring_height]) scale([1,1,0.1]) sphere(r = Ring_outer_radius * Ring_top_scale - Ring_top_flat_width);
        }

        // the stem itself
        linear_extrude(height = Stem_height, scale = Stem_top_scale) circle(r = Stem_radius);
    }
    
    // hole for the tip in the base
    translate([0,0,-0.1]) linear_extrude(height = Tip_depth) circle(r = Tip_radius + 0.3);

    // compliance for tip insertion.
    // tl;dr introduces flex, making it easier to insert tip into base!
    translate([0,0,-0.1]) linear_extrude(height = Compliance_depth) 
    union() {
        difference() {
            circle(r = Tip_radius + Compliance_distance + Compliance_width);
            circle(r = Tip_radius + Compliance_distance);
            square([Tip_radius * 0.7, Tip_radius * 4], center = true);
        }
        square([(Tip_radius + Compliance_distance + Compliance_width / 2) * 2, Compliance_width * 1.8], center = true);
    }
    
    // reduce weight in the stem
    start = max(Compliance_depth, Tip_depth, Ring_height) + 1 + Stem_cuts_radius;
    translate([0,0,start]) linear_extrude(height = Stem_height - start, twist = Stem_cuts_twist, scale = Stem_top_scale) {
        translate([-Stem_cuts_distance,0,0]) circle(r = Stem_cuts_radius);
        translate([Stem_cuts_distance,0,0]) circle(r = Stem_cuts_radius);
        translate([0,-Stem_cuts_distance,0]) circle(r = Stem_cuts_radius);
        translate([0,Stem_cuts_distance,0]) circle(r = Stem_cuts_radius);
    }
    union() {
        translate([0,0,start + 0.01]) scale([1,1,0.5]) intersection() {
            union() {
                translate([Stem_cuts_distance,0,0]) sphere(r = Stem_cuts_radius);
                translate([-Stem_cuts_distance,0,0]) sphere(r = Stem_cuts_radius);
                translate([0,Stem_cuts_distance,0]) sphere(r = Stem_cuts_radius);
                translate([0,-Stem_cuts_distance,0]) sphere(r = Stem_cuts_radius);
            }
                translate([0,0,-Stem_cuts_radius / 2]) cube([Ring_outer_radius * 2, Ring_outer_radius * 2, Stem_cuts_radius], center = true);
        }
    }
}

// add sphere at top of the stem
translate([0,0,Stem_height]) sphere(r = Stem_radius * Stem_top_scale);

// tips
for (i = [-2 : 2]) {
    rotate([0,0,i*18])
    translate([Ring_outer_radius * max(1.0, Ring_top_scale) + Tip_radius + 5,0,0]) {
        linear_extrude(height = Tip_depth + Tip_extended_depth) circle(r = Tip_radius + Tip_expected_compliance_flex * i);
        
        translate([0,0,Tip_depth + Tip_extended_depth]) linear_extrude(height = Tip_tapered_length, scale = 0) circle(r = Tip_radius);
    }
}
    