type pos = Errormsg.pos
type symbol = Symbol.symbol

type ptop = Op of (pos * Absyn.afixity * int * Absyn.aconstant * Absyn.atype list)


(*	Parser State	*)
type ptparsestate =
	PrefixState
|	PrefixrState
|	PrefixWithArgState
|	PrefixrWithArgState
|	InfixState
|	InfixrState
|	InfixWithArgState
|	InfixrWithArgState
|	PostfixState
|	NoneState
|	TermState

(**********************************************************************
*makeApply:
*	Make an application term, performing type checking.
**********************************************************************)
let makeApply = fun f arg ->
	let term = Absyn.ApplyTerm(getTerm f, [getTerm arg], 1, Absyn.getTermPos f) in
	let ty = Types.checkApply (getType f) (getType arg) in
	
	if ty = Types.errorTypeMolecule then
		errorTerm
	else
		Term(term, ty, (getTermPos f))

(**********************************************************************
*makeBinaryApply:
*	Make an application term, performing type checking.  Special case
*	of makeApply, used to display better error information.
**********************************************************************)
let makeBinaryApply = fun f arg1 arg2 ->
	let term = Absyn.ApplyTerm(Absyn.ApplyTerm(getTerm f, [getTerm arg1], 1, Absyn.getTermPos f), [getTerm arg2], 1, Absyn.getTermPos f) in
	let ty = Types.checkApply (getType f) (getType arg1) in
	let ty' = Types.checkApply ty (getType arg2) in
	
	if ty' = Types.errorTypeMolecule then
		errorTerm
	else
		Term(term, ty', (getTermPos f))

(**********************************************************************
*makeReal:
**********************************************************************)
let makeReal = fun r pos ->
	let term = Absyn.RealTerm(r, pos) in
	let skel = Pervasives.getPervasiveKindType "real" in
	Types.TypeMolecule(skel, [])