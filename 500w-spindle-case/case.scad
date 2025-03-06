/* = 500w spindle case
 * parts: case + lid
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
 *  I got a 500w spindle for my 3018, and needed a case for it.
 *
 * * * * */
 
// part to make
Part = "Lid"; // [Case, Lid]

// mm, width of the walls
WallWidth = 1.5;

// mm, height of any lips
LipHeight = 1.5;

// mm, Width is the side with the screw connectors.
PSUWidth = 108.5 + 4;
PSUDepth = 140.5 + 1;
PSUHeight = 50.5 + 0.5;

// mm, how much empty space at the front of the enclosure
EmptySpace = 105;

// degrees, the angle of the front panel from vertical
FrontPanelAngle = 25;

// mm, size of the hole in the front panel
FrontPanelHoleWidth = 48;
FrontPanelHoleHeight = 28.5;

// mm, location of the hole in the front panel
FrontPanelHoleX = 45;
FrontPanelHoleZ = 20;

// mm, diameter of the cable ports in the side
CablePort1Diameter = 18;
CablePort2Diameter = 15;

// mm, diameter of the ground screw cutout
// and x,z relative to the far bottom corner
// of the PSU
GroundScrewDiameter = 8;
GroundScrewX = 6;
GroundScrewZ = 40.5;

// mm, lil standoff for the pwm board. this
// should be a decent press fit. insets are how
// much of the corner we can have spacers take up.
PwmBoardWidth = 34.5;
PwmBoardLength = 34.5;
PwmBoardCornerInsets = 4;
PwmBoardX = 15;
PwmBoardY = 35;

/// calculated
TotalWidth = PSUWidth + WallWidth*2;
RoughFrontSpaceWithoutAngle = (PSUHeight + WallWidth * 2) / tan(90 - FrontPanelAngle);

module copy_mirror(vec=[0,0,0], offset=[0,0,0])
{
    children();
    translate(offset) mirror(vec) children();
}

if (Part == "Lid") {
    // lid
    //translate([0, 100 + RoughFrontSpaceWithoutAngle, PSUHeight + 10]) rotate([0,180,0])
    translate([TotalWidth/2,0,0])
    translate([0,-100,0]) {
        // core shape
        translate([-WallWidth - TotalWidth/2,0,0]) cube([TotalWidth + WallWidth*2, EmptySpace - RoughFrontSpaceWithoutAngle, WallWidth]);
        
        // walls
        copy_mirror([1,0,0]) translate([-WallWidth - TotalWidth/2, 0, WallWidth]) cube([WallWidth, EmptySpace - RoughFrontSpaceWithoutAngle, 5]);
        
        // tabs
        copy_mirror([1,0,0]) translate([-WallWidth - TotalWidth/2, 10.5, WallWidth + 2.5]) cube([2.5, 5, 2.5]);
        copy_mirror([1,0,0]) translate([-WallWidth - TotalWidth/2, EmptySpace - RoughFrontSpaceWithoutAngle - 12.5, WallWidth + 2.5]) cube([2.5, 5, 2.5]);
    }
}

