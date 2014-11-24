% load ADT PrioQ
:- [adtPrioQ].

% astar/2
astar(StartState,'Itapiranga') :-
    city(StartState),
    distance_to_itapiranga(StartState,H),
    astar([node(StartState,0,H,nil)],[StartState],EndNode,'Itapiranga'),
    printPath(EndNode).

% astar/4
astar(Fringe,_ ,node(search_failed,nil), _) :-
    isEmptyPrioQ(Fringe).

astar(Fringe, _, Node, GoalState) :-
    peekPrioQ(Node,Fringe),
    isGoalState(Node,GoalState).

astar(Fringe, Explored, EndNode, GoalState) :-
    delete(Node,Fringe,Fringe2),
    expand(Node,Explored,NewExplored,Fringe2,NewFringe),
    astar(NewFringe,NewExplored,EndNode,GoalState).


% isGoalState/2
isGoalState(node(State,_G,_F,_Action,_Parent),State).

% expand/5
expand(Node,Explored,NewExplored,Fringe,NewFringe) :-
    findall(N,parent(Node,N),NewNodes),
    addNewNodes(NewNodes,Explored,NewExplored,Fringe,NewFringe).
    



%graph
city('Araranguá').
city('Blumenau').
city('Bom Retiro').
city('Campo Erê').
city('Campos Novos').
city('Canoinhas').
city('Capinzal').
city('Chapecó').
city('Dionísio Cerqueira').
city('Florianópolis').
city('Herval dOeste').
city('Iraí').
city('Itajaí').
city('Itapiranga').
city('Joinville').
city('Lages').
city('Laguna').
city('Mafra').
city('Maravilha').
city('Monte Castelo').
city('Navegantes').
city('Palhoça').
city('Ponte Alta').
city('Porto União').
city('São Lourenço do Oeste').
city('São Miguel do Oeste').
city('Xanxerê').

edge(city, city, distance).
edge('Florianópolis', 'Palhoça', 20).
edge('Florianópolis', 'Itajaí', 70).
edge('Palhoça', 'Itajaí', 80).
edge('Palhoça', 'Bom Retiro', 100).
edge('Palhoça', 'Laguna', 100).
edge('Laguna', 'Araranguá', 70).
edge('Laguna', 'Bom Retiro', 120).
edge('Araranguá', 'Bom Retiro', 190).
edge('Araranguá', 'Lages', 220).
edge('Lages', 'Bom Retiro', 50).
edge('Lages', 'Ponte Alta', 40).
edge('Lages', 'Campos Novos', 60).
edge('Itajaí', 'Bom Retiro', 140).
edge('Itajaí', 'Navegantes', 10).
edge('Navegantes', 'Blumenau', 50).
edge('Navegantes', 'Joinville', 70).
edge('Joinville', 'Mafra', 80).
edge('Mafra', 'Porto União', 130).
edge('Mafra', 'Canoinhas', 70).
edge('Mafra', 'Monte Castelo', 85).
edge('Monte Castelo', 'Canoinhas', 80).
edge('Canoinhas', 'Porto União', 80).
edge('Monte Castelo', 'Ponte Alta', 90).
edge('Monte Castelo', 'Blumenau', 85).
edge('Ponte Alta', 'Blumenau', 110).
edge('Ponte Alta', 'Campos Novos', 30).
edge('Campos Novos', 'Herval d’Oeste', 30).
edge('Campos Novos', 'Capinzal', 45).
edge('Capinzal', 'Herval d’Oeste', 15).
edge('Capinzal', 'Chapecó', 110).
edge('Herval d’Oeste', 'Porto União', 135).
edge('Herval d’Oeste', 'Xanxerê', 80).
edge('Porto União', 'São Lourenço', 140).
edge('Xanxerê', 'São Lourenço', 80).
edge('São Lourenço', 'Campo Erê', 25).
edge('Campo Erê', 'Dionísio Cerqueira', 27).
edge('Campo Erê', 'Maravilha', 25).
edge('Dionísio Cerqueira', 'São Miguel do Oeste', 40).
edge('São Miguel do Oeste', 'Maravilha', 15).
edge('São Miguel do Oeste', 'Itapiranga', 35).
edge('Itapiranga', 'Iraí', 17).
edge('Iraí', 'Maravilha', 8).
edge('Iraí', 'Chapecó', 65).
edge('Chapecó', 'Xanxerê', 40).
edge('Chapecó', 'Maravilha', 70).

%heuristic
distance_to_itapiranga(city, distance).
distance_to_itapiranga('Araranguá', 141.558082).
distance_to_itapiranga('Blumenau', 143.673328).
distance_to_itapiranga('Bom Retiro', 132.008527).
distance_to_itapiranga('Campo Erê', 30.7950804).
distance_to_itapiranga('Campos Novos', 77.4938699).
distance_to_itapiranga('Canoinhas', 106.977317).
distance_to_itapiranga('Capinzal', 65.221857).
distance_to_itapiranga('Chapecó', 34.0568427).
distance_to_itapiranga('Dionísio Cerqueira', 28.0605933).
distance_to_itapiranga('Florianópolis', 160.244979).
distance_to_itapiranga('Herval d’Oeste', 68.530849).
distance_to_itapiranga('Iraí', 14.2973657).
distance_to_itapiranga('Itajaí', 155.943566).
distance_to_itapiranga('Itapiranga', 0).
distance_to_itapiranga('Joinville', 152.823426).
distance_to_itapiranga('Lages', 106.769501).
distance_to_itapiranga('Laguna', 157.672145).
distance_to_itapiranga('Mafra', 125.428319).
distance_to_itapiranga('Maravilha', 20.8025489).
distance_to_itapiranga('Monte Castelo', 109.714612).
distance_to_itapiranga('Navegantes', 156.664752).
distance_to_itapiranga('Palhoça', 156.484256).
distance_to_itapiranga('Ponte Alta', 103.565947).
distance_to_itapiranga('Porto União', 86.3239288).
distance_to_itapiranga('São Lourenço', 36.6222413).
distance_to_itapiranga('São Miguel do Oeste', 14.9680813).
distance_to_itapiranga('Xanxerê', 41.513169).