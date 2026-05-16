import type { DecoratorContext, Model, Enum, Union } from "@typespec/compiler";
import { codecKey } from "./state.js";

export const namespace = "Specodec";

export function $codec(context: DecoratorContext, target: Model | Enum | Union): void {
  context.program.stateSet(codecKey).add(target);
}
