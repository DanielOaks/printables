/* = desk cable clip
 * part: clip (whole part) v2.0.0
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
 *  This hangs over the edge of your desk and has a holder underneath
 * which you can put cables into. I use it to hold an LED light strip!
 *
 *  If this is holding a lot of weight you may want to adjust the top
 * corner's chamfer. It's designed more for looks than effectiveness :)
 *
 * * * * */
include <Round-Anything/polyround.scad>

// the thickness of the main piece of material
thickness = 6;
// how 'wide' the clip is. this makes it more stable
//  but also increases print time.
clipSize = 6;

// how thick the desk is.
// i.e. how wide will the 'jaw' of the holder need to be?
deskThickness = 24.8;

// how far will the top bar extend over the desk?
topBarWidth = 45;
// how much will the top corner be chamfered?
topCornerChamfer = thickness/4;

// how wide should the space in the holder be?
spaceWidth = 15;
// how wide and high should the holder itself be?
holderWidth = 30;
holderHeight = 20;

function clipPoints(dT, tBW, sW, hH, hW)=[
    // hidden point to make the top bar end rounded
    [-tBW+thickness, -thickness, 0],
    // top bar end
    [-tBW+thickness, 0, tBW/2],
    // corner
    [0.01,  0.01,  topCornerChamfer],
    // main vertical bar
    [0,  -dT-hH-thickness,  thickness],
    // curve of the holder
    [-hW, -dT-hH-thickness, max(hH, hW)],
    [-hW, -dT-thickness, max(hH, hW)],
    // last point of the holder
    [-sW, -dT-thickness, thickness*3],
    
];

difference() {
    linear_extrude(clipSize) {
        radiiPoints=clipPoints(deskThickness, topBarWidth, spaceWidth, holderHeight, holderWidth);
        polygon(polyRound(beamChain(radiiPoints,offset1=0, offset2=-thickness),20));
    }
    translate([-topBarWidth,-deskThickness,-clipSize/2]) cube([topBarWidth,deskThickness,clipSize*2]);
}
