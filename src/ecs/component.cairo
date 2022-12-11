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

@view
func info() -> (name: felt, dataSize: felt) {
    return (
        COMPONENT_NAME,
        Component_Struct.SIZE
    );
}
