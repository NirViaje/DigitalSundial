
//*************************************************************//
//   [EN]  ---   DIGITAL SUNDIAL
//   [FR]  ---   CADRAN SOLAIRE NUMERIQUE
//*************************************************************//
//
//      Author: Mojoptix
//      website: www.mojoptix.com
//      Email: julldozer@mojoptix.com
//      Date: 13 october 2015
//      License: Creative Commons CC-BY (Attribution)
//
//*************************************************************//

//
//   [EN]   The episode #001 of the video podcast Mojoptix describes this sundial in details:
//              http://www.mojoptix.com/fr/2015/10/12/ep-001-cadran-solaire-numerique
//

//
//   [FR]   L'episode #001 du podcast video mojoptix decrit ce cadran solaire en detail:
//              http://www.mojoptix.com/fr/2015/10/12/ep-001-cadran-solaire-numerique
//

//*************************************************************//


// Choose what you want to print/display:
// 1: the gnomon
// 2: the central connector piece
// 3: the top part of the lid 
// 4: the bottom part of the lid
// 10: display everything
FLAG_PRINT = 4;

FLAG_northern_hemisphere = 1;   // set to 1 for Northen Hemisphere, set to 0 for Southern Hemisphere

FLAG_gnomon_brim = 0;   // Add a brim to the gnomon
FLAG_bottom_lid_support = 1;    // Add some support structure for the lid teeth



/* ************************************************************************/
/* PARAMETERS *************************************************************/
/*************************************************************************/
epsilon_thickness = 0.02; // used to ensure openscad is not confused by almost identical surfaces

gnomon_brim_thickness = 0.3;
gnomon_brim_width = 10;
gnomon_brim_gap = 0.1;

FLAG_mirror_x_characters = 1;     // set to 0 if viewing directly the characters on the blocks, set to 1 if viewing their reflection of a surface

gnomon_radius = 30; // (change at your own risks !)

pixel_size_x = gnomon_radius*8.0/40.0;
pixel_size_y = gnomon_radius*1.0/40.0;
pixel_pitch_x = gnomon_radius*10.0/40.0;
pixel_pitch_y = gnomon_radius*10.0/40.0;

grid_pixel_depth = 0.1;

nn = 40.0/gnomon_radius;

/* ************************************************************************/
/* FONT *******************************************************************/
/* ************************************************************************/
/* index in the array   0 1 2 3 4 5 6 7 8 9 10 11           12
   Characters:          0 1 2 3 4 5 6 7 8 9 :  {full white} {full dark}
Note: 
	1st coordinate in the array: the index in the array (see above)
	2nd coordinate in the array: the Y (!!) coordinate
	3nd coordinate in the array: the X coordinate   
*/
font_nb_pixel_x = 4;    // 4 pixels wide
font_nb_pixel_y = 6;    // 6 pixels high

font_char = [[
                            [0,1,1,0],	//index 0: character "0"
                            [1,0,0,1],
                            [1,0,1,1],
                            [1,1,0,1],
                            [1,0,0,1],
                            [0,1,1,0],
                       ],[
                            [0,1,0,0],	//index 1: character "1"
                            [1,1,0,0],
                            [0,1,0,0],
                            [0,1,0,0],
                            [0,1,0,0],
                            [1,1,1,0],
                       ],[
                            [0,1,1,0],	//index 2: character "2"
                            [1,0,0,1],
                            [0,0,0,1],
                            [0,1,1,0],
                            [1,0,0,0],
                            [1,1,1,1],
                       ],[
                            [0,1,1,0],	//index 3: character "3"
                            [1,0,0,1],
                            [0,0,1,1],
                            [0,0,0,1],
                            [1,0,0,1],
                            [0,1,1,0],
                       ],[
                            [1,0,0,1],	//index 4: character "4"
                            [1,0,0,1],
                            [1,0,0,1],
                            [1,1,1,1],
                            [0,0,0,1],
                            [0,0,0,1],
                       ],[
                            [1,1,1,1],	//index 5: character "5"
                            [1,0,0,0],
                            [1,1,1,0],
                            [0,0,0,1],
                            [0,0,0,1],
                            [1,1,1,0],
                       ],[
                            [0,1,1,1],	//index 6: character "6"
                            [1,0,0,0],
                            [1,1,1,0],
                            [1,0,0,1],
                            [1,0,0,1],
                            [0,1,1,0],
                       ],[
                            [1,1,1,1],	//index 7: character "7"
                            [0,0,0,1],
                            [0,0,0,1],
                            [0,0,1,0],
                            [0,1,0,0],
                            [1,0,0,0],
                       ],[
                            [0,1,1,0],	//index 8: character "8"
                            [1,0,0,1],
                            [0,1,1,0],
                            [1,0,0,1],
                            [1,0,0,1],
                            [0,1,1,0],
                       ],[
                            [0,1,1,0],	//index 9: character "9"
                            [1,0,0,1],
                            [1,0,0,1],
                            [0,1,1,1],
                            [0,0,0,1],
                            [1,1,1,0],
                       ],[
                            [0,0,0,0],	//index 10: character ":"
                            [0,0,0,0],
                            [0,1,0,0],
                            [0,0,0,0],
                            [0,1,0,0],
                            [0,0,0,0],
                       ],[
                            [1,1,1,1],	//index 11: character {full white}
                            [1,1,1,1],
                            [1,1,1,1],
                            [1,1,1,1],
                            [1,1,1,1],
                            [1,1,1,1],
                       ],[
                            [0,0,0,0],	//index 12: character {full dark}
                            [0,0,0,0],
                            [0,0,0,0],
                            [0,0,0,0],
                            [0,0,0,0],
                            [0,0,0,0],
                       ]
                      ];


