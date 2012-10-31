:- dynamic zumbi/2.
:- dynamic zumbiMorto/2.
:- dynamic parede/2.
:- dynamic em/2.
:- dynamic visitado/2.
:- dynamic direcao/1.

not(P) :- (call(P) -> fail; true).

:- ['paredes.pl'].
:- ['sense.pl'].

direcao(right).
em(4,3).

sentirZumbi(Direcao) :- 
  Direcao = up -> em(X,Y), YCima is Y-1, assert(zumbi(X, YCima));
  Direcao = right -> em(X,Y), XDireita is X+1, assert(zumbi(XDireita, Y));
  Direcao = bottom -> em(X,Y), YBaixo is Y+1, assert(zumbi(X, YBaixo));
  Direcao = left -> em(X,Y), XEsquerda is X-1, assert(zumbi(XEsquerda, Y)).

matarZumbi(Direcao) :- 
  Direcao = up -> em(X,Y), YCima is Y-1, retract(zumbi(X, YCima)), assert(zumbiMorto(X, YCima));
  Direcao = right -> em(X,Y), XDireita is X+1, retract(zumbi(XDireita, Y)), assert(zumbiMorto(XDireita, Y));
  Direcao = bottom -> em(X,Y), YBaixo is Y+1, retract(zumbi(X, YBaixo)), assert(zumbiMorto(X, YBaixo));
  Direcao = left -> em(X,Y), XEsquerda is X-1, retract(zumbi(XEsquerda, Y)), assert(zumbiMorto(XEsquerda, Y)).

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
  em(X,_), X < 18, Direcao = right;
  Direcao = here.

existeObstaculo(Direcao) :- existeParede(Direcao); existeZumbi(Direcao).

existeParede(Direcao) :- 
  em(X,Y), YCima is Y-1, parede(X, YCima), Direcao = up;
  em(X,Y), XDireita is X+1, parede(XDireita, Y), Direcao = right;
  em(X,Y), YBaixo is Y+1, parede(X, YBaixo), Direcao = bottom;
  em(X,Y), XEsquerda is X-1, parede(XEsquerda, Y), Direcao = left.

existeZumbi(Direcao) :- 
  em(X,Y), YCima is Y-1, zumbi(X, YCima), Direcao = up;
  em(X,Y), XDireita is X+1, zumbi(XDireita, Y), Direcao = right;
  em(X,Y), YBaixo is Y+1, zumbi(X, YBaixo), Direcao = bottom;
  em(X,Y), XEsquerda is X-1, zumbi(XEsquerda, Y), Direcao = left;
  em(X,Y), zumbi(X, Y), Direcao = here.

existeZumbiMorto(Direcao) :- 
  em(X,Y), YCima is Y-1, zumbiMorto(X, YCima), Direcao = up;
  em(X,Y), XDireita is X+1, zumbiMorto(XDireita, Y), Direcao = right;
  em(X,Y), YBaixo is Y+1, zumbiMorto(X, YBaixo), Direcao = bottom;
  em(X,Y), XEsquerda is X-1, zumbiMorto(XEsquerda, Y), Direcao = left;
  em(X,Y), zumbiMorto(X, Y), Direcao = here.

proxDirecao(D1, D2):- D1 = up -> D2 = right; D1 = right -> D2 = bottom; D1 = bottom -> D2 = left; D1 = left -> D2 = up.

melhorAcao(ligarHelicoptero) :- emHeliporto.

melhorAcao(Acao) :-
  % Estamos na direção do heliporto e tem um zumbi no caminho... atire!
  existeZumbi(X), direcao(X), heliporto(X) -> Acao = atirar;
  % Nunca continue encarando uma parede
  existeObstaculo(X), direcao(X) -> Acao = virar, 
    writef("Virei pois existe obstaculo na minha direcao\n");
  direcao(Y), proxDirecao(Y, D), existeObstaculo(D), not(existeObstaculo(Y)) -> Acao = andar, 
    writef("Andei pois tem obstaculo na proxima direcao \n");
  direcao(Y), proxDirecao(Y, D), not(existeObstaculo(D)), not(heliporto(Y)) -> Acao = virar, 
    writef("Virei pois nao estou na direcao do heliporto e na proxima direcao nao existe obstaculo\n");
  Acao = andar, writef("Andei\n").

ligarHelicoptero:- writef("Ligando o Helicóptero! Fugiu com sucesso!\n").

atirar :- direcao(X), matarZumbi(X), writef("Atirei e matei o zumbi na direcao %w\n", [X]).

visitar :- em(X,Y), assert(visitado(X,Y)), sentir(X,Y).

status :- writef("status - "), direcao(D), em(X,Y), heliporto(H), writef("Direcao: %w, em: (%d,%d), H: %w\n", [D,X,Y,H]) -> true.

agir :-  status, melhorAcao(A), call(A), status, visitar, writef("\n") -> true.