if (Part == "Case") { 
    // main body
    difference() {
        // core shape
        cube([TotalWidth, PSUDepth + WallWidth + EmptySpace, PSUHeight + WallWidth*2]);
        
        // hollow out insides
        translate([WallWidth, WallWidth, WallWidth]) cube([PSUWidth, PSUDepth + EmptySpace, PSUHeight]);
     
        // PSU cutout
        translate([-1, EmptySpace + WallWidth, WallWidth]) cube([PSUWidth + WallWidth + 1, PSUDepth + 1, PSUHeight + WallWidth + 1]);
        
        // front panel cutout
        rotate([- FrontPanelAngle,0,0]) translate([-1,-PSUHeight + WallWidth,0]) cube([PSUWidth + 8,PSUHeight,PSUHeight * 3]);

        // m3 screw holes
        translate([40.8,83.7 + EmptySpace,0]) cylinder(WallWidth*3, d=4, center=true);
        translate([72.7,83.7 + EmptySpace,0]) cylinder(WallWidth*3, d=4, center=true);
        
        // cable ports in side
        translate([0,EmptySpace - CablePort1Diameter/2 - 25,(PSUHeight + WallWidth*2)/2 + 10]) rotate([0,90,0]) cylinder(WallWidth*3, d=CablePort1Diameter, center=true);

        translate([0,EmptySpace - CablePort2Diameter/2 - 55,(PSUHeight + WallWidth*2)/2 - 12]) rotate([0,90,0]) cylinder(WallWidth*3, d=CablePort2Diameter, center=true);

        // ground screw cutout
        translate([WallWidth+PSUWidth, EmptySpace+WallWidth + GroundScrewX, WallWidth + GroundScrewZ]) rotate([0,90,0]) cylinder(WallWidth*3, d=GroundScrewDiameter, center=true);

        // open lid on the empty space
        translate([TotalWidth/2, EmptySpace/2 + WallWidth + RoughFrontSpaceWithoutAngle, WallWidth + PSUHeight]) cube([PSUWidth, EmptySpace, WallWidth*3], center=true);

        // snap-fit holes for lid
        translate([WallWidth + PSUWidth/2, EmptySpace - 13, WallWidth+PSUHeight - 5]) copy_mirror([1,0,0]) translate([-PSUWidth/2 - WallWidth - 0.5,0,0]) cube([3, 6, 3]);
        translate([WallWidth + PSUWidth/2, RoughFrontSpaceWithoutAngle + 10, WallWidth+PSUHeight - 5]) copy_mirror([1,0,0]) translate([-PSUWidth/2 - WallWidth - 0.5,0,0]) cube([3, 6, 3]);
    }


    // inner chamfer at front
    difference() {
        cube([TotalWidth, WallWidth*2, PSUHeight]);

        // front panel cutout
        rotate([- FrontPanelAngle,0,0]) translate([-1,-PSUHeight + WallWidth,0]) cube([PSUWidth + 8,PSUHeight,PSUHeight * 3]);
    }

    // inner chamfer on sides
    intersection() {
        translate([TotalWidth/2,0,0]) copy_mirror([1,0,0]) translate([- TotalWidth/2,0,0]) rotate([0,45,0]) translate([WallWidth, (EmptySpace + WallWidth) / 2, WallWidth]) cube([WallWidth * 10, EmptySpace + WallWidth, WallWidth*2.1], center = true);
        
        // hollow out insides
        translate([WallWidth, WallWidth, WallWidth]) cube([PSUWidth, EmptySpace, PSUHeight]);
    }

    // pwm board holder
    translate([PwmBoardWidth/2 + WallWidth + PwmBoardX, PwmBoardLength/2 + WallWidth + PwmBoardY, WallWidth]) {
        copy_mirror([0,1,0]) copy_mirror([1,0,0]) translate([- PwmBoardWidth/2 + PwmBoardCornerInsets/2, - PwmBoardLength/2 + PwmBoardCornerInsets/2, 0]) cube([PwmBoardCornerInsets, PwmBoardCornerInsets, WallWidth], center=true);
        copy_mirror([0,1,0]) translate([0,- PwmBoardLength/2 - WallWidth/2,1.5/2]) cube([PwmBoardWidth + WallWidth*2, WallWidth, WallWidth + 1.5], center=true);
        copy_mirror([1,0,0]) rotate([0,0,90]) translate([0,- PwmBoardWidth/2 - WallWidth/2,1.5/2]) cube([PwmBoardLength + WallWidth*2, WallWidth, WallWidth + 1.5], center=true);
    }
        
    // psu stopping lip
    translate([0, EmptySpace, WallWidth]) cube([TotalWidth, WallWidth, LipHeight]);
    translate([PSUWidth + (WallWidth - LipHeight), EmptySpace, 0]) cube([LipHeight, WallWidth, PSUHeight + WallWidth]);
    translate([0, EmptySpace + WallWidth, WallWidth]) cube([WallWidth, PSUDepth, LipHeight]);

    // psu lip at end
    translate([0, EmptySpace + WallWidth + PSUDepth, 0]) cube([TotalWidth, WallWidth, WallWidth + LipHeight]);
    translate([PSUWidth + (WallWidth - LipHeight), EmptySpace + WallWidth + PSUDepth, 0]) cube([LipHeight + WallWidth, WallWidth, PSUHeight + WallWidth*2]);

    // front panel
    difference() {
        intersection() {
            // core shape
            cube([TotalWidth, PSUDepth + WallWidth + EmptySpace, PSUHeight + WallWidth*2]);

            // front panel cutout
            rotate([- FrontPanelAngle,0,0]) translate([-1,-PSUHeight + WallWidth,0]) cube([PSUWidth + 8,PSUHeight,PSUHeight * 3]);
        }

        intersection() {
            // core shape
            translate([-1,-1,-1]) cube([TotalWidth + 2, PSUDepth + WallWidth + EmptySpace + 2, PSUHeight + WallWidth*2 + 2]);

            // front panel cutout
            rotate([- FrontPanelAngle,0,0]) translate([-1,-PSUHeight,0]) cube([PSUWidth + 8,PSUHeight,PSUHeight * 3]);
        }
        
        // front panel hole
        rotate([- FrontPanelAngle,0,0]) translate([FrontPanelHoleX, -1, FrontPanelHoleZ]) cube([FrontPanelHoleWidth, 200, FrontPanelHoleHeight]);
    }
}
