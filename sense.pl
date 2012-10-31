sentir(X,Y):- 
  X = 4, Y = 16 -> not(existeZumbi(bottom)), sentirZumbi(bottom), writef("Ouvi zumbi abaixo\n");
  X = 7, Y = 15 -> not(existeZumbi(right)), sentirZumbi(right), writef("Ouvi zumbi a direita\n");
  X = 7, Y = 18 -> not(existeZumbi(bottom)), sentirZumbi(bottom), writef("Ouvi zumbi abaixo\n");
  writef("Nenhuma percepção\n").
