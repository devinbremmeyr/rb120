Tic Tac Toe is a two player game played on a 3 by 3 grid. Each player places an X or an O in one space of the grid on alternating turns. If one player gets three pieces in a row they win. If all nine spaces are taken and neither player has three in a row. The game is a draw.

Nouns: grid, player, space, pieces
Verbs: places, play

grid
space
Player
-place
-play


Discussion on OO TTT Code:
1. using tests can help catch regression when changes are made to code
2. Should be easier to make changes because code is broken up into classes
3. We have generic class names (Player, Board), wrap our classes in a namespace
4. We don't need the player or square class (Struct for Player)
5. depedency graph should not be a spider web, limited interaction
    TTTGame => Player
    TTTGame => Board
    Board   => Square
6. The Board and Square classes have methods that only pertain to the Board or Square. They don't have collaborators with Player for example. It can be tempting to add more collaborators into the class, but keep in mind this adds more dependency.
7. Instead of having `TTTGAME#human_moves` and `#computer_moves` we could make these both methods of the `Player` class. This would require that we make `Board` a collaborator of `Player` however, so that the `Player` class could make changes to the `Board`.
8. If `Board` had used an array of `Square` objects instead of a hash. What would have changed? The array would index form zero, 

