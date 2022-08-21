/* = customisable desiccant holder
 * parts: bottom + lid v0.0.1
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
 *  This is meant to hold desiccant beads (preferrably 3+mm ones)!
 * It has a bunch of gaps so that air can contact the beads. You'd
 * fill this box with beads, then put it inside whatever container
 * you're keeping your filament in.
 *
 *  Shapes and default dimensions are inspired by this desiccant box:
 * https://www.thingiverse.com/thing:3164954
 *
 * * * * */

/* [Main] */
Part = "bottom"; // [bottom, lid]

// (in mm)
Box_width = 48;
// (in mm)
Box_length = 40;
// (in mm)
Box_height = 15;

/* [Slots] */
// How wide should each slot be? (in mm)
Slot_width = 1.5;
// How wide between slots on the base? (in mm)
Space_between_slots = 1.68;

// How many rows of slots should there be?
Vertical_slots = 2;

/* [Walls] */
// (in mm)
Wall_thickness = 2;
// How much deeper should the lid go (in mm)
extra_lid_indent = 2;
// How much space between the walls and the lid (in mm)
Lid_tolerance = 0.3;

/* [Screws] */
// (in mm)
screw_column_size = 9;
// (in mm)
lid_screw_hole_diameter = 6;

/* [Corners] */
// (in mm)
outside_rounded_radius = 2;
// (in mm)
inside_rounded_radius = 1.5;
// (in mm)
inside_screw_column_rounded_radius = 2;
// How detailed should curves be?
Detail_level = 2;



// apparently copying and mirroring is something we need to
//  implement ourselves? ok
module copy_mirror(vec)
{
    children();
    mirror(vec) children();
}

// create a long rounded or squared-off slot
module slot(length, width, rounded=true, centred=false) {
    translate([centred ? -width/2 : 0, centred ? -length/2 : 0]) {
        if (rounded) {
            translate([0,width/2]) square([width, length - width]);
            translate([0,length/2]) copy_mirror([0,1,0]) translate([width/2,-(length/2) + width/2,0]) circle(d=width, $fn=8*Detail_level);
        } else {
            square([width, length]);
        }
    }
}

module wall_slots() {
    difference() {
        union() {
            // x slots
            translate([Box_width/2,Box_length/2,Wall_thickness])
            copy_mirror([0,1,0]) translate([0,-Box_length/2 - Wall_thickness,0]) copy_mirror([1,0,0]) {
                for (ix = [0 : (Box_width/2 - Wall_thickness - inside_rounded_radius - screw_column_size) / (Slot_width*2)]) {
                    translate([Slot_width/2 + Slot_width*2*ix,0,0]) rotate([90,0,180]) linear_extrude(Wall_thickness*3) slot(Box_height - Wall_thickness * 2, Slot_width, rounded=false);
                }
            };

            // y slots
            translate([Box_width/2,Box_length/2,Wall_thickness])
            copy_mirror([1,0,0]) translate([-Box_width/2 - Wall_thickness,0,0]) copy_mirror([0,1,0]) {
                for (iy = [0 : (Box_length/2 - Wall_thickness - inside_rounded_radius - screw_column_size) / (Slot_width*2)]) {
                    translate([0,Slot_width/2 + Slot_width*2*iy,0]) rotate([90,0,90]) linear_extrude(Wall_thickness*3) slot(Box_height - Wall_thickness * 2, Slot_width, rounded=false);
                }
            };
        }

        // vertical spaces
        if (Vertical_slots > 1) {
            translate([-1,-1,Wall_thickness])
            for (iz = [1 : Vertical_slots-1]) {
                translate([0,0,((Box_height - Wall_thickness*2)/Vertical_slots) * iz]) linear_extrude(Slot_width, center=true) square([Box_width+2,Box_length+2]);            
            }
        }
    }
}

module new_base_shape() {
    square([Box_width/2 - outside_rounded_radius, Box_length/2]);
    square([Box_width/2, Box_length/2 - outside_rounded_radius]);
    translate([Box_width/2 - outside_rounded_radius, Box_length/2 - outside_rounded_radius]) circle(r=outside_rounded_radius, $fn=32*Detail_level);
}

module new_internal_shape(tol) {
    cutoutSize = screw_column_size + Wall_thickness + tol;

