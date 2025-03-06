/* = flexible stovetop spacer
 * parts: spacer
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
 *  Little spacer for our stovetop. Ours is missing a few.
 *
 * * * * */

// How detailed should curves be?
Detail_level = 4;
$fn=16 * Detail_level;

linear_extrude(height = 6.8)
union() {
    difference() {
        square([8.1, 6.3], center=true);
        translate([0.5,3.75,0]) square([4.5, 4], center=true);
        translate([0.5,-3.75,0]) square([5, 4], center=true);
    }
    translate([0,0.2,0]) difference() {
        translate([0.45,-3,0]) circle(d=9);
        translate([0.45,-3,0]) circle(d=5);
        translate([3,-2.5,0]) square([5,5], center=true);
        translate([5.8,-4.5,0]) square([5,5], center=true);
    }
}

