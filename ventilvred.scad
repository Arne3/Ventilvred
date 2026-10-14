// Ventil knob for a stem with two flat sides and two rounded sides.
//
// The stem cross-section, looking down on the valve:
//
//          diameter (rounded sides)
//        <------------------------>
//              ___-------___
//           /                 \
//          |                   |
//          |                   |
//           \                 /
//              ---_______---
//              ^             ^
//              |-- width ----|
//              two flat sides
//
// Customer estimate: width 5 mm between the flats, height 7 mm across
// the rounded sides. The 7 mm value is "axis_diameter" below (they
// called it the height because it is the taller of the two measurements).
//
// How to use this file
// 1. Open it in OpenSCAD. Use the Customizer window if it is available.
// 2. Set part to "gauge" and export an STL. Print that small piece first
//    and try it on the valve. If it will not go on, raise axis_clearance
//    by 0.1 mm and print the gauge again. If it rattles, lower it by 0.1 mm.
// 3. Measure how far the stem sticks up, and set socket_depth a little
//    deeper than that so the knob can sit down on the valve.
// 4. Set part back to "knob", turn section_view off, and export the STL.
//
// Print the part with the socket mouth on the bed (the flat bottom down).
// The stem hole is then vertical, which prints rounder. Four perimeters
// so the set screw has plastic to thread into. The set-screw hole is a
// teardrop so it prints without support; an M3 screw cuts its own thread.
// Leave show_stem on while looking: the brass stem is preview only and
// is left out of the STL.

/* [Valve axis] */
// Distance between the two flat sides, mm. Customer estimate: 5.
axis_width = 5; // [2:0.1:20]

// Distance across the two rounded sides, mm. Customer estimate: 7.
// This is the diameter of the round part of the stem.
axis_diameter = 7; // [2:0.1:20]

// How much larger the printed socket is than the stem, mm.
// 0.4 means 0.2 mm of air on each side. If the gauge will not go on,
// increase this by 0.1. If the knob spins on the flats, decrease it by 0.1.
axis_clearance = 0.4; // [0:0.05:1.5]

// Depth of the pocket, mm. Use a little more than the stem sticks out.
socket_depth = 8; // [3:0.5:25]

// Which way the flats point.
// side: flats face the long sides, and the set screw clamps a flat.
// end: flats face the rounded ends of the knob.
flats_face = "side"; // [side, end]

/* [Knob body] */
// Overall length, along the handle, mm.
knob_length = 40; // [16:1:80]

// Overall width, across the handle, mm.
knob_width = 20; // [10:0.5:50]

// Body height, not counting the dome, mm.
knob_height = 12; // [6:0.5:30]

// Corner radius. 0 makes fully round ends (a stadium shape).
corner_radius = 0; // [0:0.5:20]

/* [Top dome] */
dome_enabled = true;
dome_diameter = 14; // [6:0.5:40]
dome_height = 3; // [0.4:0.1:10]

/* [Set screw] */
// A screw from the side, aimed at a flat, so it locks the knob on the stem.
set_screw_enabled = true;

// Hole diameter, mm. 2.6 lets an M3 screw cut a thread in the plastic.
// Use 3.4 for an M4 screw. Use 3.3 or 4.3 for a clearance hole instead.
set_screw_diameter = 2.6; // [1.5:0.1:8]

// Counterbore for the screw head. Set the diameter to 0 for a straight hole.
// M3 pan head is about 5.5 mm. M4 pan head is about 7 mm.
set_screw_head_diameter = 6; // [0:0.1:14]
set_screw_head_depth = 1.6; // [0:0.1:8]

// Height of the screw center above the bottom face, mm.
// Keep this on the part of the stem that actually sits in the pocket.
set_screw_height = 4.5; // [1:0.1:24]

/* [Part] */
// gauge: small test socket. Print this before the knob.
// knob: the handle.
part = "knob"; // [knob, gauge]

// Cut the part in half on screen so the socket and the screw hole are visible.
// Turn this off before exporting an STL, or the saved file is only half a knob.
section_view = false;

/* [Quality] */
resolution = 64; // [24:8:160]

