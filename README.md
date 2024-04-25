## Motoko Smart Contract for Tic-Tac-Toe

### Explanation of the Key Components:

- **Board State**: A 3x3 array representing the tic-tac-toe board.
- **Game State**: Keeps track of the current state of the game, including the board, current player, and winner.
- **Start New Game**: Initializes the board and sets the current player.
- **Make Move**: Allows a player to make a move if it's their turn and the move is valid. Also checks for a winner after each move.
- **Check Winner**: Checks all possible winning combinations.


## Lottery

### Key Components
- **Participant Data Structure**: Represents each lottery participant with a unique identifier and the participant's blockchain address.
- **Participants List**: A dynamic array that stores all the participants of the lottery.
- **Enter Lottery Function**: Allows a user to enter the lottery if they haven't already entered. This checks to ensure duplicates are not added.
- **Draw Winner Function**: An administrative function that only the manager (in this case, the lottery contract itself as the manager) can call to select a random winner from the list of participants. It uses a basic random number generation approach provided by the `Random` module.
