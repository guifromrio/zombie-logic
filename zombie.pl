:- dynamic zumbi/3.
:- dynamic parede/2.
:- dynamic em/2.
:- dynamic direcao/1.

not(P) :- (call(P) -> fail; true).
direcao(up).
em(4,3).
parede(5,3).
parede(5,4).
parede(5,5).
parede(5,6).
parede(5,8).
parede(5,9).
parede(5,10).
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

existeParede(Direcao) :- 
  em(X,Y), YCima is Y-1, parede(X, YCima), Direcao = up -> true;
  em(X,Y), XDireita is X+1, parede(XDireita, Y), Direcao = right -> true;
  em(X,Y), YBaixo is Y+1, parede(X, YBaixo), Direcao = bottom -> true;
  em(X,Y), XEsquerda is X-1, parede(XEsquerda, Y), Direcao = left -> true.

melhorAcao(ligarHelicoptero) :- emHeliporto.

melhorAcao(andar) :- 
  not(emHeliporto), direcao(right), not(existeParede(right)), aEsquerdaHeliporto;
  not(emHeliporto), direcao(bottom), not(existeParede(bottom)), acimaHeliporto;
  not(emHeliporto), direcao(left), not(existeParede(left)), aDireitaHeliporto;
  not(emHeliporto), direcao(up), not(existeParede(up)), abaixoHeliporto.

melhorAcao(virar) :-
  not(emHeliporto), existeParede(up), direcao(up);
  not(emHeliporto), existeParede(right), direcao(right);
  not(emHeliporto), existeParede(bottom), direcao(bottom);
  not(emHeliporto), existeParede(left), direcao(left);

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

ligarHelicoptero:- writef("Ligando o Helicóptero! Fugiu com sucesso!").

agir :- direcao(D1), em(X1,Y1), melhorAcao(A), call(A), direcao(D2), em(X2,Y2), writef("em: (%d,%d) %w --- melhorAcao: %w --- em (%d,%d) %w", [X1,Y1,D1,A,X2,Y2,D2]).
