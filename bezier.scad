/* akabe.scad --- akabe's OpenSCAD library

   Copyright (c) 2021 Akinori Abe

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE. */

/** The third-order Bezier surface. */

include <./math.scad>

function bezier_curve_basis(t) =
  let(T = 1 - t)
  [T * T * T, 3 * t * T * T, 3 * t * t * T, t * t * t];

function bezier_surface_basis(t, u) =
  outer_flat(bezier_curve_basis(t), bezier_curve_basis(u));

function bezier_surface_matrix(n) =
  (n <= 1
    ? [[for (i = [0:15]) 0]] // returns a singleton list of (0,0,0).
    : let(n = n - 1)
      [
        for(i = [0:n])
          for(j = [0:n])
            bezier_surface_basis(i / n, j / n)
      ]);

function bezier_surface_points(points, n) =
  bezier_surface_matrix(n) * points;

function bezier_get_top_edge_indices(n, offset=0) =
  (n <= 1 ? [] : [for(i = [0:n-1]) i + offset]);

function bezier_get_bottom_edge_indices(n, offset=0) =
  let(k = n * (n - 1) + offset)
  (n <= 1 ? [] : [for(i = [0:n-1]) i + k]);

function bezier_get_left_edge_indices(n, offset=0) =
  (n <= 1 ? [] : [for(i = [0:n-1]) i * n + offset]);

function bezier_get_right_edge_indices(n, offset=0) =
  let(k = (n - 1) + offset)
  (n <= 1 ? [] : [for(i = [0:n-1]) i * n + k]);

function bezier_surface_triangles(n, rev=false, offset=0) =
  (n <= 1
    ? []
    : [
        for(i = [0:n-2])
          for(j = [0:n-2])
            let(a = n * i + j + offset, b = a + 1, c = a + n, d = c + 1)
              each (rev ? [[d, c, a], [b, d, a]] : [[a, c, d], [a, d, b]])
      ]);
