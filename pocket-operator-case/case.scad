/* = pocket operator case
 * parts: buttons v0.0.1
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
 *  Case for the pocket operator series. Mostly slight changes of
 * the Pocket Operator Case by crashdebug on Thingiverse:
 * https://www.thingiverse.com/thing:1375818
 * and this knobs set by Refa_115074 on printables:
 * https://www.printables.com/model/99290-knobs-for-pocket-operator
 *
 *  I'm optimising for nice button press feel and ease of applying
 * and reading details to show off the functions. This means
 * removing rounded edges from buttons (more space for details,
 * text, etc) and modifying the geometry to allow some hard rubber
 * to be applied to the bottom of buttons to enhance press feel.
 *
 *  The look of the raw pcbs is cool, and the silkscreens have
 * good detail that gets lost when you put on a case. The soft pro
 * cases are cool but make button presses feel icky since there's
 * nothing to keep the buttons centred and there's too much soft
 * material in the button travel path I think.
 *
 * * * * */

/* [Button] */
// Whether the labels are indented
Button_labels_indented = true;
// Deepness of indented text/etc (in mm)
Button_indent = .4;
// Thickness of the rubber on the bottom of the button (in mm)
Button_rubber_thickness = 0;



// How detailed should curves be?
Detail_level = 3;

module copy_mirror(vec=[0,0,0], offset=[0,0,0])
{
    children();
    translate(offset) mirror(vec) children();
}

use <parts-from-others/Gidole-Regular.otf>


// -- button
//translate([0,0,0]) rotate([0,0,0]) import("parts-from-others/pocase-1375818/Button_v4.stl");

// generic button set
buttons = [
    ["1", 2.8],
    ["2", 2.8],
    ["3", 2.8],
    ["4", 2.8],
    ["*", 8],
    //["key", 2],
    //["chrd", 2],
    //["solo", 2],
    //["glide", 2],
    //["acc", 2],
    //["rec", 2],
    ["5", 2.8],
    ["6", 2.8],
    ["7", 2.8],
    ["8", 2.8],
    ["FX", 2.6],
    ["9", 2.8],
    ["10", 2.8],
    ["11", 2.8],
    ["12", 2.8],
    ["play", 2],
    ["13", 2.8],
    ["14", 2.8],
    ["15", 2.8],
    ["16", 2.8],
    [".", 17],
    ["S", 2.8],
    ["P", 2.8],
    ["bpm", 2],
];

translate([8,-105+59.5 - 12.5,1.6+2.6+0.6])
for (i = [ 0 : len(buttons) - 1 ]) 
{
    translate([11 * (i % 5),i < 20 ? floor(i / 5) * -12.5 : 12.5,0])
    union() {
        translate([0,0,Button_rubber_thickness])
        difference() {
            union() {
                linear_extrude(7 - Button_rubber_thickness) circle(r=3.3, $fn=8*Detail_level);
                copy_mirror([-1,0,0]) translate([0,-.75,0]) cube([4.9,1.5,3 - Button_rubber_thickness]);
            }
            if (Button_labels_indented) {
                translate([0,0,7 - Button_rubber_thickness - Button_indent]) linear_extrude(Button_indent*2) text(buttons[i][0], size=buttons[i][1], halign="center", valign="center", font="Gidole", $fn=8*Detail_level);
            }
        }
        if (!Button_labels_indented) {
            translate([0,0,7 - Button_rubber_thickness - Button_indent]) linear_extrude(Button_indent*2) text(buttons[i][0], size=buttons[i][1], halign="center", valign="center", font="Gidole", $fn=8*Detail_level);
        }
        copy_mirror([-1,0,0]) translate([3.3,-.75,0]) cube([1.6,1.5,3]);
    }
}

/*
// -- top case
translate([0,-105,-9]) rotate([180,0,0])
//import("parts-from-others/pocase-1375818/Case_Front_full_v6_rotated.stl");
import("parts-from-others/pocase-1375818/Case_Front_full_v6_mic_rotated.stl");


// -- bottom case
translate([0,-105,-9]) rotate([0,0,0]) import("parts-from-others/pocase-1375818/Case_Back_full_v5.stl");


// po-10 series stl, from teenage engineering
// to check for fitment, etc
translate([0,19,-21.235]) rotate([90,0,0]) import("parts-from-others/teenage-engineering/po-cad.stl");
*/
