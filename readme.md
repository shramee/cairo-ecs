# Entity Component System in Cairo

## Design decisions

1. Component contracts can be reused without redeploying.
2. System contracts can be reused without redeploying.
3. World takes array of component and system contracts in constructor.
4. Avoid `cast`ing, so that ABIs reflect the correct data type. At least for `components` and `systems`.

## Implmentation guide

1. Start with components your game needs. Get contract addresses of all components you need to use, deploy new ones by adding to component struct in `./component.cairo`.
2. Now find systems that'd work for your game, you can write new ones if needed using `./system.cairo`.
3. Start working with the world. Start with `./world.cairo` as starter, try to keep the structure, add functions if really needed.
