% -*- Mode: Prolog -*-
% astar.pl
% David Novick
% 3-07-13
% A* search

% load ADT PrioQ
:- [adtPrioQ].

% For prioQ, define the value of an element in the priority queue
value(node(_State,_G,F,_Action,_Parent),F).

% astar/2
% astar(StartState,GoalState).
% A* search from StartState to GoalState
% This clause sets up search with fringe containing node for StartState, list of explored states containing
%   StartState, a variable for the EndNode, and the GoalState. When astar/4 succeeds, astar/2 prints the path
%   from the StartState to the GoalState.
% Example: astar(s(1,2,3,4,blank,5,6,7,8),s(1,2,3,4,5,6,7,8,blank)).
% A node contains a state, g(n), f(n), the action that produced the state, and node's parent node.
%
astar(StartState,GoalState) :-
  computeH(StartState,H),
  astar([node(StartState,0,H,start,nil)],[StartState],EndNode,GoalState),
  printPath(EndNode).

% astar/4
% bfs(Fringe,ExploredStates,EndNode,GoalState).
% Main driver for the A* search. Successful search instantiates EndNode to the node
% where the search reached the goal.
%
% If the fringe is empty, there are no more nodes to expand, and thus the search has failed.
%
astar(Fringe,_Explored,node(search_failed,nil),_GoalState) :-
  isEmptyPrioQ(Fringe).
%
% If the lowest h-value node in the fringe is the GoalState, then the search succeeds.
%
astar(Fringe,_Explored,Node,GoalState) :-
  peekPrioQ(Node,Fringe),
  isGoalState(Node,GoalState).
%
% Otherwise, expand the lowest h-value node in the fringe and continue the search.
%
astar(Fringe,Explored,EndNode,GoalState) :-
  delete(Node,Fringe,Fringe2),
  expand(Node,Explored,NewExplored,Fringe2,NewFringe),
  astar(NewFringe,NewExplored,EndNode,GoalState).

% isGoalState/2
% isGoalState(CurrentNode,GoalState).
% Succeed if node's state is the goal state
%
isGoalState(node(State,_G,_F,_Action,_Parent),State).

% expand/5
% Given a node and list of explored states, find the children of the node, and update the list
% of unexplored nodes and the fringe.
% 
expand(Node,Explored,NewExplored,Fringe,NewFringe) :-
  findall(N,parent(Node,N),NewNodes),
  addNewNodes(NewNodes,Explored,NewExplored,Fringe,NewFringe).

% addNewNodes/5
% Given a list of newly generated nodes, update the list of explored states and the fringe
%
% If there are no new nodes, the list of explored states and the fringe both stay the same.
%
addNewNodes([],Explored,Explored,Fringe,Fringe).
%
% If a node represents a state that has already been explored, do not add it to the list of explored
% states or to the fringe, and add any remaining nodes.
%
addNewNodes([Node|Nodes],Explored,NewExplored,Fringe,NewFringe) :-
  stateAlreadyExplored(Node,Explored),
  addNewNodes(Nodes,Explored,NewExplored,Fringe,NewFringe).
%
% Otherwise the node represents a new state, so add the state to the list of explored states,
% add the node to the fringe, and add any remaining nodes.
%
addNewNodes([Node|Nodes],Explored,NewExplored,Fringe,NewFringe) :-
  addStateToExplored(Node,Explored,Explored2),
  insert(Node,Fringe,Fringe2),
  addNewNodes(Nodes,Explored2,NewExplored,Fringe2,NewFringe).

stateAlreadyExplored(node(State,_G,_F,_Action,_Parent),Explored) :-
  member(State,Explored).

% addStateToExplored/3
%
% Given a node, add the node's state to the list of explored states.
%
addStateToExplored(node(State,_G,_F,_Actions,_Parent),Explored,[State|Explored]).

% parent/2
% parent(ParentNode,ChildNode)
%
% Returns true if the second argument is a child node of the first argument. A child node is a node
% that has a valid state transition from the parent to the child.
% Each node has two arguments: the state, and the node's parent node. So the parent of the
% the current node's child is the current node.
% For A* search, the cost is just the number of moves, so each move increments G by 1. The total value
% of the heuristic function f is thus G + H, where H is the admissible heurstic for the cost of solving
% the puzzle from this state.
%
parent(node(State,G,F,OldAction,OldParent),node(NewState,G2,F2,Action,node(State,G,F,OldAction,OldParent))) :-
  transition(State,NewState,Action),
  computeH(NewState,H),
  G2 is G + 1,
  F2 is G2 + H.

% computeH/2
%
% Given a state in the 8-puzzle, compute the heurstic of the cost of solution. The approach taken here
% involves iterating through the tiles, from 1 to 8, so this predicate sets up computeH/3 by starting
% with tile 1.
%
computeH(State, H) :-
  computeH(1, State, H).