/* ************************************************************************/
/* MODULES ****************************************************************/
/* ************************************************************************/

/* ************************************************************************/
module extrude_pixel(direction_angle_x,direction_angle_y, pixel_wall_angle_x, pixel_wall_angle_y) {
/* Extrude a pixel in a given direction.
   input: 
        direction_angle_x: extrusion angle (from the normal to the pixel) in the x direction
        direction_angle_y: extrusion angle (from the normal to the pixel) in the y direction
   Return a (positive) solid that can then be substracted from another solid 
   (Origin at the center of the base pixel)
*/
    // compute geometry
    top_pixel_location_z = 2*gnomon_radius;     // ie: somewhere outside the gnomon
//    top_pixel_location_x = top_pixel_location_z * tan(direction_angle_x);
//    top_pixel_location_y = top_pixel_location_z * tan(direction_angle_y); 
    top_pixel_size_x = pixel_size_x +2*top_pixel_location_z*tan(pixel_wall_angle_x);    // account for the non_vertical pixel walls
    top_pixel_size_y = pixel_size_y +2*top_pixel_location_z*tan(pixel_wall_angle_y);
    // build (positive) geometry: extrude vertically then rotate
    rotate([direction_angle_y,direction_angle_x,0])     // rotate the whole extrusion in the chosen direction
        hull(){
            rotate([-direction_angle_y,-direction_angle_x,0])  // derotate the base pixel (to keep it flat at the bottom)
                cube([pixel_size_x,pixel_size_y,epsilon_thickness], center=true);
            translate([0,0,top_pixel_location_z])
                cube([top_pixel_size_x, top_pixel_size_y,epsilon_thickness], center=true);
        }
}


/* ************************************************************************/
module extrude_character(font_index, direction_angle_x, direction_angle_y, pixel_wall_angle_x, pixel_wall_angle_y) {
/* Extrude a (pixelated) character in a given direction:
   input: 
	font_index: the index of the character in the font array
        direction_angle_x: extrusion angle (from the normal to the pixel) in the x direction
        direction_angle_y: extrusion angle (from the normal to the pixel) in the y direction
   Return a (positive) solid that can then be substracted from another solid 
   (Origin at the center of the base character)
*/
    for (tx=[0:(font_nb_pixel_x-1)]){
            for (ty=[0:(font_nb_pixel_y-1)]){ 
                if(FLAG_mirror_x_characters==0) { // Note: y is the 2nd coordinate, x is the 3rd (see definition of the Font)
                    if(font_char[font_index][ty][tx]==1) { 
                            translate([(tx-(font_nb_pixel_x-1)/2)*pixel_pitch_x, (ty-(font_nb_pixel_y-1)/2)*pixel_pitch_y,0]){
                                    extrude_pixel(direction_angle_x,direction_angle_y, pixel_wall_angle_x, pixel_wall_angle_y);
                            }
                    }
                }
                else {  // mirror the characters across x
                    if(font_char[font_index][ty][font_nb_pixel_x-1-tx]==1) {  
                            translate([(tx-(font_nb_pixel_x-1)/2)*pixel_pitch_x, (ty-(font_nb_pixel_y-1)/2)*pixel_pitch_y,0]){
                                    extrude_pixel(direction_angle_x,direction_angle_y, pixel_wall_angle_x, pixel_wall_angle_y);
                            }
                    }
                }
                    
    }}
}


/* ************************************************************************/
module build_create_pixel_grid(pixel_depth, ID_column_OFF=[]) {
/* Create a grid where each intersection row/column is a potential pixel
   Input: 
        pixel_depth: the depth of the pixel grid
        ID_column_OFF: list all the columns that should be left OFF (eg not built), exemple: [0,1]
   Return a (positive) solid that can then be substracted from another solid 
   (Origin at the center of the base character)
*/
    if (len(ID_column_OFF)<font_nb_pixel_x) {
        intersection(){
            cube([(font_nb_pixel_x+1)*pixel_pitch_x,(font_nb_pixel_y)*pixel_pitch_y,pixel_depth*3], center=true);  // the column imprint only goes from the bottom to the top row
            // Draw the columns
            union(){
                for (tx=[0:(font_nb_pixel_x-1)]){
                    FLAG_draw_this_column = len( search(tx, ID_column_OFF) ) ==  0;
                    if (FLAG_draw_this_column ){
                        translate([(tx-(font_nb_pixel_x-1)/2)*pixel_pitch_x, 0,pixel_depth/2])
    //                        cube([pixel_size_x,gnomon_radius*3,pixel_depth+epsilon_thickness], center=true);
                            cube([0.1,gnomon_radius*3,pixel_depth], center=true);                    
                    }
                }
            }
        }
    }
        //Draw the rows
        union(){
            for (ty=[0:(font_nb_pixel_y-1)]){ 
                translate([0, (ty-(font_nb_pixel_y-1)/2)*pixel_pitch_y,pixel_depth/2])
//                    cube([gnomon_radius*30,1.5*pixel_size_y,pixel_depth+epsilon_thickness], center=true);
                    cube([gnomon_radius*30,0.1,pixel_depth], center=true);
            }
        }
}    

