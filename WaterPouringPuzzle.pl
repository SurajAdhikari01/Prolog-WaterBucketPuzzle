% Define the initial state and the goal state
initial_state([0,0]). % Initial state where both buckets are empty
goal_state([_,2]).    % Goal state where 4-liter bucket contains 2 liters of water

% Define actions that can be taken from each state
% Fill the 3-liter bucket
action([X,Y], [3,Y]) :- Y < 3, X >= 0.
% Fill the 4-liter bucket
action([X,Y], [X,4]) :- X < 4, Y >= 0.
% Empty the 3-liter bucket
action([X,Y], [0,Y]) :- X >= 0, Y >= 0.
% Empty the 4-liter bucket
action([X,Y], [X,0]) :- X >= 0, Y >= 0.
% Pour water from 3-liter bucket to 4-liter bucket
action([X,Y], [X1,Y1]) :- X > 0, Y < 4, NewX is max(X - (4 - Y), 0), NewY is min(X + Y, 4), X1 is NewX, Y1 is NewY.
% Pour water from 4-liter bucket to 3-liter bucket
action([X,Y], [X1,Y1]) :- Y > 0, X < 3, NewY is max(Y - (3 - X), 0), NewX is min(X + Y, 3), X1 is NewX, Y1 is NewY.

% Define a predicate to perform a breadth-first search
breadth_first_search(Start, Goal, Path) :-
    bfs([[Start]], Goal, Path).

% Base case: If the current state is the goal state, return the path
bfs([[Goal|Path]|_], Goal, [Goal|Path]).
% Recursive case: Explore neighboring states
bfs([[State|Path]|Paths], Goal, FinalPath) :-
    findall([NewState, State|Path], (action(State, NewState), \+ member(NewState, [State|Path])), NewPaths),
    append(Paths, NewPaths, UpdatedPaths),
    bfs(UpdatedPaths, Goal, FinalPath).

% Define a predicate to solve the problem
solve(StartState, Path) :-
    goal_state(GoalState),
    breadth_first_search(StartState, GoalState, Path).