% computeH/3
%
% Iterate through the eight tiles of the 8 puzzle, computing and summing the Manhattan distance for
% each of the tiles.
%
% Base case: If the counter has reached 9, then the program has evaluated all eight tiles.
%
computeH(9,_State,0).
%
% Recursive case: Otherwise, determine where the tile is currently in the grid,compute the Manhattan
% distance from that position to where the tile should be, increment the counter, compute the Manhattan
% distance for the rest of the tiles, and return the total.
%
computeH(Tile,State, H) :-
  findTilePos(Tile,State,Pos),
  manhattan(Tile,Pos,M),
  NextTile is Tile + 1,
  computeH(NextTile,State, H2),
  H is M + H2.

% findTilePos/3
% findTilePos(Tile,State,TilePosition)
%
% Given a tile (from 1 to 8) and a state of the 8-puzzle, determine the grid position of the tile
% in the current state.
%
findTilePos(Tile,s(Tile,_P2,_P3,_P4,_P5,_P6,_P7,_P8,_P9),1).
findTilePos(Tile,s(_P1,Tile,_P3,_P4,_P5,_P6,_P7,_P8,_P9),2).
findTilePos(Tile,s(_P1,_P2,Tile,_P4,_P5,_P6,_P7,_P8,_P9),3).
findTilePos(Tile,s(_P1,_P2,_P3,Tile,_P5,_P6,_P7,_P8,_P9),4).
findTilePos(Tile,s(_P1,_P2,_P3,_P4,Tile,_P6,_P7,_P8,_P9),5).
findTilePos(Tile,s(_P1,_P2,_P3,_P4,_P5,Tile,_P7,_P8,_P9),6).
findTilePos(Tile,s(_P1,_P2,_P3,_P4,_P5,_P6,Tile,_P8,_P9),7).
findTilePos(Tile,s(_P1,_P2,_P3,_P4,_P5,_P6,_P7,Tile,_P9),8).
findTilePos(Tile,s(_P1,_P2,_P3,_P4,_P5,_P6,_P7,_P8,Tile),9).