/* ************************************************************************/
module build_block(gnomon_thickness, char_list, char_angle_x, char_angle_y, pixel_wall_angle_x, pixel_wall_angle_y) {
/* Build a block with a set of characters */
    difference(){
        union(){
        // Build The gnomon shape
            intersection(){
                translate([0,0,gnomon_radius/2])
                        cube([gnomon_thickness,2*gnomon_radius,gnomon_radius], center=true);
                translate([0,0,0])
                        rotate([90,0,90]) cylinder(r=gnomon_radius, h=gnomon_thickness, center=true, $fn=100);
            }
        }
            
        // Carve the light guides for each number
        for (ti = [0:(len(char_list)-1)]){
            extrude_character(char_list[ti],char_angle_x[ti],char_angle_y[ti], pixel_wall_angle_x, pixel_wall_angle_y);
        }
    }
    // Add a brim
    if (FLAG_gnomon_brim == 1) {
#        color("green"){
            difference(){
                cube([gnomon_thickness, gnomon_radius*2+gnomon_brim_width*2, gnomon_brim_thickness],center=true);
                cube([10*gnomon_thickness, gnomon_radius*2+gnomon_brim_gap*2, 10*gnomon_brim_thickness],center=true);
            }
        }}
}

/* ************************************************************************/
module build_spacer_block(gnomon_thickness) {
/* Build a spacer block*/
    color("red"){
     difference(){   
        // The gnomon shape
            intersection(){
                translate([0,0,gnomon_radius/2])
                        cube([gnomon_thickness+epsilon_thickness,2*gnomon_radius,gnomon_radius], center=true);
                translate([0,0,0])
                        rotate([90,0,90]) cylinder(r=gnomon_radius, h=gnomon_thickness+epsilon_thickness, center=true, $fn=100);
            }
        // The pixel grid
        build_create_pixel_grid(grid_pixel_depth, ID_column_OFF=[0,1,2,3,4]);
    }
    }
    // Add a brim
    if (FLAG_gnomon_brim == 1) {
#        color("green"){
            difference(){
                cube([gnomon_thickness, gnomon_radius*2+gnomon_brim_width*2, gnomon_brim_thickness],center=true);
                cube([10*gnomon_thickness, gnomon_radius*2+gnomon_brim_gap*2, 10*gnomon_brim_thickness],center=true);
            }
        }}    


}

/* ************************************************************************/
module build_round_top_block() {
    gnomon_thickness = gnomon_radius;
/* Build a round top block*/
    color("green"){
        intersection(){
            translate([0,0,gnomon_radius/2])
                    cube([gnomon_thickness,2*gnomon_radius,gnomon_radius], center=true);
            translate([gnomon_radius/2,0,0])
                    scale([0.3,1,1]) sphere(r=gnomon_radius, center=true, $fn=100);
        }
    }

    // Add a brim
    if (FLAG_gnomon_brim == 1) {
#        color("green"){
            difference(){
                translate([0.35*gnomon_thickness-gnomon_brim_width/2,0,0]) cube([0.3*gnomon_thickness+gnomon_brim_width, gnomon_radius*2+gnomon_brim_width*2, gnomon_brim_thickness],center=true);
                translate([gnomon_radius/2,0,0])
                    minkowski(){
                        scale([0.3,1,1]) sphere(r=gnomon_radius, center=true, $fn=100);
                        sphere(r=gnomon_brim_gap, center=true, $fn=10);
                    }
            }
        }}    
    
}
/* ************************************************************************/
module Block_hours_tens() {
    color("blue"){
    gnomon_thickness = gnomon_radius*45.0/40.0; //45;
    pixel_wall_angle_x = 0;         // [degrees] angle of the walls along the x direction
    pixel_wall_angle_y = 6.0;         // [degrees] angle of the walls along the y direction    
    char_angle_x = [0,0,0,0,0,0,0];
    char_angle_y = [-45,-30,-15,0,15,30,45];
    char_list = [1,1,1,1,1,1,1];
    difference(){
        build_block(gnomon_thickness, char_list, char_angle_x, char_angle_y, pixel_wall_angle_x, pixel_wall_angle_y);
        build_create_pixel_grid(grid_pixel_depth, ID_column_OFF=[]);
    }
}}

/* ************************************************************************/
module Block_hours_units() {
    color("blue"){
    gnomon_thickness = gnomon_radius*45.0/40.0; //45;
    pixel_wall_angle_x = 0;         // [degrees] angle of the walls along the x direction
    pixel_wall_angle_y = 6.0;         // [degrees] angle of the walls along the y direction    
    char_angle_x = [0,0,0,0,0,0,0];
    char_angle_y = [-45,-30,-15,0,15,30,45];
    char_list = [0,1,2,3,4,5,6];
    difference(){
        build_block(gnomon_thickness, char_list, char_angle_x, char_angle_y, pixel_wall_angle_x, pixel_wall_angle_y);
        build_create_pixel_grid(grid_pixel_depth, ID_column_OFF=[]);
    }    
}}