    // bulk of the shape
    difference() {
        translate([-1,-1,0]) square([Box_width/2 - Wall_thickness - tol + 1, Box_length/2 - Wall_thickness - tol + 1]);
        
        // main corner cutout
        translate([Box_width/2 - cutoutSize, Box_length/2 - cutoutSize]) square(cutoutSize);
        
        // smaller cutouts
        translate([Box_width/2 - Wall_thickness - inside_rounded_radius - tol, Box_length/2 - cutoutSize - inside_rounded_radius]) square(cutoutSize);
        translate([Box_width/2 - cutoutSize - inside_rounded_radius, Box_length/2 - Wall_thickness - inside_rounded_radius - tol]) square(cutoutSize);
    }
    
    //TODO: we could increase the radius of these curves
    // depending on the Lid_tolerance – that may give a nicer
    // snap-fit? eh, too much work to bother with honestly
    
    // add the main corner chamfer
    difference() {
        mainCornerCentre = [Box_width/2 - cutoutSize + inside_screw_column_rounded_radius, Box_length/2 - cutoutSize + inside_screw_column_rounded_radius];
        
        square(mainCornerCentre);
        translate(mainCornerCentre) circle(r=inside_screw_column_rounded_radius, $fn=32*Detail_level);
    }
    
    // add the other corners
    translate([Box_width/2 - Wall_thickness - inside_rounded_radius - tol, Box_length/2 - cutoutSize - inside_rounded_radius]) circle(r=inside_rounded_radius, $fn=32*Detail_level);
    translate([Box_width/2 - cutoutSize - inside_rounded_radius, Box_length/2 - Wall_thickness - inside_rounded_radius - tol]) circle(r=inside_rounded_radius, $fn=32*Detail_level);
}


module new_base_slots(tol) {
    // have at least half a Wall_thickness away from the wall be free
    spaceToFillWithSlots = Box_width/2 - Wall_thickness*1.5 - tol;

    // see how many slots we can fit in there
    slot_average = (Space_between_slots + Slot_width) / 2;

    numberOfFreeSlotsAndSpaces = (spaceToFillWithSlots + slot_average*1.5) / slot_average;
    numberOfSlots = floor(numberOfFreeSlotsAndSpaces / 2);

    // see if we can fit another slot in there
    makeOdd = numberOfFreeSlotsAndSpaces - floor(numberOfFreeSlotsAndSpaces) >= slot_average/2;
    
    // see when to start indenting the slots
    screwColumnXStart = Box_width/2 - Wall_thickness - tol - screw_column_size - Slot_width;
    
    for (i = [0 : numberOfSlots-1]) {
        x = slot_average*2*i - Slot_width/2 + (makeOdd ? slot_average : 0);

        in_screw_column = x + Slot_width > screwColumnXStart;
        
        translate([x, Space_between_slots/2]) slot(Box_length/2 - Space_between_slots/2 - Wall_thickness - tol - Space_between_slots - (in_screw_column ? screw_column_size : 0), Slot_width);
    }
}

screwMargin = (Wall_thickness + screw_column_size)/2;

if (Part == "lid") {
    copy_mirror([1,0,0]) copy_mirror([0,1,0]) difference() {
        union() {
            // base plate
            difference() {
                // base shape
                linear_extrude(Wall_thickness/2) new_base_shape();

                // screw holes
                translate([Box_width/2 - screwMargin, Box_length/2 - screwMargin, -1]) linear_extrude(Wall_thickness + 2) circle(d=lid_screw_hole_diameter, $fn=32*Detail_level);
            }
            
            // internal shape
            linear_extrude(Wall_thickness + extra_lid_indent) new_internal_shape(Lid_tolerance);
        }

        // base slots
        translate([0,0,-1]) linear_extrude(Wall_thickness + extra_lid_indent + 2) new_base_slots(Lid_tolerance);
    }
} else if (Part == "bottom") {
    copy_mirror([1,0,0]) copy_mirror([0,1,0]) difference() {
        // base shape
        linear_extrude(Box_height - Wall_thickness/2) new_base_shape();

        // internal shape
        translate([0,0,Wall_thickness]) linear_extrude(Box_height) new_internal_shape(0);

        // base slots
        translate([0,0,-1]) linear_extrude(Wall_thickness + extra_lid_indent + 2) new_base_slots(Lid_tolerance);
        
        // wall slots
        translate([-Box_width/2, -Box_length/2]) wall_slots();
        
        // do screws here...
        
    }
}
