/* = test cage nut holder
 * parts: holder
 * units: mm
 *
 * * * * *
 *
 * This probably isn't complex enough to be covered by copyright but...
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
 *  This can be used to test cutout sizes and wall
 * thicknesses, to see whether a given sizing works.
 *
 * * * * */

cube_size = 20; // mm
cutout_size = 9.53; // mm
wall_thickness = 2.3; // mm

module copy_mirror(vec=[0,0,0], offset=[0,0,0])
{
    children();
    translate(offset) mirror(vec) children();
}

module copy_rotate(vec=[0,0,0])
{
    children();
    rotate(vec) children();
}

copy_rotate([0,0,90]) copy_mirror([0,1,0]) translate([-cube_size / 2,cube_size/2 - wall_thickness,0]) {
    difference() {
        cube([cube_size,wall_thickness,cube_size]);
        translate([cube_size/2 - cutout_size/2,-1,cube_size/2 - cutout_size/2]) cube([cutout_size,wall_thickness+2,cutout_size]);
    }
 }
 