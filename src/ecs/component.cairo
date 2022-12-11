// This is a boilerplate for an ECS component contract
// A component is just a custom data type for entity.
// This contract acts as a db to store all entities
// and their data for this component.

%lang starknet

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
) -> (data: Component_Struct) {
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
