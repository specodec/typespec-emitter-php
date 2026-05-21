import { describe, it, expect } from 'vitest';
import { mkScalar, mkArray } from '@specodec/typespec-emitter-core/test-utils';
import { typeToPhp, readExpr, writeExpr, writeLines, defaultValue } from './index.js';

describe('typeToPhp', () => {
  it('string → string', () => expect(typeToPhp(mkScalar('string') as any)).toBe('string'));
  it('boolean → bool', () => expect(typeToPhp(mkScalar('boolean') as any)).toBe('bool'));
  it('int32 → int', () => expect(typeToPhp(mkScalar('int32') as any)).toBe('int'));
  it('int64 → string', () => expect(typeToPhp(mkScalar('int64') as any)).toBe('string'));
  it('float32 → float', () => expect(typeToPhp(mkScalar('float32') as any)).toBe('float'));
  it('float64 → float', () => expect(typeToPhp(mkScalar('float64') as any)).toBe('float'));
  it('bytes → string', () => expect(typeToPhp(mkScalar('bytes') as any)).toBe('string'));
  it('model → model name', () => expect(typeToPhp({ kind: 'Model', name: 'User' } as any)).toBe('User'));
});

describe('readExpr', () => {
  it('int32', () => expect(readExpr(mkScalar('int32') as any)).toContain('read_int32'));
  it('string', () => expect(readExpr(mkScalar('string') as any)).toContain('read_string'));
  it('bool', () => expect(readExpr(mkScalar('boolean') as any)).toContain('read_bool'));
  it('float32', () => expect(readExpr(mkScalar('float32') as any)).toContain('read_float32'));
  it('bytes', () => expect(readExpr(mkScalar('bytes') as any)).toContain('read_bytes'));
});
