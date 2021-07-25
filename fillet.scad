module rect(width, height) {
  polygon(points=[[0, 0], [0, height], [width, height], [width, 0]]);
}

module _fillet_cutoff_2d(d) {
  difference() {
    square(d);
    circle(d);
  }
}

module _rect_fillet_cutoff_2d(width, height, ul=0, ll=0, ur=0, lr=0) {
  if (ur > 0) translate([width - ur, height - ur]) rotate(0) _fillet_cutoff_2d(ur);
  if (ul > 0) translate([ul, height - ul]) rotate(90) _fillet_cutoff_2d(ul);
  if (ll > 0) translate([ll, ll]) rotate(180) _fillet_cutoff_2d(ll);
  if (lr > 0) translate([width - lr, lr]) rotate(270) _fillet_cutoff_2d(lr);
}

/**
 * 2D rectangles with fillets.
 *
 * @param ul  the fillet radius at the upper left corner.
 * @param ll  the fillet radius at the lower left corner.
 * @param ur  the fillet radius at the upper right corner.
 * @param lr  the fillet radius at the lower right corner.
 */
module rect_fillet(width, height, ul=0, ll=0, ur=0, lr=0) {
  difference() {
    rect(width, height);
    if (ur > 0) translate([width - ur, height - ur]) rotate(0) _fillet_cutoff_2d(ur);
    if (ul > 0) translate([ul, height - ul]) rotate(90) _fillet_cutoff_2d(ul);
    if (ll > 0) translate([ll, ll]) rotate(180) _fillet_cutoff_2d(ll);
    if (lr > 0) translate([width - lr, lr]) rotate(270) _fillet_cutoff_2d(lr);
  }
}

/**
 * Cylinder tubes with fillets.
 *
 * @param h             the height of a tube.
 * @param r             the radius of a tube.
 * @param hole_radius   the hole radius of a tube.
 * @param angle         the hole radius of a tube.
 * @param ui            the fillet radius at the upper inner edge.
 * @param li            the fillet radius at the lower inner edge.
 * @param uo            the fillet radius at the upper outer edge.
 * @param lo            the fillet radius at the lower outer edge.
 */
module cylinder_tube_fillet(h=0, r=0, hole_radius=0, angle = 360, ui=0, li=0, uo=0, lo=0) {
  w = r - hole_radius;
  difference() {
    rotate_extrude()
      translate([hole_radius, 0, 0])
        rect_fillet(w, h, ul=ui, ll=li, ur=uo, lr=lo);
    // cutoffting
    if (angle > 0 && angle < 360) {
      rotate(a=[0, 0, angle]) cube([r, r, h]);
      if (angle < 90) rotate(a=[0, 0, 90]) cube([r, r, h]);
      if (angle < 180) rotate(a=[0, 0, 180]) cube([r, r, h]);
      if (angle < 270) rotate(a=[0, 0, 270]) cube([r, r, h]);
    }
  }
}
