:- initialization(main, main).
:- dynamic board/2.

main(_) :-
    game.

game :-
    init_board,
    print_board,
    game_loop('X player').

init_board :-
    retractall(board(_, _)),
    foreach(between(1, 9, Tile), assert(board(Tile, empty))).

game_loop(Player) :-
    make_move(Player),
    print_board,
    won(Player) -> format("~w won~n", [Player]);
    \+ board(_, empty) -> writeln("Tie");
    other_player(Player, Next), game_loop(Next).

make_move(Player) :-
    format("~w move: ", [Player]),
    read_line_to_string(user_input, MoveString),
    (number_string(Move, MoveString), validate_move(Move)) -> retract(board(Move, _)), assert(board(Move, Player));
    writeln("Invalid move"), make_move(Player).

validate_move(Move) :-
    integer(Move),
    0 < Move, Move < 10,
    board(Move, empty).

print_board :-
    findall([Tile, State], board(Tile, State), States),
    sort(States, SortedStates),
    maplist(format_state, SortedStates, FormattedStates), !,
    board_format_string(String),
    format(String, FormattedStates).

format_state([Tile, empty], Out) :- Out = Tile.
format_state([_, 'X player'], Out) :- Out = 'X'.
format_state([_, 'O player'], Out) :- Out = 'O'.

won(Player) :-
    % Horizontal lines
    board(1, Player), board(2, Player), board(3, Player), !;
    board(4, Player), board(5, Player), board(6, Player), !;
    board(7, Player), board(8, Player), board(9, Player), !;
    % Vertical lines
    board(1, Player), board(4, Player), board(7, Player), !;
    board(2, Player), board(5, Player), board(8, Player), !;
    board(3, Player), board(6, Player), board(9, Player), !;
    % Diagonals
    board(1, Player), board(5, Player), board(9, Player), !;
    board(3, Player), board(5, Player), board(7, Player).

board_format_string(
"┌───┬───┬───┐
│ ~w │ ~w │ ~w │
├───┼───┼───┤
│ ~w │ ~w │ ~w │
├───┼───┼───┤
│ ~w │ ~w │ ~w │
└───┴───┴───┘
"
).

other_player('X player', 'O player').
other_player('O player', 'X player').
