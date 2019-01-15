% PROLOG DIFFERENTIATE RULES DATABASE

% Usage examples:
% derivative predicate
% derivative(log(tan(x)), x, Res).
% derivative(sin(cos(log(x))), x, Res).
% After unification Res will be equal to derivative of passed function

% eval_deriv predicate
% eval_deriv(log(tan(x)), x, [x/1], Res, Val).
% eval_deriv(exp(log(sin(x+c))), x, [x/1,c/2], Res, Val).
% After unification Res will be equal to derivative of passed function
% and Val will be equal to value of derivative for x = 1.
% values for different variables can be passed as element of a list using specified
% format [variable_name1/value1, variable_name2/value2]

% HELPER METHODS
sum(X, X, 0).
sum(X, 0, X).
sum(Res, X, Y) :- number(X), number(Y), Res is X + Y.
sum(X + Y, X, Y).

mul(0, 0, _).
mul(0, _, 0).
mul(X, X, 1).
mul(X, 1, X).
mul(Res, X, Y) :- number(X), number(Y), Res is X * Y.
mul((X^2), X, X).
mul(X * Y, X, Y).
mul(-X, -1, X).
mul(-X, X, -1).

sub(X, X, 0).
sub(-X, 0, X).
sub(Res, X, Y) :- number(X), number(Y), Res is X - Y.
sub(X - Y, X, Y).

div(X, X, 1).
div(1, X, X).
div(0, 0, _).
div(Res, X, Y) :- number(X), number(Y), Res is X / Y.
div((X) / (Y), X, Y).

% DERIVATIVE
derivative(F, _, 0) :- number(F).

derivative(F, V, 0) :- atom(F), F \== V.

derivative(F, V, 1) :- atom(F), F == V.

derivative(F + G, V, Res) :-
	derivative(F, V, Fdiff),
	derivative(G, V, Gdiff),
	sum(Res, Fdiff, Gdiff).

derivative(F - G, V, Res) :- 
	derivative(F, V, Fdiff),
	derivative(G, V, Gdiff),
	sub(Res, Fdiff, Gdiff).

derivative(F * G, V, Res) :-
	derivative(F, V, Fdiff),
	derivative(G, V, Gdiff),
	mul(FGdiff, F, Gdiff),
	mul(GFdiff, G, Fdiff),
	sum(Res, FGdiff, GFdiff).

% (f^g)' = f^(g-1)*(gf' + g'f logf) 
derivative(F ^ G, V, Res) :-
	derivative(F, V, Fdiff),
	derivative(G, V, Gdiff),
	sub(G_1, G, 1),
	mul(GF, G, Fdiff),
	mul(FG, Gdiff, F),
	mul(GFLog, FG, log(F)),
	sum(SUM, GF, GFLog),
	( G_1 \== 1 -> mul(Res, SUM, F^(G_1));
	  mul(Res, SUM, F)
	).

derivative(F / G, V, Res) :- 
	derivative(F, V, Fdiff),
	derivative(G, V, Gdiff),
	mul(A, Fdiff, G),
	mul(B, F, Gdiff),
	mul(C, G, G),
	sub(D, A, B),
	div(Res, (D), (C)).

% functions derivative
derivative(log(F), V, Res) :-
	derivative(F, V, Fdiff),
	div(Res, (Fdiff), (F)).

derivative(log(A, F), V, Res) :-
	number(A), derivative(F, V, Fdiff),
	mul(B, F, log(A)),
	div(Res, (Fdiff), B).

