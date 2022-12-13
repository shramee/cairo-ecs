// This is a boilerplate for an ECS world manager contract
// This contract includes contract addresses of components
// and systems.
// Setup systems are called when a new game is started,
// other (run) systems are called as game runs.


%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Recursive fn to save individual items from an array to the storage
func _save_arr_to_storage_recurse{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    type: felt, index: felt, item_left: felt, item: felt*
) {
    if ( item_left == 0 ) {
        return ();
    }
    contracts.write( type, index, [item] );
    _save_arr_to_storage_recurse( type, index + 1, item_left - 1, item + 1 );
    return ();
}

// Save items from an array to the storage with index
func save_arr_to_storage{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    type: felt, item_len: felt, item: felt*
) {
    alloc_locals;
    // Get contract count for index
    let ( index ) = contracts_count.read( type );
    // Write contract addresses recursively
    _save_arr_to_storage_recurse( type, index, item_len, item );
    // Update the contracts count
    contracts_count.write( type, index + item_len );
    return ();
}
