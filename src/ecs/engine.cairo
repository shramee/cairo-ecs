// This is a boilerplate for an ECS world manager contract
// This contract includes contract addresses of components
// and systems.
// Setup systems are called when a new game is started,
// other (run) systems are called as game runs.


%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (get_caller_address)

// Holds contract addresses in an array
// type can be component, setup_system or system
@storage_var
func contracts( type: felt, index: felt ) -> (addr: felt) {
}

// Holds contracts count for looping
@storage_var
func contracts_count( type: felt ) -> (count: felt) {
}

// World internal metadata
@storage_var
func metadata( name: felt ) -> (addr: felt) {
}


// Expects 3 arrays of contract addresses
// for components, setup systems and (run) systems.
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}( owner: felt ) {
    metadata.write( 'owner', owner );
    return ();
}

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

@external
func register_components{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    component_len: felt, component: felt*
) {
    let (caller) = get_caller_address();
    let (owner_addr) = metadata.read( 'owner' );
    assert caller = owner_addr;
    save_arr_to_storage( 'components', component_len, component);
    return ();
}

@external
func register_setup_systems{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    setup_system_len: felt, setup_system: felt*
) {
    // @TODO Send registered components to system contract
    // So it can verify that world has required components
    let (caller) = get_caller_address();
    let (owner_addr) = metadata.read( 'owner' );
    assert caller = owner_addr;
    save_arr_to_storage( 'setup_systems', setup_system_len, setup_system);
    return ();
}

@external
func register_systems{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    system_len: felt, system: felt*
) {
    // @TODO Send registered components to system contract
    // So it can verify that world has required components
    let (caller) = get_caller_address();
    let (owner_addr) = metadata.read( 'owner' );
    assert caller = owner_addr;
    save_arr_to_storage( 'systems', system_len, system);
    return ();
}
// }