derivative(exp(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(Res, (Fdiff), exp(F)).

derivative(sin(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(Res, (Fdiff), cos(F)).

derivative(cos(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(A, (Fdiff), sin(F)),
	mul(Res, -1, A).

derivative(tan(F), V, Res) :-
	derivative(F, V, Fdiff),
	div(Res, (Fdiff), (cos(F)^2)).

derivative(ctg(F), V, Res) :-
	derivative(F, V, Fdiff),
	div(A, (Fdiff), (sin(F)^2)),
	mul(Res, -1, A).

derivative(sec(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(A, tan(F), sec(F)),
	mul(Res, (Fdiff), A).

derivative(csc(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(A, ctg(F), sec(F)),
	mul(B, -1, A),
	mul(Res, (Fdiff), B).

derivative(arcsin(F), V, Res) :-
	derivative(F, V, Fdiff),
	sub(A, 1, (F)^2),
	div(Res, (Fdiff), (A)^(1/2)).

derivative(arccos(F), V, Res) :-
	derivative(F, V, Fdiff),
	sub(A, 1, (F)^2),
	div(B, (Fdiff), (A)^(1/2)),
	mul(Res, -1, B).

derivative(arctan(F), V, Res) :-
	derivative(F, V, Fdiff),
	sum(A, 1, (F)^2),
	div(Res, (Fdiff), (A)).

derivative(arcctg(F), V, Res) :-
	derivative(F, V, Fdiff),
	sum(A, 1, (F)^2),
	div(B, (Fdiff), (A)),
	mul(Res, -1, B).

derivative(arcsec(F), V, Res) :-
	derivative(F, V, Fdiff),
	sub(A, 1, (F)^(-2)),
	mul(B, (F)^2, (A)^(1/2)),
	div(Res, (Fdiff), B).

derivative(arccsc(F), V, Res) :-
	derivative(F, V, Fdiff),
	sub(A, 1, (F)^(-2)),
	mul(B, (F)^2, (A)^(1/2)),
	div(C, (Fdiff), B),
	mul(Res, -1, C).

derivative(sinh(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(Res, Fdiff, cosh(F)).

derivative(cosh(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(Res, Fdiff, sinh(F)).

derivative(tanh(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(Res, Fdiff, sech(F)^2).

derivative(ctgh(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(A, Fdiff, -1),
	mul(Res, A, csch(F)^2).

derivative(csch(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(A, Fdiff, -1),
	mul(B, ctgh(F), csch(F)),
	mul(Res, A, B).

derivative(sech(F), V, Res) :-
	derivative(F, V, Fdiff),
	mul(A, Fdiff, -1),
	mul(B, sech(F), tanh(F)),
	mul(Res, A, B).

% Eval predicates
eval(F + G, Vars, Res) :- eval(F, Vars, FV), eval(G, Vars, GV), Res is FV + GV.
eval(F - G, Vars, Res) :- eval(F, Vars, FV), eval(G, Vars, GV), Res is FV - GV.
eval(F * G, Vars, Res) :- eval(F, Vars, FV), eval(G, Vars, GV), Res is FV * GV.
eval(F ^ G, Vars, Res) :- eval(F, Vars, FV), eval(G, Vars, GV), Res is FV ^ GV.
eval(F / G, Vars, Res) :- eval(F, Vars, FV), eval(G, Vars, GV), Res is FV / GV.
% functions eval
eval(log(F), Vars, Res) :- eval(F, Vars, FV), Res is log(FV).
eval(exp(F), Vars, Res) :- eval(F, Vars, FV), Res is exp(FV).
eval(sin(F), Vars, Res) :- eval(F, Vars, FV), Res is sin(FV).
eval(cos(F), Vars, Res) :- eval(F, Vars, FV), Res is cos(FV).
eval(tan(F), Vars, Res) :- eval(F, Vars, FV), Res is tan(FV).
eval(ctg(F), Vars, Res) :- eval(F, Vars, FV), Res is 1/tan(FV).
eval(sec(F), Vars, Res) :- eval(F, Vars, FV), Res is 1/cos(FV).
eval(csc(F), Vars, Res) :- eval(F, Vars, FV), Res is 1/sin(FV).
eval(arcsin(F), Vars, Res) :- eval(F, Vars, FV), Res is asin(FV).
eval(arccos(F), Vars, Res) :- eval(F, Vars, FV), Res is acos(FV).
eval(acrtan(F), Vars, Res) :- eval(F, Vars, FV), Res is atan(FV).
eval(arcctg(F), Vars, Res) :- eval(F, Vars, FV), Res is atan(1/FV).
eval(arcsec(F), Vars, Res) :- eval(F, Vars, FV), Res is acos(1/FV).
eval(arccsc(F), Vars, Res) :- eval(F, Vars, FV), Res is asin(1/FV).
eval(sinh(F), Vars, Res) :- eval(F, Vars, FV), Res is sinh(FV).
eval(cosh(F), Vars, Res) :- eval(F, Vars, FV), Res is cosh(FV).
eval(tanh(F), Vars, Res) :- eval(F, Vars, FV), Res is tanh(FV).
eval(ctgh(F), Vars, Res) :- eval(F, Vars, FV), Res is 1/tanh(FV).
eval(sech(F), Vars, Res) :- eval(F, Vars, FV), Res is 1/cosh(FV).
eval(csch(F), Vars, Res) :- eval(F, Vars, FV), Res is 1/sinh(FV).
eval(Num, _, Num) :- number(Num).
eval(Var, Vars, Value) :- atom(Var), member(Var/Value, Vars).

eval_deriv(F, Var, Vars, Res, Val) :-
	derivative(F, Var, Res),
	eval(Res, Vars, Val).
