import type { Model, Enum, Union, Program } from "@typespec/compiler";

export const codecKey = Symbol.for("specodec:codec");

export function isCodecType(program: Program, type: Model | Enum | Union): boolean {
  return program.stateSet(codecKey).has(type);
}
