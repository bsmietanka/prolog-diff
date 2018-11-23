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

%functions derivative

derivative(ln(F), V, Res) :-
	derivative(F, V, Fdiff),
	div(Res, (Fdiff), (F)).

derivative(log(A, F), V, Res) :-
	number(A), derivative(F, V, Fdiff),
	mul(B, F, ln(A)),
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

% TODO:?
% (defn sinh [x] (Math/sinh x))
% (defn cosh [x] (Math/cosh x))
% (defn tgh [x] (Math/tanh x))
% (defn ctgh [x] (/ (cosh x) (sinh x)))
% (defn sech [x] (/ 1 (cosh x)))
% (defn csch [x] (/ 1 (sinh x)))

%TODO: value for given x
