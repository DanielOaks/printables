/* = vyper webcam high holder
 * part: holder (whole part) v1.0.0
 * units: mm
 *
 * * * * *
 *
 * Based on https://www.thingiverse.com/thing:4942227
 * Inspired by https://www.thingiverse.com/thing:5025365
 *
 * Modified by Daniel Oaks <https://danieloaks.net>.
 *
 * * * * *
 *
 *  This attaches to the Anycubic Vyper's x-axis rail and has a space
 * for a 1/4 inch screw (like used on the Logitech C922 webcam) :)
 *
 *  If you don't have one of these screws sitting around, use this:
 * https://www.thingiverse.com/thing:578514
 *
 *  This attaches the webcam holding rail pretty high because I like
 * having the camera look down onto the print for timelapses!
 *
 * * * * */

// length of the beam that extends out from it
lengthOfBeam = 80;

// hole diameter
holeDiameter = 6.35; // 6.35 == 1/4 inch

// hole length. automagically centred on beam
holeLength = 40;

// how 'high-res' the hole's rounded edges are
holeRes = 50;

// how wide the supports are
supportWidth = 3;

// how high + long the supports are
supportDimensions = 5;

// apparently copying and mirroring is something we need to
//  implement ourselves? ok
module copy_mirror(vec)
{
    children();
    mirror(vec) children();
}
 
// base object
difference() {
    translate([0,-2.5,4]) rotate([-90,0,180]) import("Kamerahalter_Vyper.stl");
    
    translate([-41,-71,-1]) cube([42,38.5,5]);
};


// beam that extends out
difference() {
    translate([-40,-32.5 - lengthOfBeam,0]) cube([40,lengthOfBeam + 1,3]);
    
    translate([-20-(holeDiameter/2),-32.5 - (lengthOfBeam / 2) - (holeLength / 2),-1]) cube([holeDiameter,holeLength,5]);
    
    translate([-20,-32.5 - (lengthOfBeam / 2),-1]) copy_mirror([0,1,0]) translate([0,-holeLength/2,0]) linear_extrude(5) circle(d=holeDiameter, $fn=holeRes);
}

// supports to help keep beam stiff
translate([-20,-32.5,3]) copy_mirror([1,0,0]) translate([20-supportWidth,0,0]) rotate([180,-90,0]) linear_extrude(supportWidth) polygon([[-1,-1],[-1,supportDimensions],[0,supportDimensions],[supportDimensions,0],[supportDimensions,-1]]);
