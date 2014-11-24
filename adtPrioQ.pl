% -*- Mode: Prolog -*-
% adtPrioQu.pl
% David Novick
% 3-07-13

% ADT PrioQ

% newPrioQ/1
% newPrioQ(Q) returns true if Q is instantiated to a new priority queue
%
newPrioQ([ ]).

% isEmptyPrioQ/1
% isEmptyPrioQ(Q) returns true if Q is empty
%
isEmptyPrioQ([ ]).

% insert/3
% insert(Element,OldPrioQ,NewPrioQ) returns true if NewPrioQ is the
% result of inserting Element into OldPrioQ.
% lower values have higher priority.
% The predicate value/2 has to be defined in the application that uses the priority queue
%
insert(E, [ ], [E]).
insert(E, [H|T], [E,H|T]) :- value(E,VE), value(H,VH), VE =< VH.
insert(E, [H|Q], [H|Q2]) :- insert(E, Q, Q2).

% delete/3
% delete(Element,OldPrioQ,NewPrio) returns true if NewPrioQ is the
% result of deleting Element from OldPrioQ
%
delete(E, [E|Q], Q).

% peekPrioQ/2
% peekPrioQ(Element,PrioQ) returns true if Element is the lowest-valued element in PrioQ
%
peekPrioQ(E,[E|_]).