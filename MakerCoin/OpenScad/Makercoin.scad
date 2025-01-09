

coin_d = 40;
coin_h = 3;
$fn=180;

//QC code library made by Darwin Schuppan all credit goes to them
include <qr.scad>

//render each colour segment at a time
// i.e only 1 colour = true at once
show_black = false;
show_yellow = false;
show_orange = true;
show_white = false;

//hollow (affects white layer only)
hollow_for_rfid = false;
//keyring hole (affects white and orange layer)
keyring_hole = true;


radius = coin_d/2;
angles = [-10,10];
width = 2;
fn = $fn;

module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
} 




//S
module SM_S(){
translate([0,0,2]){
    difference(){
        scale([.15,.15,.05]){
            import("S.stl");}
        scale([.15,.15,.04]){
            import("M.stl");}
    }
}
}

//M
module SM_M(){
translate([0,0,2]){
scale([.15,.15,.04]){
import("M.stl");
}}}

// QRCODE
module qr_code(){
 qr("www.swindon-makerspace.org/mc", center=true, height=23.2, width=23.2);   
}

if (show_black){
    color("black")
    qr_code();
}

if (show_orange){
    color("orange"){
        difference(){
        //outer dips
        union(){
            for (i=[0:5]){
                rotate([0,0,i*60])
                linear_extrude(coin_h) arc(radius-width, angles, width, fn);
            }
            for (i=[0:11]){
                rotate([0,0,i*30])
                linear_extrude(coin_h) arc(radius-2.5-width, [-8,8], width-1, fn);
            }        
            SM_M();
        }
        //keyring hole
        if (keyring_hole){
            rotate([0,0,30])
            translate([17,0,0])
                cylinder(d=3, h=3);
        } 
    }        
    }
}

if (show_yellow){
    color("yellow")
        SM_S();
}

if (show_white){
    color("white")
    difference(){
        cylinder(d=coin_d, h=coin_h);
        
        //outer dips
        for (i=[0:5]){
            rotate([0,0,i*60])
            linear_extrude(coin_h) arc(radius-width, angles, width, fn);
        }
        for (i=[0:11]){
            rotate([0,0,i*30])
            linear_extrude(coin_h) arc(radius-2.5-width, [-8,8], width-1, fn);
        }        
        qr_code();
        SM_M();
        SM_S();
        
        //hollow for rfid tag
        if (hollow_for_rfid){
            translate([0,0,1])
                cylinder(d=26, h=1);
        }
        //keyring hole
        if (keyring_hole){
            rotate([0,0,30])
            translate([17,0,0])
                cylinder(d=3, h=3);
        }   
        
    }
}