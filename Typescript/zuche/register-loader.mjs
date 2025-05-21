// register-loader.mjs
import { register } from "node:module";
import { pathToFileURL } from "node:url";

// This replaces `--loader ts-node/esm`
register("ts-node/esm", pathToFileURL("./"));
