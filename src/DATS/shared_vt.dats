(*
** Copyright (C) 2015 Hongwei Xi, Boston University
**
** Permission is hereby granted, free of charge, to any person
** obtaining a copy of this software and associated documentation
** files (the "Software"), to deal in the Software without
** restriction, including without limitation the rights to use,
** copy, modify, merge, publish, distribute, sublicense, and/or sell
** copies of the Software, and to permit persons to whom the
** Software is furnished to do so, subject to the following
** conditions:
**
** The above copyright notice and this permission notice shall be
** included in all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
** OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
** NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
** HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
** WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
** FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
** OTHER DEALINGS IN THE SOFTWARE.
*)

(* ****** ****** *)
//
(*
** Author: Hongwei Xi
** Authoremail: gmhwxiATgmailDOTcom
** Start time: January, 2015
*)
//
(* ****** ****** *)
%{
#include <pthread.h>
%}

(* ****** ****** *)
//
#include "./../HATS/includes.hats"
staload "./../SATS/shared_vt.sats"
#define ATS_DYNLOADFLAG 0
//
(* ****** ****** *)
//
staload UN = $UNSAFE
//

(* ****** ****** *)

//
datavtype
shared_ (a:vtype) =
  SHARED of (spin1_vt, int, ptr)
//
assume shared = shared_
//

implement
shared_make(x) = let
  val spin =
    unsafe_spin_t2vt(spin_create_exn())
  // end of [val]
in
  SHARED(spin, 1, $UN.castvwtp0{ptr}(x))
end // end of [shared_make]

(* ****** ****** *)

implement
shared_ref
  {a}(sh) = let
//
val+@SHARED
  (spin, count, _) = sh
//
val
spin =
  unsafe_spin_vt2t(spin)
//
val
(pf | ()) = spin_lock(spin)
val c0 = count
val () = count := c0 + 1
val ((*void*)) = spin_unlock(pf | spin)
prval ((*void*)) = fold@sh
//
in
  $UN.castvwtp1{shared(a)}(sh)
end // end of [shared_ref]

(* ****** ****** *)

implement
shared_unref
  {a}(sh) = let
//
val+@SHARED
  (spin, count, _) = sh
//
val
spin =
  unsafe_spin_vt2t(spin)
//
val
(pf | ()) = spin_lock(spin)
val c0 = count
val () = count := c0 - 1
val ((*void*)) = spin_unlock(pf | spin)
prval ((*void*)) = fold@sh
//
in
if
c0 <= 1
then let
  val+~SHARED(spin, _, x) = sh
  val ((*freed*)) = spin_vt_destroy(spin)
in
  Some_vt($UN.castvwtp0{a}(x))
end // end of [then]
else let
  prval () = $UN.cast2void(sh) in None_vt()
end // end of [else]
//
end // end of [shared_unref]

(* ****** ****** *)

implement
shared_lock
  {a}(sh) = let
//
val+@SHARED(spin, _, x) = sh
//
val
spin =
  unsafe_spin_vt2t(spin)
//
val
(pf | ()) = spin_lock(spin)
//
val x0 = $UN.castvwtp0{a}(x)
//
prval () = fold@sh
//
in
  ($UN.castview0(pf) | x0)
end // end of [shared_lock]

(* ****** ****** *)

implement
shared_unlock
  {a}(pf | sh, x0) = let
//
val+@SHARED(spin, _, x) = sh
//
val
spin =
  unsafe_spin_vt2t(spin)
//
val () = x := $UN.castvwtp0{ptr}(x0)
//
val () =
  spin_unlock($UN.castview0(pf) | spin)
//
prval () = fold@sh
//
in
  // nothing
end // end of [shared_unlock]

(* ****** ****** *)


(* end of [shared_vt.dats] *)

