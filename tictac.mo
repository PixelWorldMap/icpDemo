import Array "mo:base/Array";
import Nat "mo:base/Nat";

actor TicTacToe {
    type Board = [?[Nat]]; // 3x3 board where `null` means empty, `0` for player 1, `1` for player 2
    type Player = {id : Nat; principal: Principal};
    type GameState = {board: Board; currentPlayer: Nat; winner: ?Nat};

    private var gameState: ?GameState = null;

    // Initialize a new game
    public func startNewGame(player1: Principal, player2: Principal): async Bool {
        let initialBoard: Board = [for (_ in [0, 1, 2]) Array.init<Nat?>(3, null)];
        gameState := ?{
            board = initialBoard,
            currentPlayer = 0, // Player 1 starts
            winner = null
        };
        return true;
    }

    // Make a move
    public func makeMove(player: Principal, x: Nat, y: Nat): async Bool {
        assert(gameState != null, "Game not initialized");
        let currentGameState = gameState.get();
        
        // Check if it's the caller's turn
        assert((currentGameState.currentPlayer == 0 && Principal.equal(player, ic.caller())) ||
               (currentGameState.currentPlayer == 1 && Principal.equal(player, ic.caller())),
               "Not your turn or incorrect player");

        // Check if the move is valid
        assert(x < 3 and y < 3 and currentGameState.board[x][y] == null, "Invalid move");

        // Make the move
        currentGameState.board[x][y] := ?currentGameState.currentPlayer;

        // Check for a winner or switch the turn
        switch (checkWinner(currentGameState.board)) {
            case (?winner) {
                currentGameState.winner := ?winner;
            };
            case (null) {
                currentGameState.currentPlayer := 1 - currentGameState.currentPlayer; // Switch player
            };
        };

        gameState := ?currentGameState;
        return true;
    }

    // Check if there's a winner
    private func checkWinner(board: Board): ?Nat {
        // Horizontal, vertical, and diagonal checks
        for (i in [0, 1, 2]) {
            if (board[i][0] != null and board[i][0] == board[i][1] and board[i][1] == board[i][2]) {
                return board[i][0];
            };
            if (board[0][i] != null and board[0][i] == board[1][i] and board[1][i] == board[2][i]) {
                return board[0][i];
            };
        };
        // Diagonals
        if (board[0][0] != null and board[0][0] == board[1][1] and board[1][1] == board[2][2]) {
            return board[0][0];
        };
        if (board[0][2] != null and board[0][2] == board[1][1] and board[1][1] == board[2][0]) {
            return board[0][2];
        };
        return null;
    }
}
