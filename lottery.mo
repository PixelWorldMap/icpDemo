import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Random "mo:base/Random";

actor Lottery {
    type Participant = {
        id: Nat;
        address: Principal;
    };

    // List of participants
    var participants: [Participant] = [];

    // The principal of the lottery manager
    let manager: Principal = Principal.fromActor(this);

    // Add a participant to the lottery
    public func enterLottery(participantId: Nat) : async Bool {
        if (not(Array.exists(participants, func(p) { p.id == participantId }))) {
            participants := participants.append([{
                id = participantId,
                address = await ic.caller()
            }]);
            return true;
        };
        return false;
    };

    // Select a random winner
    public func drawWinner() : async ?Participant {
        assert(Principal.equal(await ic.caller(), manager));
        if (participants.size() > 0) {
            let randomIndex = Random.nat(Nat.fromNat32(participants.size()));
            return ?participants[randomIndex];
        };
        return null;
    };
}
