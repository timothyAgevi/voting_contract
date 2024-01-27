#[starknet::interface]
trait IVote<TContractState> {
    fn vote(ref self: TContractState);
    fn get_votes(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod Vote {
    use core::starknet::event::EventEmitter;
    use core::traits::Into;
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        votes: felt252,
        voters: LegacyMap<ContractAddress, bool>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Voted: Voted
    }

    #[derive(Drop, starknet::Event)]
    struct Voted {
        // #[key]
        voter: ContractAddress
    }

    #[abi(embed_v0)]
    #[external(v0)]
    impl VoteImpl of super::IVote<ContractState> {
        fn vote(ref self: ContractState) {
            let has_voted = self.voters.read(get_caller_address());
            assert(self.voters.read(get_caller_address()) == false, 'You have already voted');
            self.votes.write(self.votes.read() + 1);
            self.voters.write(get_caller_address(), true);
            self.emit(Voted { voter: get_caller_address() });
        }

        fn get_votes(self: @ContractState) -> felt252 {
            self.votes.read()
        }
    }
}
