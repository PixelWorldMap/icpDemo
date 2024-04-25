import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";

actor SeaBattle {
    type Cell = {
        occupied: Bool;
        hit: Bool;
    };
    
    type Board = [[Cell]];
    type Player = {id: Nat; principal: Principal; board: Board};
    type GameState = {players: [Player]; currentPlayerIndex: Nat; gameStarted: Bool};

    private var gameState: ?GameState = null;

    // Initialize a new game with two players
    public func startNewGame(player1: Principal, player2: Principal): async Bool {
        let emptyBoard: Board = Array.init<Array<Cell>>(10, _ => Array.init<Cell>(10, _ => {occupied = false; hit = false}));
        gameState := ?{
            players = [
                {id = 0; principal = player1; board = emptyBoard},
                {id = 1; principal = player2; board = emptyBoard}
            ],
            currentPlayerIndex = 0,
            gameStarted = false
        };
        return true;
    }

    // Place ships on the board
    public func placeShip(player: Principal, shipCells: [(Nat, Nat)]): async Bool {
        assert(gameState != null, "Game not initialized");
        let state = gameState.get();
        let playerIndex = Array.find(state.players, p => Principal.equal(p.principal, player));
        assert(playerIndex != null, "Player not found");
        
        for ((x, y) in shipCells) {
            assert(x < 10 and y < 10, "Invalid ship placement");
            state.players[playerIndex].board[x][y].occupied := true;
        };
        return true;
    }

    // Make a move
    public func makeMove(player: Principal, x: Nat, y: Nat): async Bool {
        assert(gameState != null, "Game not initialized");
        let state = gameState.get();
        let playerIndex = Array.find(state.players, p => Principal.equal(p.principal, player));
        assert(playerIndex != null, "Player not found");
        assert(state.currentPlayerIndex == playerIndex, "Not your turn");
        assert(x < 10 and y < 10, "Invalid move");

        let opponentIndex = 1 - playerIndex;
        let cell = state.players[opponentIndex].board[x][y];
        cell.hit := true;
        let isHit = cell.occupied;

        // Switch turn
        state.currentPlayerIndex := opponentIndex;

        gameState := ?state;
        return isHit;
    }

    // Check if a player has won
    private func checkWinner(): ?Nat {
        let state = gameState.get();
        for (i in [0, 1]) {
            if (Array.all(state.players[i].board, row => Array.all(row, cell => cell.occupied implies cell.hit))) {
                return ?i;
            }
        };
        return null;
    }
}
