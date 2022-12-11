// This is a boilerplate for an ECS component contract
// A component is just a custom data type for entity.
// This contract acts as a db to store all entities
// and their data for this component.

%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address
// Start editing your component struct

const COMPONENT_NAME = 'Location'; // Name for your component

// Don't change the struct name
struct Component_Struct {
    // Define your struct
    x: felt,
    y: felt,
}

// That's it, no need to touch the code beyond this line.

// Holds entity component
@storage_var
func entity_data(
    contract_addr: felt,
    game_id: felt,
    entity_id: felt,
) -> (res: (exists: felt, data: Component_Struct)) {
}

// For querying entities
@storage_var
func entity_arr(
    contract_addr: felt,
    game_id: felt,
    index: felt,
) -> (entity_id: felt) {
}

// Array count for looping
@storage_var
func entity_count(
    contract_addr: felt,
    game_id: felt,
) -> (entity_count: felt) {
}

@view
func info() -> (name: felt, dataSize: felt) {
    return (
        COMPONENT_NAME,
        Component_Struct.SIZE
    );
}

// Adds the component for entity
@external
func add{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_id: felt, entity_id: felt, data: Component_Struct
) {
    let (contract_address) = get_contract_address();

    // Get index settings
    let (res) = entity_data.read( contract_address, game_id, entity_id );

    with_attr error_message("Entity {entity_id} already exists in game {game_id}.") {
        assert res[0] = 0;
    }

    // Get index and set entity ID to array
    let (index) = entity_count.read( contract_address, game_id );
    entity_arr.write( contract_address, game_id, index, entity_id );
    // Update count
    entity_count.write( contract_address, game_id, index + 1 );

    // Add component data for entity
    entity_data.write( contract_address, game_id, entity_id, (exists=1, data=data) );

    return();
}

// Adds the component for entity
@external
func update{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_id: felt, entity_id: felt, data: Component_Struct
) {
    let (contract_address) = get_contract_address();

    // Get index settings
    let (res) = entity_data.read( contract_address, game_id, entity_id );

    with_attr error_message("Entity {entity_id} doesn't exists in game {game_id}.") {
        assert res[0] = 1;
    }

    entity_data.write( contract_address, game_id, entity_id, (1, data) );

    return();
}

