:- dynamic zumbi/3.
:- dynamic parede/2.
:- dynamic em/2.
:- dynamic direcao/1.

not(P) :- (call(P) -> fail; true).
direcao(up).
em(4,3).

parede(5,2).
parede(5,3).
parede(5,4).
parede(5,5).
parede(5,6).

parede(5,8).
parede(5,9).
parede(5,10).

parede(5,12).
parede(5,13).
parede(5,14).

parede(5,16).
parede(5,17).
parede(5,18).
parede(5,19).

parede(5,21).

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

heliporto(Direcao) :-
  em(_,Y), Y < 17, Direcao = bottom;
  em(X,_), X > 18, Direcao = left;
  em(_,Y), Y > 17, Direcao = up;
  em(X,_), X < 18, Direcao = right.

existeParede(Direcao) :- 
  em(X,Y), YCima is Y-1, parede(X, YCima), Direcao = up -> true;
  em(X,Y), XDireita is X+1, parede(XDireita, Y), Direcao = right -> true;
  em(X,Y), YBaixo is Y+1, parede(X, YBaixo), Direcao = bottom -> true;
  em(X,Y), XEsquerda is X-1, parede(XEsquerda, Y), Direcao = left -> true.

melhorAcao(ligarHelicoptero) :- emHeliporto.

melhorAcao(andar) :- 
  direcao(right), not(existeParede(right)), heliporto(right);
  direcao(bottom), not(existeParede(bottom)), heliporto(bottom);
  direcao(left), not(existeParede(left)), heliporto(left);
  direcao(up), not(existeParede(up)), heliporto(up).

melhorAcao(virar) :-
  existeParede(up), direcao(up);
  existeParede(right), direcao(right);
  existeParede(bottom), direcao(bottom);
  existeParede(left), direcao(left);
  
  % Não estamos na direcao do heliporto
  heliporto(X), not(direcao(X)).

ligarHelicoptero:- writef("Ligando o Helicóptero! Fugiu com sucesso!").

agir :- direcao(D1), em(X1,Y1), melhorAcao(A), call(A), direcao(D2), em(X2,Y2), writef("em: (%d,%d) %w --- melhorAcao: %w --- em (%d,%d) %w", [X1,Y1,D1,A,X2,Y2,D2]).
