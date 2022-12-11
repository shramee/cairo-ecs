%lang starknet
from src.ecs.component import info
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_not_zero, assert_not_equal)

@external
func test_info{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    let (name, size) = info();
    assert_not_zero( name );
    assert_not_zero( size );
    return ();
}