/* [Hidden] */
// Printed socket size. Clearance is added to both stem measurements.
hole_width = axis_width + axis_clearance;
hole_diameter = axis_diameter + axis_clearance;
// Brass stand-in drawn in preview only. Not part of the STL.
show_stem = true;
$fn = resolution;

// ---------------------------------------------------------------------------
// Checks
// ---------------------------------------------------------------------------

assert(part == "knob" || part == "gauge", "part must be \"knob\" or \"gauge\".");
assert(flats_face == "side" || flats_face == "end", "flats_face must be \"side\" or \"end\".");
assert(axis_width > 0, "Axis width must be greater than 0.");
assert(axis_diameter > axis_width, "Axis diameter must be larger than the width across the flats.");
assert(axis_clearance >= 0, "Clearance cannot be negative.");
assert(socket_depth > 2, "Socket depth is too small.");

if (part == "knob") {
    assert(knob_length > knob_width, "Knob length should be greater than knob width.");
    assert(
        knob_width > hole_diameter + 4,
        "Knob is too narrow for this stem. Increase knob_width."
    );
    assert(
        knob_height > socket_depth + 1.2,
        "The socket breaks through the top. Increase knob_height or reduce socket_depth."
    );
    if (dome_enabled) {
        assert(dome_height > 0.3, "Dome height is too small.");
        assert(dome_diameter > 2, "Dome diameter is too small.");
        assert(dome_diameter < knob_width - 0.5, "Dome is wider than the knob.");
        assert(dome_height < dome_diameter, "Dome is too tall for its diameter.");
    }
}

if (set_screw_enabled) {
    assert(set_screw_diameter > 0.8, "Set screw hole is too small.");
    screw_top = set_screw_height + (set_screw_diameter / 2) * sqrt(2);
    screw_bottom = set_screw_height - set_screw_diameter / 2;
    part_top = part == "gauge" ? socket_depth + 3 : knob_height;
    assert(screw_bottom > 0.8, "Set screw hole breaks through the bottom. Raise set_screw_height.");
    assert(screw_top < part_top - 0.6, "Set screw hole breaks through the top. Lower set_screw_height.");
    if (set_screw_head_diameter > 0 && set_screw_head_depth > 0) {
        head_top = set_screw_height + set_screw_head_diameter / 2;
        head_bottom = set_screw_height - set_screw_head_diameter / 2;
        assert(head_bottom > 0.4, "Screw head counterbore breaks through the bottom.");
        assert(head_top < part_top - 0.4, "Screw head counterbore breaks through the top.");
    }
}

echo(str("Stem width across flats: ", axis_width, " mm"));
echo(str("Stem diameter across rounds: ", axis_diameter, " mm"));
echo(str("Printed socket width: ", hole_width, " mm"));
echo(str("Printed socket diameter: ", hole_diameter, " mm"));
echo(str("Part: ", part));

// ---------------------------------------------------------------------------
// Stem profile: a circle trimmed by two parallel flats.
// Flats face the long sides of the knob unless flats_face is "end".
// ---------------------------------------------------------------------------

module stem_profile(diameter, across_flats) {
    intersection() {
        circle(d = diameter);
        square([diameter + 2, across_flats], center = true);
    }
}

module oriented_profile(diameter, across_flats) {
    rotate([0, 0, flats_face == "end" ? 90 : 0])
        stem_profile(diameter, across_flats);
}

// Blind pocket. The mouth is a little wider so the stem finds the hole
// and the first printed layer (elephant foot) does not make it tight.
module socket_void(depth) {
    lead_extra = 0.9;
    lead_height = 1.5;

    linear_extrude(height = depth)
        oriented_profile(hole_diameter, hole_width);

    linear_extrude(
        height = lead_height,
        scale = hole_diameter / (hole_diameter + lead_extra)
    )
        oriented_profile(hole_diameter + lead_extra, hole_width + lead_extra);
}

