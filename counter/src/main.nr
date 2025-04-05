// contract Main {
//     fn double(x: Field) -> pub Field { x * 2 }
//     fn triple(x: Field) -> pub Field { x * 3 }
//     fn quadruple(x: Field) -> pub Field { double(double(x)) }
// }


use dep::aztec::macros::aztec;
use aztec::macros::{functions::{initializer, private}, storage::storage};
use aztec::prelude::{AztecAddress, Map};
use aztec::protocol_types::traits::{FromField, ToField};
use easy_private_state::EasyPrivateUint;
use value_note::{balance_utils, value_note::ValueNote};

#[aztec]
pub contract Counter {

#[storage]
 struct Storage<Context> {
    counters: Map<AztecAddress, EasyPrivateUint<Context>, Context>,
 }

    #[initializer]
    fn initializer(headstart: u64, owner; AztecAddress) {
        let counters = storage.counters;
        counters.at(owner).add(headstart, owner, context.msg_sender());
    }

    #[private]
    fn increment(owner: AztecAddress, sender: AztecAddress) {
        unsafe {
            dep::aztec::oracle::debug_log::debug_log_fornmat(
                "incrementing counter for owner {0}",
                [owner.to_field()]         
            )
        }
        let counters = storage.counters;
        counters.at(owner).add(1, owner, sender);
    }

    unconstrained fn get_counter(owner: AztecAddress) -> pub Field { 
        let counters = storage.counters;
        balance_utils::get_balance(counters.at(owner).set)
    }
}