/* ************************************************************************/
module Block_minutes_tens() {
    color("blue"){
    gnomon_thickness = gnomon_radius*45.0/40.0; //45;
    pixel_wall_angle_x = 0;         // [degrees] angle of the walls along the x direction
    pixel_wall_angle_y = 1.0;         // [degrees] angle of the walls along the y direction    
    char_angle_x = [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0];
    char_angle_y = [-50,-45,-40, -35,-30,-25, -20,-15,-10, -5,0,5, 10,15,20, 25,30,35, 40];
    char_list = [0,2,4, 0,2,4, 0,2,4, 0,2,4, 0,2,4, 0,2,4, 0];
    difference(){
        build_block(gnomon_thickness, char_list, char_angle_x, char_angle_y, pixel_wall_angle_x, pixel_wall_angle_y);
        build_create_pixel_grid(grid_pixel_depth, ID_column_OFF=[]);
    }    
}}

/* ************************************************************************/
module Block_minutes_units() {
    color("blue"){
    gnomon_thickness = gnomon_radius*45.0/40.0; //45;
    pixel_wall_angle_x = 0;         // [degrees] angle of the walls along the x direction
    pixel_wall_angle_y = 8.0;         // [degrees] angle of the walls along the y direction    
    char_angle_x = [0,0,0,0,0,0,0];
    char_angle_y = [-45,-30,-15,0,15,30,45];
    char_list = [0,0,0,0,0,0,0];
    difference(){
        build_block(gnomon_thickness, char_list, char_angle_x, char_angle_y, pixel_wall_angle_x, pixel_wall_angle_y);
        build_create_pixel_grid(grid_pixel_depth, ID_column_OFF=[]);
    }    
}}

/* ************************************************************************/
module Block_semicolon() {
    color("blue"){
    gnomon_thickness = gnomon_radius*25.0/40.0; //25;
    pixel_wall_angle_x = 0;         // [degrees] angle of the walls along the x direction
    pixel_wall_angle_y = 8.0;         // [degrees] angle of the walls along the y direction    
    char_angle_x = [0,0,0,0,0,0,0];
    char_angle_y = [-45,-30,-15,0,15,30,45];
    char_list = [10,10,10,10,10,10,10];
    difference(){
        build_block(gnomon_thickness, char_list, char_angle_x, char_angle_y, pixel_wall_angle_x, pixel_wall_angle_y);
        build_create_pixel_grid(grid_pixel_depth, ID_column_OFF=[3]);
    }    
}}

/* ************************************************************************/
module Block_rotating_base_upper() {
/* Build the upper part of the rotating base */
    gnomon_thickness = gnomon_radius;
    Screw_hole_diameter = 6.5;
    Nut_width_blocking = 8.8+1.3;
    Nut_width_non_blocking = 11.2;
    Washer_Diameter = 11.9;
    Washer_thickness = 1.3;
    color("green"){
    difference(){
        // Build The gnomon shape
        union(){
            intersection(){
                translate([0,0,gnomon_radius/2])
                        cube([2/3*gnomon_thickness,2*gnomon_radius,gnomon_radius], center=true);
                translate([0,0,0])
                        rotate([90,0,90]) cylinder(r=gnomon_radius, h=gnomon_thickness, center=true, $fn=100);
            }
        }
        // The negative space for the screw, nut and washer
        translate([0,0,Washer_Diameter/2+3])
            rotate([90,0,90]) cylinder(r=Screw_hole_diameter/2, h=2*gnomon_thickness, center=true, $fn=100);
        translate([gnomon_thickness*(0.45-1/3),0,Washer_Diameter/2+3])
            rotate([90,0,90]) cylinder(r=Washer_Diameter/2+4, h=Washer_thickness+2, center=true, $fn=100);
        translate([gnomon_thickness*(0.45-1/3),0,0])
             cube([Washer_thickness+2,Washer_Diameter+8, 2*(Washer_Diameter/2+3)], center=true);
        translate([gnomon_thickness*(0.4-2/3),0,0])
             cube([gnomon_thickness*0.8+1,Nut_width_blocking, 2*(Washer_Diameter/2+3)], center=true);
        intersection(){        
            translate([gnomon_thickness*(0.45-2/3),0,Washer_Diameter/2+3])
                cube([gnomon_thickness, 2*(Nut_width_non_blocking/2+1), 2*(Nut_width_non_blocking/2+1)],center=true); 
            translate([gnomon_thickness*(0.45-2/3),0,Washer_Diameter/2+3-epsilon_thickness])
                cube([gnomon_thickness*2/3+1,Nut_width_blocking, gnomon_radius], center=true);            
        }
            translate([gnomon_thickness*(0.45-2/3),0,0])
                cube([gnomon_thickness*2/3+1,Nut_width_blocking+1, 1], center=true);
    }
    }
    
