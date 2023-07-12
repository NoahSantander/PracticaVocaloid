vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverYoung, 5)).
vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).
vocaloid(gumi, cancion(foreverYoung, 4)).
vocaloid(gumi, cancion(tellYourWorld, 5)).
vocaloid(seeU, cancion(novemberRain, 6)).
vocaloid(seeU, cancion(nightFever, 5)).

% 1
% duracionDeTodasLasCanciones/2 Relaciona un vocaloid con la suma de las duraciones de todas sus canciones
duracionDeTodasLasCanciones(Vocaloid, Duracion):-
    findall(DuracionCancion, vocaloid(Vocaloid, cancion(_, DuracionCancion)), ListaDuraciones),
    sumlist(ListaDuraciones, Duracion).

% sabeMasDeUna Saber si un vocaloid sabe mas de una cancion
sabeMasDeUna(Vocaloid):-
    vocaloid(Vocaloid, Cancion1),
    vocaloid(Vocaloid, Cancion2),
    Cancion1 \= Cancion2.

% esNovedoso/1 Saber si un vocaloid es novedoso (Canta mas de una cancion y la suma de las duraciones de las canciones es menor a 15)
esNovedoso(Vocaloid):-
    sabeMasDeUna(Vocaloid),
    duracionDeTodasLasCanciones(Vocaloid, Duracion),
    Duracion < 15.

% 2
% cancionesCortas/1 Saber si en una lista de canciones todas son cortas (Dura 4 minutos o menos)
cancionesCortas([DuracionCanciones]):-
    DuracionCanciones =< 4.
cancionesCortas([DuracionCancion|CancionesSiguientes]):-
    DuracionCancion =< 4,
    cancionesCortas(CancionesSiguientes).

% esAcelerado/1 Saber si un vocaloid es acelerado (No le gusta cantar canciones largas)
esAcelerado(Vocaloid):-
    vocaloid(Vocaloid, _),
    findall(DuracionCancion, vocaloid(Vocaloid, cancion(_, DuracionCancion)), DuracionCanciones),
    cancionesCortas(DuracionCanciones).

% 1
% concierto(nombre, pais, fama, tipo)
% gigante(cantMinimaDeCanciones, SumaDeLaDuracionDeTodasLasCancionesMinima) - mediano(DuracionMaximaDeTodasLasCanciones) - pequeno(DuracionMinimaDeAlgunaCancion)
concierto(mikuExpo, usa, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, usa, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequeno(4)).

% 2
tieneLasCancionesMinimas(Vocaloid, CantMinimaCanciones):-
    findall(Cancion, vocaloid(Vocaloid, cancion(Cancion, _)), ListaCanciones),
    length(ListaCanciones, CantCanciones),
    CantCanciones >= CantMinimaCanciones.

% cumpleConLosRequisitos/2 Relaciona a un vocaloid con los requisitos de un concierto si los cumple
cumpleConLosRequisitos(Vocaloid, pequeno(DuracionMinimaCancion)):-
    not(forall(vocaloid(Vocaloid, cancion(_, Duracion)), Duracion < DuracionMinimaCancion)).

cumpleConLosRequisitos(Vocaloid, mediano(DuracionMaximaCancion)):-
    forall(vocaloid(Vocaloid, cancion(_, Duracion)), Duracion < DuracionMaximaCancion).

cumpleConLosRequisitos(Vocaloid, gigante(CantMinimaCanciones, SumatoriaDeDuracionCancionesMinima)):-
    tieneLasCancionesMinimas(Vocaloid, CantMinimaCanciones),
    duracionDeTodasLasCanciones(Vocaloid, Duracion),
    Duracion > SumatoriaDeDuracionCancionesMinima.

% puedeParticiparDelConcierto/2 Relaciona a un vocaloid con un concierto del que puede participar
puedeParticiparDelConcierto(hatsuneMiku, Concierto):-
    concierto(Concierto, _, _, _).

puedeParticiparDelConcierto(Vocaloid, Concierto):-
    vocaloid(Vocaloid, _),
    concierto(Concierto, _, _, Requisitos),
    cumpleConLosRequisitos(Vocaloid, Requisitos).

% 3
famaDelConcierto(Vocaloid, FamaDelConcierto):-
    concierto(Concierto, _, FamaDelConcierto, _),
    puedeParticiparDelConcierto(Vocaloid, Concierto).

% calcularFama/2 Relaciona un vocaloid con su fama
calcularFama(Vocaloid, Fama):-
    findall(Cancion, vocaloid(Vocaloid, cancion(Cancion, _)), ListaCanciones),
    length(ListaCanciones, CantCanciones),
    findall(FamaConcierto, famaDelConcierto(Vocaloid, FamaConcierto), ListaFamaConciertos),
    sumlist(ListaFamaConciertos, FamaConciertos),
    Fama is FamaConciertos*CantCanciones.

noTieneMasFamaQueOtro(VocaloidMayor, VocaloidMenor):-
    vocaloid(VocaloidMayor, _),
    vocaloid(VocaloidMenor, _),
    calcularFama(VocaloidMayor, FamaMayor),
    calcularFama(VocaloidMenor, FamaMenor),
    FamaMayor > FamaMenor.

% elMasFamoso/1 Saber el vocaloid con mayor nivel de fama
elMasFamoso(Vocaloid):-
    vocaloid(Vocaloid, _),
    not(noTieneMasFamaQueOtro(_, Vocaloid)).

% 4
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

esElUnicoParticipante(Conocido, Concierto):-
    not(puedeParticiparDelConcierto(Conocido, Concierto)).
esElUnicoParticipante(Conocido, Concierto):-
    puedeParticiparDelConcierto(Conocido, Concierto),
    conoce(Conocido, ConocidoDelConocido),
    esElUnicoParticipante(ConocidoDelConocido, Concierto).

participanteUnico(Vocaloid, Concierto):-
    conoce(Vocaloid, Conocido),
    esElUnicoParticipante(Conocido, Concierto).

% 5
% No hay que agregar nada debido al uso de functores y polimorfismo