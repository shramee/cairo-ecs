%lang starknet
from starkware.starknet.common.syscalls import get_contract_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_not_zero)
from starkware.cairo.common.alloc import (alloc)


from src.ecs.engine import (
    // Storage
    contracts, contracts_count,
    // Utils
    save_arr_to_storage
    //
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