    // Add a brim
    if (FLAG_gnomon_brim == 1) {
#        color("green"){
            difference(){
                translate([gnomon_brim_width/2,0,0,]) cube([2/3*gnomon_thickness+gnomon_brim_width, gnomon_radius*2+gnomon_brim_width*2, gnomon_brim_thickness],center=true);
               translate([-2/3*gnomon_thickness/2,0,0,]) cube([2*2/3*gnomon_thickness+gnomon_brim_gap*2, gnomon_radius*2+gnomon_brim_gap*2, 10*gnomon_brim_thickness],center=true);
            }
        }}
}

/* ************************************************************************/
module Block_rotating_base_mid() {
/* Build the mid part of the rotating base */
    gnomon_thickness = 1.3*gnomon_radius;
    Screw_hole_diameter = 6.5;
    Nut_width_blocking = 8.8;
    Nut_width_non_blocking = 11.2;
    Washer_Diameter = 11.9;
    Washer_thickness = 1.3;
    color("red"){

    // The connection to the gnomon
    difference(){
        union(){
            // The gnomon shape
            intersection(){
                translate([0,0,gnomon_radius/2])
                        cube([gnomon_thickness,2*gnomon_radius,gnomon_radius], center=true);
                translate([0,0,0])
                        rotate([90,0,90]) cylinder(r=gnomon_radius, h=gnomon_thickness, center=true, $fn=100);
            }
            // The connection to the base
            intersection(){
                translate([gnomon_thickness*(1-(1-0.7)/2.0),0,gnomon_radius/2])
                    cube([gnomon_thickness*0.7, 0.8*gnomon_radius, gnomon_radius], center=true);
                translate([gnomon_thickness/2.0+gnomon_radius,0,0])
                    rotate([90,0,90]) cylinder(r=gnomon_radius, h=2*gnomon_thickness, center=true, $fn=100);
                
            }            
        }
        // The negative space for the screw and washer
        translate([0,0,Washer_Diameter/2+3])
            rotate([90,0,90]) cylinder(r=Screw_hole_diameter/2, h=20*gnomon_thickness, center=true, $fn=100);
        translate([gnomon_thickness*(0.5-4/8),0,Washer_Diameter/2+2.5])
            cube([gnomon_thickness*(6/8), 2*(Washer_Diameter/2+2), 2*(Washer_Diameter/2+3)],center=true);
        translate([gnomon_thickness*(0.5-4/8),0,Washer_Diameter+4])        
            rotate([90,0,0]) scale([0.37,0.2,1]) cylinder(r=gnomon_thickness, h=2*(Washer_Diameter/2+2), center=true, $fn=100);          
        translate([gnomon_thickness,0,gnomon_radius/2.0])
            rotate([90,0,0]) cylinder(r=Screw_hole_diameter/2, h=2*gnomon_thickness, center=true, $fn=100);            
/*        // Small cut to reduce warping issues
        translate([gnomon_thickness,0,gnomon_radius])
            cube([1,2*gnomon_thickness,gnomon_radius], center=true);
*/
        }        
    }
    
    

}


/* ************************************************************************/
module Block_jar_lid_top() {
    gnomon_thickness = 2*gnomon_radius;
    Screw_hole_diameter = 6.5;
    Nut_width_blocking = 8.8;
    Nut_width_non_blocking = 11.2;
    Washer_Diameter = 11.9;
    Washer_thickness = 1.3;
    Base_Wall_thickness = 3.0;
    box_width = gnomon_radius*4;
    box_length = gnomon_radius*4;
    box_height = gnomon_radius*2;
    Base_diameter = 70;
    Connector_x_offset = 10+5;

    // The Connector
    difference(){
        //General shape
        hull(){
            translate([0,0,gnomon_radius/2.0])
                rotate([90,0,0]) cylinder(r=gnomon_radius/2.0*1.2, h=gnomon_thickness*0.65, center=true, $fn=100);
            translate([Connector_x_offset,0,-0.75*gnomon_radius/2.0-Base_Wall_thickness/2]) rotate([0,0,0]) cylinder(r=Base_diameter/2 ,h=Base_Wall_thickness, center=true, $fn=100);
        }
        // Space to rotate the gnomon
        translate([0,0,gnomon_radius/2.0]) 
            rotate([90,0,0]) cylinder(r=gnomon_radius*0.7, h=0.8*gnomon_radius+2*epsilon_thickness, center=true, $fn=100);
        translate([-gnomon_thickness*10,0,9.94*gnomon_radius])
            cube([gnomon_thickness*20, 0.8*gnomon_radius+2*epsilon_thickness, 20*gnomon_radius], center=true);
        translate([-gnomon_thickness*10,0,-0.06*gnomon_radius])
            rotate([0,90,0]) scale([0.3,1,1]) cylinder(r=0.4*gnomon_radius, h=gnomon_thickness*20, center=true, $fn=100);
        translate([gnomon_thickness*10,0,0.65*gnomon_radius])
            rotate([0,90,0]) scale([1.5,1,1]) cylinder(r=0.4*gnomon_radius, h=gnomon_thickness*20, center=true, $fn=100);        
        // Hole for the top screw
        translate([0,0,gnomon_radius/2.0])
            rotate([90,0,0]) cylinder(r=Screw_hole_diameter/2, h=2*gnomon_thickness, center=true, $fn=100);
        // Flat surface for the top screw & washer/nut
        translate([0,-gnomon_thickness*(1+0.5/2+0.25/2-0.01)+2,gnomon_radius/2.0])
            rotate([90,0,0]) cylinder(r=1.5*Washer_Diameter/2, h=2*gnomon_thickness, center=true, $fn=100);
        translate([0,gnomon_thickness*(1+0.5/2+0.25/2-0.01)-2,gnomon_radius/2.0])
            rotate([90,0,0]) cylinder(r=1.5*Washer_Diameter/2, h=2*gnomon_thickness, center=true, $fn=100);
        // Holes for the two bottom screws
        translate([Connector_x_offset+1.1*Base_diameter/6,0,gnomon_radius/2.0])
            rotate([0,0,0]) cylinder(r=Screw_hole_diameter/2, h=2*gnomon_thickness, center=true, $fn=100);
        translate([Connector_x_offset-1.1*Base_diameter/6,0,gnomon_radius/2.0])
            rotate([0,0,0]) cylinder(r=Screw_hole_diameter/2, h=2*gnomon_thickness, center=true, $fn=100);        
       // Flat surfaces for the two bottom screws
        translate([Connector_x_offset+1.1*Base_diameter/6,0,gnomon_radius*1.63-Base_Wall_thickness+Base_Wall_thickness])
            rotate([0,0,0]) cylinder(r=1.5*Washer_Diameter/2, h=2*gnomon_thickness, center=true, $fn=100);
        translate([Connector_x_offset-1.1*Base_diameter/6,0,gnomon_radius*1.63-Base_Wall_thickness+Base_Wall_thickness])
            rotate([0,0,0]) cylinder(r=1.5*Washer_Diameter/2, h=2*gnomon_thickness, center=true, $fn=100);
        }

}


