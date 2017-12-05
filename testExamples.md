#  given-events/when-command/then-events scenarios

1. Create game command
 *    should emit game created event
        * Given: No game exists
        * When: A game is created
        * Then : A game should be created

2. Join game command
 *    should emit game joined event
        * Given: You are alone in a game after creating it
        * When: Another player joins the game
        * Then: A player should have joined the game
 *    should emit FullGameJoinAttempted when game full
        * Given: A game is already full
        * When: A new player tries to join a full game
        * Then: The player should be blocked from joining the game

3. Place move command
 *    should emit MovePlaced on first game move
        * Given: That no move has been played yet.
        * When: A player plays the first move
        * Then: The move should be made?
 *    should emit IllegalMove when square is already occupied
        * Given: That the square has already been occupied
        * When: A player tries to occupy the square
        * Then: The player should be stopped with the illegalmove message.
 *    Should emit NotYourMove if attempting to make move out of turn
        * Given: It is not your turn
        * When: You try to make a move
        * Then: The move should be blocked. It's not your turn!
 *    Should emit game won on <case x>
        * Given: That the player has two x in a row
        * When: The third x is placed in the row
        * Then: The player should win
 *    Should not emit game draw if won on last move
        * Given: That it's the last move
        * When: You occupy a square needed to win
        * Then: You should win
 *    Should emit game draw when neither wins <case x>
        * Given: That all squares are occupied
        * When: No more moves can be made
        * Then: The game should result in a draw.