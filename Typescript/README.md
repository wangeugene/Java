# TypeScript General Manual
## Common Prerequisite Set up
### Description
Typescript uses file extension: `ts`;

It `translates and compiles` (can be shorten as `transpile`, a jargon ) .ts files to .js files either in memory (`ts-node`) or in files ("to the compiled files folder")

### Setup runtime environment

```zsh
touch tsconfig.json # create configuration file
pnpm add -g typescript # install typescript compiler globally, the core of Typescript
pnpm add -g ts-node # install Just-in-time compiler globally, used to directly run ts file for testing
tsc -w # transpile and watch the runtime execution
ts-node <file-name>.ts # example syntax to run the Typescript file instantly

tsc --project . 
tsc -p . # for short
#tells the TypeScript compiler to:
# 1. Look for a `tsconfig.json` file in the current directory (`.`)
# 2. Read the compiler options and file specifications from that config
# 3. Compile all TypeScript files according to those settings
# This is the recommended way to compile TypeScript projects since it ensures consistent compiler options across your codebase.
# You should run the tsc --project command in the directory where your tsconfig.json file is located. In your case, it seems to be the Typescript directory.
```


## Syntax Introduction

### variable declaration and initialization

```typescript
let trackingNumber = "FD123455";
let createDate = new Date();
let originalCost = 425;
```

### interface declaration and intialization

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

### method declaration

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

