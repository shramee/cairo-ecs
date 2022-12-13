%lang starknet
from starkware.starknet.common.syscalls import (get_contract_address, get_caller_address)
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_not_zero)
from starkware.cairo.common.alloc import (alloc)


from src.ecs.engine import (
    // Storage
    contracts, contracts_count,
    // Utils
    save_arr_to_storage,
    // Registering
    register_components, register_setup_systems, register_systems,
)

@external
func test_save_arr_to_storage{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (ptr) = alloc();
    let (count) = contracts_count.read( 'test' );
    assert count = 0;
    assert [ptr] = 1234;
    assert [ptr + 1] = 2345;
    assert [ptr + 2] = 3456;
    save_arr_to_storage( 'test', 3, ptr );
    let (count) = contracts_count.read( 'test' );
    assert count = 3;

    let (third_contract) = contracts.read( 'test', 2 );
    assert third_contract = [ptr + 2];
    return ();
}

func list_to_array( i1: felt,i2: felt,i3: felt, ) -> felt* {
    let (ptr) = alloc();
    assert [ptr] = i1;
    assert [ptr + 1] = i2;
    assert [ptr + 2] = i3;
    return ptr;
}

@external
func test_registering{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    
    //'components'
    register_components( 2, list_to_array( 0xc01, 0xc02, 0 ) );
    //'setup_systems'
    register_setup_systems( 2, list_to_array( 0x531, 0x532, 0 ) );
    //'systems'
    register_systems( 2, list_to_array( 0x541, 0x542, 0 ) );

    return();
}


@contract_interface
namespace ITestContract {
    func get_felt() -> (res: felt) {
    }
}

const EXTERNAL_CONTRACT_ADDRESS = 0xf007ba11;

@external
func test_mock_call_returning_felt{syscall_ptr: felt*, range_check_ptr}() {
    tempvar external_contract_address = EXTERNAL_CONTRACT_ADDRESS;

    %{ stop_mock = mock_call(ids.external_contract_address, "get_felt", [42]) %}
    let (res) = ITestContract.get_felt(EXTERNAL_CONTRACT_ADDRESS);
    %{ stop_mock() %}

    assert res = 42;
    return ();
}

// @external
// func test_composability{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
//     let (addr) = get_contract_address();
//     let (callr) = get_caller_address();
//     // assert addr = callr;

//     return ();
// }