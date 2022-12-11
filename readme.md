#### On-chain gaming in Cairo

# Entity Component System

## Overview

### Design decisions

1. Component contracts can be reused without redeploying.
2. System contracts can be reused without redeploying.
3. World takes array of component and system contracts in constructor.
4. Have ABIs reflect the correct data type. At least for `components` and `systems`.
5. World contract is just orchestrating stuff, hold no data and no logic.
6. World spawns entities and maybe has some logic for that.

### Implmentation guide

1. Start with components your game needs. Get contract addresses of all components you need to use, deploy new ones by adding to component struct in `./component.cairo`.
2. Now find systems that'd work for your game, you can write new ones if needed using `./system.cairo`.
3. For game contract, use `./world.cairo` as starter. Try to keep the structure, and add functions as needed.

## Under the hood

### Component

- A component is a data type with context for an entity.
- Holds the specific data type for every entity that needs it across all worlds and games.
- For example,
  - `Location` component using struct `{x,y,z}` only ever represents position of an object.
  - `Velocity` component using the same struct `{x,y,z}` only refers to the velocity.
  - These two are totally different components of an entity.

### System

- A system is a (set of) function(s) providing a tiny isolated piece of functionality.
- System specifies the components it needs to work, only entities have all those components are processed.
- The constructor receives an array of component addresses it needs.
- ✅ Safety check function recieves an array of all components in the world and checks everything this system needs is included in the world.
- For example,
  - `random_move` sytem might require `Location` and `Random_Speed` components and might add random values to `x` and `y` of `Location` based on `Random_Speed`.

### World

- World is identified by the managing contract address and `game_instance_id` to have same game contract managing multiple worlds (instances of games).
- World is managed by Game contract.

### Game contract

- Constructor receives and saves two arrays,
  - one containing component contract addresses and,
  - the second for system contract addresses.
- Constructor passes
- Handles initiating the world which might invole creating player entities and spawning NPC entities.
- :warning: Needs a dynamic `Input` component created/managed by middleware.
