#define ATS_PACKNAME "ats-shared-vt"
#include "./../HATS/includes.hats"
staload UN = $UNSAFE
(* ****** ****** *)

absvtype shared(a:vtype) = ptr

(* ****** ****** *)


fun shared_make{a:vtype}(x: a): shared(a)  
  
(* ****** ****** *)
//

fun shared_ref{a:vtype}(!shared(a)): shared(a)

fun shared_unref{a:vtype}(shared(a)): Option_vt(a)
//
(* ****** ****** *)

absview locked_v

(* ****** ****** *)


fun shared_lock{a:vtype}(!shared(a)): (locked_v | a)

fun shared_unlock{a:vtype}(locked_v | !shared(a), x: a): void
