:- dynamic zumbi/3.
:- dynamic parede/2.
:- dynamic em/2.
:- dynamic direcao/1.

direcao(up).
em(4,3).
parede(5,3).

virar:- direcao(up) -> retract(direcao(_)), assert(direcao(right)); 
  direcao(right) -> retract(direcao(_)), assert(direcao(bottom));
  direcao(bottom) -> retract(direcao(_)), assert(direcao(left));
  direcao(left) -> retract(direcao(_)), assert(direcao(up)).

andar:- direcao(up), em(X,Y) -> retract(em(X,Y)), NewY is Y - 1, assert(em(X,NewY));
  direcao(right), em(X,Y) -> retract(em(X,Y)), NewX is X + 1, assert(em(NewX,Y));
  direcao(bottom), em(X,Y) -> retract(em(X,Y)), NewY is Y + 1, assert(em(X,NewY));
  direcao(left), em(X,Y) -> retract(em(X,Y)), NewX is X - 1, assert(em(NewX,Y)).