% manhattan/3
% manhatttan(PositionOfTile,PositionOfDestination,ManhattanDistance)
%
% Given two positions in the grid (the tile's current position and its position in the goal state),
% intantiate the third argument to be the Manhattan distance between the positions. This involves
% calculating and summing the vertical and horizontal differences.
%
manhattan(P1,P2,M) :-
  horizontalMoves(P1,P2,Horizontal),
  verticalMoves(P1,P2,Vertical),
  M is Horizontal + Vertical.

% horizontalMoves/3
% horizontalMoves(Position1,Position2,NumberOfMoves)
%
% Given two positions in the 8-puzzle grid, determine the columns of the positions, and instantiate the
% third argument to be the absolute difference between the columns.
%
horizontalMoves(P1,P2,N) :-
  col(P1,C1),
  col(P2,C2),
  N = abs(C1-C2).

% verticalMoves(Position1,Position2,NumberOfMoves)
%
% Given two positions in the 8-puzzle grid, determine the rows of the positions, and instantiate the
% third argument to be the absolute difference between the rows.
%
verticalMoves(P1,P2,N) :-
  row(P1,R1),
  row(P2,R2),
  N = abs(R1-R2).

% col/2
% col(GridPosition,GridColumn)
% Given a position in the 8-puzzle grid (see transition/2 for the layout), instantiate the second
% argument to the position's column in the grid. For example, position 4 is in column 1.
%
col(1,1).
col(2,2).
col(3,3).
col(4,1).
col(5,2).
col(6,3).
col(7,1).
col(8,2).
col(9,3).

% row/2
% row(GridPosition,GridRow)
% Given a position in the 8-puzzle grid (see transition/2 for the layout), instantiate the second
% argument to the position's row in the grid. For example, position 4 is in row 2.
%
row(1,1).
row(2,1).
row(3,1).
row(4,2).
row(5,2).
row(6,2).
row(7,3).
row(8,3).
row(9,3).

% transition/2
% transition(ParentState,ChildState, Action).
% Presents the legal transitions between states. This depends on the specifics of the problem.  Here the
% problem is to solve the eight puzzle.
%
% Each state is s(P1,P2,P3,P4,P5,P6,P7,P8,P9), where each Pn is the position in the eight puzzle
% of a number tile or the blank. The layout of the positions is
%   P1   P2   P3
%   P4   P5   P6
%   P7   P8   P9
%
% The action is instantiated to a literal that describes the move, for example 'move 3 from p7 to p8'
%
transition(s(blank,P2,P3,P4,P5,P6,P7,P8,P9),s(P2,blank,P3,P4,P5,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P2, ' from p2 to p1'], Action).
transition(s(blank,P2,P3,P4,P5,P6,P7,P8,P9),s(P4,P2,P3,blank,P5,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P4, ' from p4 to p1'], Action).
transition(s(P1,blank,P3,P4,P5,P6,P7,P8,P9),s(blank,P1,P3,P4,P5,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P1, ' from p1 to p2'], Action).
transition(s(P1,blank,P3,P4,P5,P6,P7,P8,P9),s(P1,P3,blank,P4,P5,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P3, ' from p3 to p2'], Action).
transition(s(P1,blank,P3,P4,P5,P6,P7,P8,P9),s(P1,P5,P3,P4,blank,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P5, ' from p5 to p2'], Action).
transition(s(P1,P2,blank,P4,P5,P6,P7,P8,P9),s(P1,blank,P2,P4,P5,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P2, ' from p2 to p3'], Action).
transition(s(P1,P2,blank,P4,P5,P6,P7,P8,P9),s(P1,P2,P6,P4,P5,blank,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P6, ' from p6 to p3'], Action).
transition(s(P1,P2,P3,blank,P5,P6,P7,P8,P9),s(blank,P2,P3,P1,P5,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P1, ' from p1 to p4'], Action).
transition(s(P1,P2,P3,blank,P5,P6,P7,P8,P9),s(P1,P2,P3,P5,blank,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P5, ' from p5 to p4'], Action).
transition(s(P1,P2,P3,blank,P5,P6,P7,P8,P9),s(P1,P2,P3,P7,P5,P6,blank,P8,P9), Action) :-
     atomic_list_concat(['move ', P7, ' from p7 to p4'], Action).
transition(s(P1,P2,P3,P4,blank,P6,P7,P8,P9),s(P1,blank,P3,P4,P2,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P2, ' from p2 to p5'], Action).
transition(s(P1,P2,P3,P4,blank,P6,P7,P8,P9),s(P1,P2,P3,blank,P4,P6,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P4, ' from p4 to p5'], Action).
transition(s(P1,P2,P3,P4,blank,P6,P7,P8,P9),s(P1,P2,P3,P4,P6,blank,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P6, ' from p6 to p5'], Action).
transition(s(P1,P2,P3,P4,blank,P6,P7,P8,P9),s(P1,P2,P3,P4,P8,P6,P7,blank,P9), Action) :-
     atomic_list_concat(['move ', P8, ' from p8 to p5'], Action).
transition(s(P1,P2,P3,P4,P5,blank,P7,P8,P9),s(P1,P2,blank,P4,P5,P3,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P3, ' from p3 to p6'], Action).
transition(s(P1,P2,P3,P4,P5,blank,P7,P8,P9),s(P1,P2,P3,P4,blank,P5,P7,P8,P9), Action) :-
     atomic_list_concat(['move ', P5, ' from p5 to p6'], Action).
transition(s(P1,P2,P3,P4,P5,blank,P7,P8,P9),s(P1,P2,P3,P4,P5,P9,P7,P8,blank), Action) :-
     atomic_list_concat(['move ', P9, ' from p9 to p6'], Action).
transition(s(P1,P2,P3,P4,P5,P6,blank,P8,P9),s(P1,P2,P3,blank,P5,P6,P4,P8,P9), Action) :-
     atomic_list_concat(['move ', P4, ' from p4 to p7'], Action).
transition(s(P1,P2,P3,P4,P5,P6,blank,P8,P9),s(P1,P2,P3,P4,P5,P6,P8,blank,P9), Action) :-
     atomic_list_concat(['move ', P8, ' from p8 to p7'], Action).
transition(s(P1,P2,P3,P4,P5,P6,P7,blank,P9),s(P1,P2,P3,P4,blank,P6,P7,P5,P9), Action) :-
     atomic_list_concat(['move ', P5, ' from p5 to p8'], Action).
transition(s(P1,P2,P3,P4,P5,P6,P7,blank,P9),s(P1,P2,P3,P4,P5,P6,blank,P7,P9), Action) :-
     atomic_list_concat(['move ', P7, ' from p7 to p8'], Action).
transition(s(P1,P2,P3,P4,P5,P6,P7,blank,P9),s(P1,P2,P3,P4,P5,P6,P7,P9,blank), Action) :-
     atomic_list_concat(['move ', P9, ' from p9 to p8'], Action).
transition(s(P1,P2,P3,P4,P5,P6,P7,P8,blank),s(P1,P2,P3,P4,P5,blank,P7,P8,P6), Action) :-
     atomic_list_concat(['move ', P6, ' from p6 to p9'], Action).
transition(s(P1,P2,P3,P4,P5,P6,P7,P8,blank),s(P1,P2,P3,P4,P5,P6,P7,blank,P8), Action) :-
     atomic_list_concat(['move ', P8, ' from p8 to p9'], Action).

% printPath/1
% Recursively prints the search path represented by the chain of parent nodes, printing start node first and ending
% with the goal node.
%
printPath(nil).
printPath(node(State,_G,_F,Action, Parent)) :- printPath(Parent), write(Action), write(' --> '), writeln(State).

% printList/1
printList([]).
printList([H|T]) :- writeln(H), printList(T).