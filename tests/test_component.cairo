%lang starknet
from starkware.starknet.common.syscalls import get_contract_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_not_zero)

from src.ecs.component import (
    Component_Struct,
    info,
    entity_count, entity_data, entity_arr,
    add,
    update,
)

@external
func __setup__{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() {
    // balance.write(10);
    return ();
}

@external
func test_info{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    let (name, size) = info();
    assert_not_zero( name );
    assert_not_zero( size );
    return ();
}

@external
func test_add{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let (contract_address) = get_contract_address();

    let (count) = entity_count.read( contract_address, 'game0' );
    assert count = 0;

    add( 'game0', 'cube', Component_Struct(232, 412) );

    let (count) = entity_count.read( contract_address, 'game0' );
    assert count = 1;

     return();
}

@external
func test_add_duplicate_entity{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let (contract_address) = get_contract_address();
    add( 'game0', 'cube', Component_Struct(40, 52) );

    %{ expect_revert(error_message="already exists") %}
    add( 'game0', 'cube', Component_Struct(23, 25) );

    return();
}


@external
func test_update{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let (contract_address) = get_contract_address();
    add( 'game0', 'cube', Component_Struct(232, 412) );

    let (res) = entity_data.read( contract_address, 'game0', 'cube' );
    assert res[1].x = 232;

    update( 'game0', 'cube', Component_Struct(23, 25) );

    let (res) = entity_data.read( contract_address, 'game0', 'cube' );
    assert res[1].x = 23;

     return();
}

@external
func test_update_inexisting_entity{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    %{ expect_revert(error_message="doesn't exists") %}
    update( 'game0', 'inexistent_cube', Component_Struct(23, 25) );

    return();
}