/* ************************************************************************/
module Block_jar_lid_bottom_old() {
    //Dimensions for a Bonne Maman jam jar
    Lid_diameter_outside = 88;
    Lid_diameter_inside = 82;
    Lid_thickness = 3.0;
    Lid_skirt_height_under_teeth = 0;
    Lid_skirt_full_height = 15 +Lid_thickness +Lid_skirt_height_under_teeth;
    Teeth_thickness = 2.0;
    Teeth_depth = 1.7;
    Teeth_length = 10.0;
    Connector_x_offset = 10;
    Base_diameter = 70;
    gnomon_thickness = 2*gnomon_radius;
    Screw_hole_diameter = 6.5;
    
    translate([Connector_x_offset, 0,0]) {
        //The skirt of the lid
        difference(){
            translate([0,0,-Lid_skirt_full_height/2]) rotate([0,0,0]) cylinder(r=Lid_diameter_outside/2 ,h=Lid_skirt_full_height, center=true, $fn=100);
            translate([0,0,-Lid_skirt_full_height/2]) rotate([0,0,0]) cylinder(r=Lid_diameter_inside/2 ,h=2*Lid_skirt_full_height, center=true, $fn=100);
        }
        //The Teeth
        translate([0,0,-Lid_skirt_full_height+Teeth_thickness/2+Lid_skirt_height_under_teeth]) intersection(){
            difference(){
                rotate([0,0,0]) cylinder(r=(0.5*Lid_diameter_inside+0.5*Lid_diameter_outside)/2 ,h=Teeth_thickness, center=true, $fn=100);
                rotate([0,0,0]) cylinder(r=Lid_diameter_inside/2-Teeth_depth ,h=2*Teeth_thickness, center=true, $fn=100);
            }
            union(){
                rotate([0,0,0]) cube([2*Lid_diameter_outside,Teeth_length,2*Teeth_thickness], center=true);
                rotate([0,0,60]) cube([2*Lid_diameter_outside,Teeth_length,2*Teeth_thickness], center=true);
                rotate([0,0,120]) cube([2*Lid_diameter_outside,Teeth_length,2*Teeth_thickness], center=true);        
            }
        }
        //The flat part of the lid
        difference(){
        translate([0,0,-Lid_thickness/2]) rotate([0,0,0]) cylinder(r=Lid_diameter_outside/2 ,h=Lid_thickness, center=true, $fn=100);
        // Holes for the two screws
        translate([1.1*Base_diameter/6,0,gnomon_radius/2.0])
            rotate([0,0,0]) cylinder(r=Screw_hole_diameter/2, h=2*gnomon_thickness, center=true, $fn=100);
        translate([-1.1*Base_diameter/6,0,gnomon_radius/2.0])
            rotate([0,0,0]) cylinder(r=Screw_hole_diameter/2, h=2*gnomon_thickness, center=true, $fn=100);      
        }

    }
}

/* ************************************************************************/
module Block_jar_lid_bottom() {
    //Dimensions for a Bonne Maman jam jar
    Lid_diameter_outside = 88;
    Lid_diameter_inside = 82;
    Lid_thickness = 3.0;
    Lid_skirt_height_under_teeth = 0;
    Lid_skirt_full_height = 15 +Lid_thickness +Lid_skirt_height_under_teeth;
    Teeth_thickness = 2.0;
    Teeth_depth = 1.7;
    Teeth_length = 10.0;
    Connector_x_offset = 10;
    Base_diameter = 70;
    gnomon_thickness = 2*gnomon_radius;
    Screw_hole_diameter = 6.5;
    Logo_font_size = 6;
    Logo_negative_depth = 2;
    Logo_positive_depth = 2;
    Logo_inside_cylinder_depth = 0;
    Support_horizontal_gap = 0.2;
    Support_vertical_gap = 0.1; // should 1 layer thickness
    Support_thickness = 1.2;
    Support_height_above = 5; // for an easier removal
    
