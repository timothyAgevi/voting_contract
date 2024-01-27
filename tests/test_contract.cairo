use core::result::ResultTrait;
use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait};

use voting_contract::IVoteSafeDispatcher;
use voting_contract::IVoteSafeDispatcherTrait;

fn deploy_contract(name: felt252) -> ContractAddress {
    let contract = declare(name);
    contract.deploy(@ArrayTrait::new()).unwrap()
}

#[test]
fn test_vote() {
    let contract_address = deploy_contract('Vote');

    let safe_dispatcher = IVoteSafeDispatcher { contract_address };

    safe_dispatcher.vote();
    let votes = safe_dispatcher.get_votes().unwrap();

    assert(votes == 1, 'Invalid balance');
}

#[test]
fn test_double_vote() {
    let contract_address = deploy_contract('Vote');

    let safe_dispatcher = IVoteSafeDispatcher { contract_address };

    safe_dispatcher.vote();
    safe_dispatcher.vote();
    let votes = safe_dispatcher.get_votes().unwrap();

    assert(votes == 1, 'Invalid balance');
}
