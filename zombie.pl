:- dynamic zumbi/3.
:- dynamic parede/2.
:- dynamic em/2.
:- dynamic direcao/1.

not(P) :- (call(P) -> fail; true).
direcao(up).
em(4,3).
parede(5,3).
emHeliporto :- em(18,17).

virar :- 
  direcao(up) -> retract(direcao(_)), assert(direcao(right)); 
  direcao(right) -> retract(direcao(_)), assert(direcao(bottom));
  direcao(bottom) -> retract(direcao(_)), assert(direcao(left));
  direcao(left) -> retract(direcao(_)), assert(direcao(up)).

andar :- 
  direcao(up), em(X,Y) -> retract(em(X,Y)), NewY is Y - 1, assert(em(X,NewY));
  direcao(right), em(X,Y) -> retract(em(X,Y)), NewX is X + 1, assert(em(NewX,Y));
  direcao(bottom), em(X,Y) -> retract(em(X,Y)), NewY is Y + 1, assert(em(X,NewY));
  direcao(left), em(X,Y) -> retract(em(X,Y)), NewX is X - 1, assert(em(NewX,Y)).

acimaHeliporto :- em(_,Y), Y < 17.
aDireitaHeliporto :- em(X,_), X > 18.
aEsquerdaHeliporto :- em(X,_), X < 18.
abaixoHeliporto :- em(_,Y), Y > 17.

melhorAcao(ligar_helicoptero) :- emHeliporto.

melhorAcao(andar) :- 
  not(emHeliporto), direcao(right), aEsquerdaHeliporto;
  not(emHeliporto), direcao(bottom), acimaHeliporto;
  not(emHeliporto), direcao(left), aDireitaHeliporto;
  not(emHeliporto), direcao(up), abaixoHeliporto.

melhorAcao(virar) :-
  not(emHeliporto), acimaHeliporto, direcao(left);
  not(emHeliporto), acimaHeliporto, direcao(up);
  not(emHeliporto), acimaHeliporto, direcao(right);

  not(emHeliporto), aDireitaHeliporto, direcao(up);
  not(emHeliporto), aDireitaHeliporto, direcao(right);
  not(emHeliporto), aDireitaHeliporto, direcao(bottom);

  not(emHeliporto), aEsquerdaHeliporto, direcao(bottom);
  not(emHeliporto), aEsquerdaHeliporto, direcao(left);
  not(emHeliporto), aEsquerdaHeliporto, direcao(up);

  not(emHeliporto), abaixoHeliporto, direcao(right);
  not(emHeliporto), abaixoHeliporto, direcao(bottom);
  not(emHeliporto), abaixoHeliporto, direcao(left).