    translate([Connector_x_offset, 0,0]) {
        //The skirt of the lid
        difference(){
            union(){
                //Outside shape for the skirt
                hull(){
                    translate([0,0,-Lid_skirt_full_height+1/2]) rotate([0,0,0]) cylinder(r=Lid_diameter_outside/2*1.035 ,h=1, center=true, $fn=12); // factor 1.035 because it has 12 faces: Lid_diameter_outside/2 is the minimum distance, instead of the maximum distance
                    translate([0,0,-Lid_thickness-1/2]) rotate([0,0,0]) cylinder(r=Lid_diameter_outside/2 ,h=1, center=true, $fn=100);
                }
            // Add the MOJOPTIX Logo (positive shape)
            rotate([0,0,90]) translate([0,-Lid_diameter_outside/2+Logo_negative_depth+20,-Lid_skirt_full_height/2]) rotate([90,0,0]) linear_extrude(20) text("MOJOPTIX",size=Logo_font_size,halign="center", valign="center",font="Comic Sans MS:style=Bold"); 
            rotate([0,0,-30]) translate([0,-Lid_diameter_outside/2+Logo_negative_depth+20,-Lid_skirt_full_height/2]) rotate([90,0,0]) linear_extrude(20) text("MOJOPTIX",size=Logo_font_size,halign="center", valign="center",font="Comic Sans MS:style=Bold");
            rotate([0,0,210]) translate([0,-Lid_diameter_outside/2+Logo_negative_depth+20,-Lid_skirt_full_height/2]) rotate([90,0,0]) linear_extrude(20) text("MOJOPTIX",size=Logo_font_size,halign="center", valign="center",font="Comic Sans MS:style=Bold");                
            }
            //Trim the Positive shape of the MOJOPTIX Logo with a tube
            difference(){
                cylinder(r=10*Lid_diameter_outside/2+Logo_positive_depth,h=1000,center=true, $fn=100);                
                cylinder(r=Lid_diameter_outside/2+Logo_positive_depth,h=1000,center=true, $fn=100);
            }            
            // Add the MOJOPTIX Logo (negative shape)
/*            difference(){
                union(){*/
                    rotate([0,0,90]) translate([0,-Lid_diameter_outside/2+Logo_negative_depth,-Lid_skirt_full_height/2]) rotate([90,0,0]) linear_extrude(100) text("MOJOPTIX",size=Logo_font_size,halign="center", valign="center",font="Comic Sans MS:style=Bold");
                    rotate([0,0,-30]) translate([0,-Lid_diameter_outside/2+Logo_negative_depth,-Lid_skirt_full_height/2]) rotate([90,0,0]) linear_extrude(100) text("MOJOPTIX",size=Logo_font_size,halign="center", valign="center",font="Comic Sans MS:style=Bold");
                    rotate([0,0,210]) translate([0,-Lid_diameter_outside/2+Logo_negative_depth,-Lid_skirt_full_height/2]) rotate([90,0,0]) linear_extrude(100) text("MOJOPTIX",size=Logo_font_size,halign="center", valign="center",font="Comic Sans MS:style=Bold");
/*                }
                //Trim the Negative shape of the MOJOPTIX Logo with a cylinder
                cylinder(r=Lid_diameter_outside/2-Logo_inside_cylinder_depth,h=1000,center=true, $fn=100);
            }*/
            //Inside shape for the skirt
            translate([0,0,-Lid_skirt_full_height/2]) rotate([0,0,0]) cylinder(r=Lid_diameter_inside/2 ,h=2*Lid_skirt_full_height, center=true, $fn=100);
        }            
        //The Teeth
        translate([0,0,-Lid_skirt_full_height+Teeth_thickness/2+Lid_skirt_height_under_teeth]) intersection(){
            difference(){
                rotate([0,0,0]) cylinder(r=(0.5*Lid_diameter_inside+0.5*Lid_diameter_outside)/2 ,h=Teeth_thickness, center=true, $fn=100);
                rotate([0,0,0]) cylinder(r=Lid_diameter_inside/2-Teeth_depth ,h=2*Teeth_thickness, center=true, $fn=100);
            }
            union(){
                rotate([0,0,0]) cube([2*Lid_diameter_outside,Teeth_length,2*Teeth_thickness], center=true);
                rotate([0,0,60]) cube([2*Lid_diameter_outside,Teeth_length,2*Teeth_thickness], center=true);
                rotate([0,0,120]) cube([2*Lid_diameter_outside,Teeth_length,2*Teeth_thickness], center=true);        
            }
        }

        //The flat part of the lid
        difference(){
            translate([0,0,-Lid_thickness]) rotate_extrude(convexity = 10, $fn = 100) {
                square([Lid_diameter_outside/2-Lid_thickness,Lid_thickness], center=false);
                intersection(){
                    translate([Lid_diameter_outside/2-Lid_thickness+epsilon_thickness,0,-Lid_thickness]) scale([1,1]) circle(r=Lid_thickness, center=true);
                    square([Lid_diameter_outside/2+epsilon_thickness,Lid_thickness+epsilon_thickness], center=false);
                }
            }
        // Holes for the two screws
        translate([1.1*Base_diameter/6,0,gnomon_radius/2.0])
            rotate([0,0,0]) cylinder(r=Screw_hole_diameter/2, h=2*gnomon_thickness, center=true, $fn=100);
        translate([-1.1*Base_diameter/6,0,gnomon_radius/2.0])
            rotate([0,0,0]) cylinder(r=Screw_hole_diameter/2, h=2*gnomon_thickness, center=true, $fn=100);      
        // A single line on the 1st layer to have a custom scarring (instead of some scarring at a random place)
        translate([0,0,0]) cube([100,0.1,0.5], center=true);
        }


        // Support structure for the teeth
        if (FLAG_bottom_lid_support == 1) {
            color("red") difference(){
                translate([0,0,-Lid_skirt_full_height/2-Lid_thickness/2-Support_vertical_gap-Support_height_above/2]) rotate([0,0,0]) cylinder(r=Lid_diameter_inside/2-Teeth_depth-Support_horizontal_gap,h=Lid_skirt_full_height-Lid_thickness+Support_height_above, center=true, $fn=100);
                translate([0,0,-Lid_skirt_full_height/2-Lid_thickness]) rotate([0,0,0]) cylinder(r=Lid_diameter_inside/2-Teeth_depth-Support_horizontal_gap-Support_thickness ,h=2*Lid_skirt_full_height+2*Support_height_above, center=true, $fn=100);
                cube([2,1000,1000],center=true);
            }
            
        }
    }


    


}


