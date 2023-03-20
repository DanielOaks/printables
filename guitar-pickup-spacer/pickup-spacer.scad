/* = guitar pickup spacer
 * part: spacer (whole part) v1.0.0
 * units: mm, inches
 *
 * * * * *
 *
 * Modelled by Daniel Oaks <https://danieloaks.net>.
 *
 * To the extent possible under law, the person who associated CC0 with
 * this file has waived all copyright and related or neighboring rights
 * to this file.
 * You should have received a copy of the CC0 legalcode along with this
 * work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 *
 * * * * *
 *
 * This brings your guitar pickups closer to the strings :)
 *
 * * * * */

// thickness of the spacer
// mm
height = 5;

// how much the bounds overlap, to prevent 'ghosting'.
// inches
overlap = .001;

// radius of the corner between both boxes that make up the internal shape
// inches
inner_champfer_radius = 0.02;

// How detailed should curves be?
Detail_level = 2;


module copy_mirror(vec=[0,0,0], offset=[0,0,0])
{
    children();
    translate(offset) mirror(vec) children();
}

 
module box(width, length, r, rounded=true, centred=true) {
    translate([centred ? 0 : width/2, centred ? 0 : length/2]) copy_mirror([-1,0,0]) copy_mirror([0,-1,0]) {
        if (rounded) {
            translate([-overlap,-overlap]) square([overlap + width/2 - r, overlap + length/2]);
            translate([-overlap,-overlap]) square([overlap + width/2, overlap + length/2 - r]);
            translate([width/2 - r, length/2-r]) circle(r, $fn=8*Detail_level);
        } else {
            translate([-1,-1]) square([width/2+1, length/2+1]);
        }
    }
}

linear_extrude(height) {
    // convert everything from inches back to mm
    scale(25.4) difference() {
        // external shape
        hull() {
            copy_mirror([-1,0,0]) translate([1.9219,0,0]) circle(0.4375, $fn=32*Detail_level);
            box(3.5, 1.5938, .12);
        }

        // internal shape
        {
            box(3.325, 1.3125, .09);
            box(3.45, .614, .035);
        }
        
        // drill holes
        copy_mirror([-1,0,0]) translate([1.9219,0]) circle(d=0.14, $fn=8*Detail_level);
        
        // final smooth edge
        copy_mirror([-1,0,0]) copy_mirror([0,-1,0]) difference() {
            translate([1.6625, 0.307]) square(inner_champfer_radius);
            translate([1.6625 + inner_champfer_radius, 0.307 + inner_champfer_radius]) circle(inner_champfer_radius, $fn=8*Detail_level);
        }
    }
}