// Horizontal hole along +X with the point of the teardrop facing up,
// so a printer does not have to bridge the top of a round hole.
module horizontal_teardrop_x(diameter, x_start, x_end) {
    length = x_end - x_start;
    radius = diameter / 2;
    apex = radius * sqrt(2);
    translate([x_start, 0, 0])
        hull() {
            rotate([0, 90, 0])
                cylinder(d = diameter, h = length);
            translate([0, 0, apex])
                rotate([0, 90, 0])
                    cylinder(d = 0.08, h = length, $fn = 6);
        }
}

// Screw enters from the flat it clamps. The hole stops inside the socket
// so it does not come out the far side of the knob.
module set_screw_cut(reach) {
    along_length = flats_face == "end";
    rotate([0, 0, along_length ? 0 : 90]) {
        translate([0, 0, set_screw_height])
            horizontal_teardrop_x(
                set_screw_diameter,
                -1,
                reach + 0.2
            );
        if (set_screw_head_diameter > set_screw_diameter && set_screw_head_depth > 0) {
            translate([reach - set_screw_head_depth, 0, set_screw_height])
                rotate([0, 90, 0])
                    cylinder(
                        d = set_screw_head_diameter,
                        h = set_screw_head_depth + 0.4
                    );
        }
    }
}

module rounded_rect(length, width, radius) {
    r = min(radius, min(length, width) / 2);
    hull() {
        translate([length / 2 - r, width / 2 - r]) circle(r = r);
        translate([length / 2 - r, -width / 2 + r]) circle(r = r);
        translate([-length / 2 + r, width / 2 - r]) circle(r = r);
        translate([-length / 2 + r, -width / 2 + r]) circle(r = r);
    }
}

module knob_body() {
    // 0 means round ends: radius is half the width, which makes a stadium.
    r = corner_radius <= 0 ? knob_width / 2 : corner_radius;
    linear_extrude(height = knob_height)
        rounded_rect(knob_length, knob_width, r);
}

// Spherical cap. Base sits on z = 0 and has the given diameter.
module spherical_cap(diameter, height) {
    half = diameter / 2;
    radius = (height * height + half * half) / (2 * height);
    intersection() {
        translate([0, 0, height - radius])
            sphere(r = radius);
        cylinder(r = half + 0.02, h = height);
    }
}

module top_dome() {
    // Sink the cap a fraction into the body so the joint cannot gap.
    embed = 0.15;
    translate([0, 0, knob_height - embed])
        spherical_cap(dome_diameter, dome_height + embed);
}

// Removes the negative-Y half so the socket can be inspected.
module section_cutter() {
    translate([-200, -200, -10])
        cube([400, 200, 80]);
}

module knob() {
    reach = flats_face == "end" ? knob_length / 2 : knob_width / 2;
    difference() {
        union() {
            knob_body();
            if (dome_enabled) {
                top_dome();
            }
        }
        socket_void(socket_depth);
        if (set_screw_enabled) {
            set_screw_cut(reach);
        }
        if (section_view) {
            section_cutter();
        }
    }
}

// Short socket with the same stem hole as the knob, for a fit test.
module fit_gauge() {
    outer = max(hole_diameter, hole_width) + 10;
    height = socket_depth + 3;
    mark_angle = flats_face == "end" ? 0 : 90;

    difference() {
        union() {
            cylinder(d = outer, h = height);
            // Bar on top, pointing toward the side the screw enters.
            rotate([0, 0, mark_angle])
                translate([outer / 5, 0, height])
                    cube([outer / 4, 1.8, 1.4], center = true);
        }
        socket_void(socket_depth);
        if (set_screw_enabled) {
            set_screw_cut(outer / 2);
        }
        if (section_view) {
            section_cutter();
        }
    }
}

// Real stem size (no clearance), sticking out of the bottom.
// Preview only: $preview is false when an STL is exported.
module stem_preview() {
    translate([0, 0, -6])
        linear_extrude(height = socket_depth + 5.2)
            oriented_profile(axis_diameter, axis_width);
}

if (part == "gauge") {
    color([0.15, 0.15, 0.16])
        fit_gauge();
} else {
    color([0.10, 0.10, 0.11])
        knob();
}

if ($preview && show_stem) {
    color([0.74, 0.56, 0.20, 0.45])
        stem_preview();
}