/* ************************************************************************/
/* ************************************************************************/
module Gnomon_Digits(nn) {
/*    translate([112.5/nn,0,0]) Block_hours_tens(); 
    translate([85/nn,0,0]) build_spacer_block(10/nn); 
    translate([57.5/nn,0,0])  Block_hours_units();
    translate([30/nn,0,0]) build_spacer_block(10/nn);

    translate([12.5/nn,0,0]) Block_semicolon();

    translate([-22.5/nn,0,0])    Block_minutes_tens();
    translate([-50/nn,0,0]) build_spacer_block(10/nn);
    translate([-77.5/nn,0,0])   Block_minutes_units();    
*/
    translate([112.5/nn,0,0]) Block_hours_tens(); 
    translate([89/nn,0,0]) build_spacer_block(2/nn); 
    translate([65.5/nn,0,0])  Block_hours_units();
    translate([38/nn,0,0]) build_spacer_block(10/nn);

    translate([20.5/nn,0,0]) Block_semicolon();

    translate([-14.5/nn,0,0])    Block_minutes_tens();
    translate([-42/nn,0,0]) build_spacer_block(10/nn);
    translate([-69.5/nn,0,0])   Block_minutes_units();    
    
}

/* ************************************************************************/
module Gnomon_Rounded_Top(nn) {
    translate([-120/nn,0,0]) build_round_top_block();   
}
/* ************************************************************************/
module Gnomon_Bottom_Connector(nn) {
    translate([155/nn,0,0]) Block_rotating_base_upper();
}
/* ************************************************************************/
module Central_Connector(nn) {
    color("red") translate([205/nn,0,0]) Block_rotating_base_mid();
}
/* ************************************************************************/
module Jar_Lid_Top(nn) {
    translate([265/nn,0,0]) Block_jar_lid_top();
}
/* ************************************************************************/
module Jar_Lid_Bottom(nn) {
//    color("blue"){
        translate([265/nn,0,-24/nn]) Block_jar_lid_bottom();
//    }
}


/* ************************************************************************/
module Gnomon(nn) {
    color("green"){
    if (FLAG_northern_hemisphere==1){
        translate([5,0,0])    Gnomon_Digits(nn);
        translate([11,0,0])   Gnomon_Rounded_Top(nn);
        translate([0,0,0])    Gnomon_Bottom_Connector(nn);        
    }
    else {
        translate([37.25,0,0]) rotate([0,0,180]) Gnomon_Digits(nn);
        translate([11,0,0])   Gnomon_Rounded_Top(nn);
        translate([0,0,0])    Gnomon_Bottom_Connector(nn); 
    }
}}

/* ************************************************************************/
/* MAIN *******************************************************************/
/* ************************************************************************/

// Choose what you want to print/display:
// 1: the gnomon
if (FLAG_PRINT == 1) Gnomon(nn);
// 2: the central connector piece
if (FLAG_PRINT == 2) translate([-8,0,0]) Central_Connector(nn);
// 3: the top part of the lid
if (FLAG_PRINT == 3) translate([-14,0,0]) Jar_Lid_Top(nn);
// 4: the bottom part of the lid
if (FLAG_PRINT == 4) translate([-9,0,3.75]) rotate([180,0,0]) Jar_Lid_Bottom(nn);
// 10: everything
if (FLAG_PRINT == 10) 
    {
    Gnomon(nn);
    translate([-8,0,0]) Central_Connector(nn);
    translate([-14,0,0]) Jar_Lid_Top(nn);
    translate([-9,0,3.75]) Jar_Lid_Bottom(nn); 
    }