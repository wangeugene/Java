file extension: .ts
set up and transpile .ts files to .js files

```zsh
touch tsconfig.json
npm install -g typescript # or 
pnpm add -g typescript

# tsc = TypeScript Compiler, -w = Watch changes, will compile the .ts files into .js files instant after save
tsc -w # no argument

```

variables declaration:

```typescript
let trackingNumber = "FD123455";
let createDate = new Date();
let originalCost = 425;
```

interface declaration:

```typescript
interface interface_name {
    field_1: string;
    field_2: Date;
    field_3: number;
    field_4?: number;

    method_1(para: string): string;

    method_2: (para2: string) => string;
    method_3?: (para2: string) => string;
}
```

method declaration:

```typescript
function getInventoryItem(trackingNumber: string): {
    displayName: string
    inventoryType: string
    createDate: Date
    originalCost: number
} {
    return null
}
```

```zsh
pnpm add -g ts-node
```

```zsh
ts-node camelcase_to_snakecase.ts
```