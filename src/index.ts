import { type EmitContext, emitFile, type Enum, type Model, type Type, type Union } from "@typespec/compiler";
import {
  collectServices,
  type BaseEmitterOptions,
  type EnumInfo,
  type EnumMemberInfo,
  type UnionInfo,
  type UnionVariantInfo,
  extractFields,
  scalarName,
  isArrayType,
  isRecordType,
  isUnionType,
  isScalarVariant,
  arrayElementType,
  recordElementType,
  toSnakeCase,
  dottedPathToSnakeCase,
  checkAndReportReservedKeywords,
  safeFieldName,
} from "@specodec/typespec-emitter-core";

export type EmitterOptions = BaseEmitterOptions;

function fieldPhp(name: string): string {
  return toSnakeCase(name); // safeFieldName("php", ...) when emitter-core supports it
}

function typeToPhp(type: Type, optional: boolean = false): string {
  const n = scalarName(type);
  if (n === "string") return optional ? "?string" : "string";
  if (n === "boolean") return optional ? "?bool" : "bool";
  if (["int8", "int16", "int32", "uint8", "uint16", "uint32", "integer"].includes(n))
    return optional ? "?int" : "int";
  if (["int64", "uint64"].includes(n))
    return "?\\GMP"; // Always nullable since PHP can't use gmp_init() as const default
  if (["float32", "float64", "float", "decimal"].includes(n))
    return optional ? "?float" : "float";
  if (n === "bytes") return optional ? "?string" : "string"; // PHP strings are binary-safe
  if (type.kind === "Enum") return optional ? "?string" : "string";
  if (isArrayType(type)) return optional ? "?array" : "array";
  if (isRecordType(type)) return optional ? "?array" : "array";
  if (type.kind === "Model" && (type as Model).name)
    return optional ? `?${(type as Model).name}` : (type as Model).name;
  if (type.kind === "Union")
    return "mixed"; // PHP can't represent tagged unions as types
  return "mixed";
}

function phpDefault(type: Type): string {
  const n = scalarName(type);
  if (n === "boolean") return "false";
  if (["int8", "int16", "int32", "uint8", "uint16", "uint32", "integer"].includes(n)) return "0";
  if (["int64", "uint64"].includes(n)) return "null";
  if (["float32", "float64", "float", "decimal"].includes(n)) return "0.0";
  if (n === "string" || n === "bytes") return "''";
  if (type.kind === "Enum") return "''";
  if (isArrayType(type)) return "[]";
  if (isRecordType(type)) return "[]";
  if (type.kind === "Model" || type.kind === "Union") return "null";
  return "null";
}

function writeLines(type: Type, varExpr: string, indent: string): string[] {
  const n = scalarName(type);
  if (n === "string") return [`${indent}$w->write_string(${varExpr});`];
  if (n === "boolean") return [`${indent}$w->write_bool(${varExpr});`];
  if (["int8", "int16", "int32", "integer"].includes(n)) return [`${indent}$w->write_int32((int)${varExpr});`];
  if (n === "int64") return [`${indent}$w->write_int64(${varExpr});`];
  if (["uint8", "uint16", "uint32"].includes(n)) return [`${indent}$w->write_uint32((int)${varExpr});`];
  if (n === "uint64") return [`${indent}$w->write_uint64(${varExpr});`];
  if (n === "float32") return [`${indent}$w->write_float32((float)${varExpr});`];
  if (["float64", "float", "decimal"].includes(n)) return [`${indent}$w->write_float64((float)${varExpr});`];
  if (n === "bytes") return [`${indent}$w->write_bytes(${varExpr});`];
  if (isArrayType(type)) {
    const elem = arrayElementType(type)!;
    return [
      `${indent}$w->begin_array(count(${varExpr}));`,
      `${indent}foreach (${varExpr} as $item) {`,
      `${indent}    $w->next_element();`,
      ...writeLines(elem, "$item", `${indent}    `),
      `${indent}}`,
      `${indent}$w->end_array();`,
    ];
  }
  if (isRecordType(type)) {
    const elem = recordElementType(type)!;
    return [
      `${indent}$w->begin_object(count(${varExpr}));`,
      `${indent}foreach (${varExpr} as $key => $val) {`,
      `${indent}    $w->write_field($key);`,
      ...writeLines(elem, "$val", `${indent}    `),
      `${indent}}`,
      `${indent}$w->end_object();`,
    ];
  }
  if (type.kind === "Enum")
    return [`${indent}$w->write_string(${varExpr});`];
  if (type.kind === "Model" && (type as Model).name)
    return [`${indent}write_${toSnakeCase((type as Model).name)}($w, ${varExpr});`];
  if (type.kind === "Union")
    return [`${indent}write_${toSnakeCase((type as Union).name!)}($w, ${varExpr});`];
  return [`${indent}$w->write_string((string)${varExpr});`];
}

function readExpr(type: Type, optional?: boolean): string {
  const n = scalarName(type);
  if (n === "string") return "$r->read_string()";
  if (n === "boolean") return "$r->read_bool()";
  if (["int8", "int16", "int32", "integer"].includes(n)) return "$r->read_int32()";
  if (n === "int64") return "$r->read_int64()";
  if (["uint8", "uint16", "uint32"].includes(n)) return "$r->read_uint32()";
  if (n === "uint64") return "$r->read_uint64()";
  if (n === "float32") return "$r->read_float32()";
  if (["float64", "float", "decimal"].includes(n)) return "$r->read_float64()";
  if (n === "bytes") return "$r->read_bytes()";
  if (isArrayType(type)) {
    const elem = arrayElementType(type)!;
    const readE = readExpr(elem);
    const expr = `(function($r) { $arr = []; $r->begin_array(); while ($r->has_next_element()) { $arr[] = ${readE}; } $r->end_array(); return $arr; })($r)`;
    if (optional) return `$r->is_null() ? $r->read_null() : ${expr}`;
    return expr;
  }
  if (isRecordType(type)) {
    const elem = recordElementType(type)!;
    const readE = readExpr(elem);
    const expr = `(function($r) { $map = []; $r->begin_object(); while ($r->has_next_field()) { $key = $r->read_field_name(); $map[$key] = ${readE}; } $r->end_object(); return $map; })($r)`;
    if (optional) return `$r->is_null() ? $r->read_null() : ${expr}`;
    return expr;
  }
  if (type.kind === "Enum") return "$r->read_string()";
  if (type.kind === "Model" && (type as Model).name) {
    const sn = toSnakeCase((type as Model).name);
    if (optional) return `$r->is_null() ? $r->read_null() : decode_${sn}($r)`;
    return `decode_${sn}($r)`;
  }
  if (type.kind === "Union") {
    const sn = toSnakeCase((type as Union).name!);
    if (optional) return `$r->is_null() ? $r->read_null() : decode_${sn}($r)`;
    return `decode_${sn}($r)`;
  }
  return "$r->read_string()";
}

function emitModelFunctions(m: Model, L: string[]): void {
  if (!m.name) return;
  const fields = extractFields(m);
  const required = fields.filter((f) => !f.optional);
  const optional = fields.filter((f) => f.optional);
  const sn = toSnakeCase(m.name);

  // Encode
  L.push(`function write_${sn}(SpecWriter $w, mixed $obj): void {`);
  if (optional.length === 0) {
    L.push(`    $w->begin_object(${fields.length});`);
  } else {
    L.push(`    $count = ${required.length};`);
    for (const f of optional) L.push(`    if ($obj->${fieldPhp(f.name)} !== null) $count++;`);
    L.push(`    $w->begin_object($count);`);
  }
  for (const f of fields) {
    const fPhp = fieldPhp(f.name);
    if (f.optional) {
      L.push(`    if ($obj->${fPhp} !== null) {`);
      L.push(`        $w->write_field("${f.name}");`);
      for (const line of writeLines(f.type, `$obj->${fPhp}`, "        ")) L.push(line);
      L.push(`    }`);
    } else {
      L.push(`    $w->write_field("${f.name}");`);
      for (const line of writeLines(f.type, `$obj->${fPhp}`, "    ")) L.push(line);
    }
  }
  L.push(`    $w->end_object();`);
  L.push(`}`);
  L.push("");

  // Decode
  L.push(`function decode_${sn}(SpecReader $r): mixed {`);
  L.push(`    $r->begin_object();`);
  L.push(`    $obj = new ${m.name}();`);
  L.push(`    while ($r->has_next_field()) {`);
  L.push(`        $key = $r->read_field_name();`);
  for (const f of fields) {
    const fPhp = fieldPhp(f.name);
    L.push(`        if ($key === "${f.name}") { $obj->${fPhp} = ${readExpr(f.type, f.optional)}; continue; }`);
  }
  L.push(`        $r->skip();`);
  L.push(`    }`);
  L.push(`    $r->end_object();`);
  L.push(`    return $obj;`);
  L.push(`}`);
  L.push("");
}

function generateEnumCode(e: EnumInfo): string[] {
  const lines: string[] = [];
  lines.push(`enum ${e.name}: int {`);
  for (const m of e.members) lines.push(`    case ${m.name} = ${m.value};`);
  lines.push(`}`);
  return lines;
}

function generateUnionCode(u: UnionInfo, L: string[]): void {
  const snakeName = toSnakeCase(u.name);
  const undefCls = `${u.name}Undefined`;

  for (const v of u.variants) {
    const pascal = v.name.charAt(0).toUpperCase() + v.name.slice(1);
    const wrapper = `${u.name}${pascal}`;
    L.push(`class ${wrapper} {`);
    L.push(`    public function __construct(public mixed $value) {}`);
    L.push(`}`);
    L.push("");
  }

  L.push(`class ${undefCls} {`);
  L.push(`    public function __construct(public ?SpecUndefined $value = null) {}`);
  L.push(`}`);
  L.push("");

  // Encode
  L.push(`function write_${snakeName}(SpecWriter $w, mixed $obj): void {`);
  L.push(`    $w->begin_object(1);`);
  for (let i = 0; i < u.variants.length; i++) {
    const v = u.variants[i];
    const pascal = v.name.charAt(0).toUpperCase() + v.name.slice(1);
    const wrapper = `${u.name}${pascal}`;
    const stmts = writeLines(v.type, "$obj->value", "    ").join(" ");
    L.push(`    ${i === 0 ? "if" : "elseif"} ($obj instanceof ${wrapper}) { $w->write_field("${v.name}"); ${stmts} }`);
  }
  L.push(`    else { throw new \\RuntimeException("cannot encode Undefined"); }`);
  L.push(`    $w->end_object();`);
  L.push(`}`);
  L.push("");

  // Decode
  L.push(`function decode_${snakeName}(SpecReader $r): mixed {`);
  L.push(`    $r->begin_object();`);
  L.push(`    $result = new ${undefCls}();`);
  L.push(`    if ($r->has_next_field()) {`);
  L.push(`        $field = $r->read_field_name();`);
  for (let i = 0; i < u.variants.length; i++) {
    const v = u.variants[i];
    const pascal = v.name.charAt(0).toUpperCase() + v.name.slice(1);
    const wrapper = `${u.name}${pascal}`;
    L.push(`        ${i === 0 ? "if" : "elseif"} ($field === "${v.name}") { $result = new ${wrapper}(${readExpr(v.type)}); }`);
  }
  L.push(`    }`);
  L.push(`    while ($r->has_next_field()) { $r->read_field_name(); $r->skip(); }`);
  L.push(`    $r->end_object();`);
  L.push(`    return $result;`);
  L.push(`}`);
  L.push("");
}

export async function $onEmit(context: EmitContext<EmitterOptions>) {
  const program = context.program;
  const outputDir = context.emitterOutputDir;
  const ignoreReservedKeywords = context.options["ignore-reserved-keywords"] ?? false;
  const services = collectServices(program);

  if (checkAndReportReservedKeywords(program, services, ignoreReservedKeywords)) return;

  const phpModelNs = new Map<string, string>();
  for (const s of services) {
    for (const m of s.models) { if (m.name) phpModelNs.set(m.name, s.serviceName); }
    for (const e of s.enums) { if (e.name) phpModelNs.set(e.name, s.serviceName); }
    for (const u of s.unions) { if (u.name) phpModelNs.set(u.name, s.serviceName); }
  }

  for (const svc of services) {
    const L: string[] = [];
    L.push("<?php");
    L.push("");
    L.push("declare(strict_types=1);");
    L.push("");
    L.push("// Generated by @specodec/typespec-emitter-php. DO NOT EDIT.");
    L.push("");
    L.push("require_once __DIR__ . '/../../vendor/autoload.php';");

    // Cross-namespace imports
    const xrefNs = new Set<string>();
    for (const m of svc.models) {
      if (!m.name) continue;
      for (const f of extractFields(m)) {
        const collectX = (t: Type) => {
          if ((t.kind === "Model" || t.kind === "Enum") && (t as any).name) {
            const ns = phpModelNs.get((t as any).name);
            if (ns && ns !== svc.serviceName) xrefNs.add(ns);
          }
          if (isArrayType(t)) collectX(arrayElementType(t)!);
          if (isRecordType(t)) collectX(recordElementType(t)!);
        };
        collectX(f.type);
      }
    }
    for (const u of svc.unions) {
      for (const v of u.variants) {
        const collectX = (t: Type) => {
          if ((t.kind === "Model" || t.kind === "Enum") && (t as any).name) {
            const ns = phpModelNs.get((t as any).name);
            if (ns && ns !== svc.serviceName) xrefNs.add(ns);
          }
          if (isArrayType(t)) collectX(arrayElementType(t)!);
          if (isRecordType(t)) collectX(recordElementType(t)!);
        };
        collectX(v.type);
      }
    }
    for (const ns of [...xrefNs].sort()) {
      L.push(`require_once __DIR__ . '/${dottedPathToSnakeCase(ns)}_types.php';`);
    }

    L.push("");

    // Models
    for (const m of svc.models) {
      if (!m.name) continue;
      const fields = extractFields(m);
      L.push(`class ${m.name} {`);
      if (fields.length > 0) {
        L.push(`    public function __construct(`);
        const params: string[] = [];
        for (const f of fields) {
          const fPhp = fieldPhp(f.name);
          const defaultVal = f.optional ? 'null' : phpDefault(f.type);
          const needNullable = defaultVal === 'null';
          const type = typeToPhp(f.type, f.optional || needNullable);
          const def = ` = ${defaultVal}`;
          params.push(`        public ${type} $${fPhp}${def}`);
        }
        L.push(params.join(",\n"));
        L.push(`    ) {}`);
      }
      L.push(`}`);
      L.push("");
    }

    for (const e of svc.enums) { L.push(...generateEnumCode(e)); L.push(""); }
    for (const u of svc.unions) generateUnionCode(u, L);
    for (const m of svc.models) emitModelFunctions(m, L);

    // Codecs
    for (const m of svc.models) {
      if (!m.name) continue;
      const sn = toSnakeCase(m.name);
      L.push(`$GLOBALS['${m.name}Codec'] = new SpecCodec(`);
      L.push(`    encode: 'write_${sn}',`);
      L.push(`    decode: 'decode_${sn}',`);
      L.push(`);`);
      L.push("");
    }

    for (const u of svc.unions) {
      if (!u.name) continue;
      const sn = toSnakeCase(u.name);
      L.push(`$GLOBALS['${u.name}Codec'] = new SpecCodec(`);
      L.push(`    encode: 'write_${sn}',`);
      L.push(`    decode: 'decode_${sn}',`);
      L.push(`);`);
      L.push("");
    }

    const fileName = `${dottedPathToSnakeCase(svc.serviceName)}_types.php`;
    await emitFile(program, { path: `${outputDir}/${fileName}`, content: L.join("\n") });
  }

  let barrelContent = "<?php\n\ndeclare(strict_types=1);\n\n// Generated by @specodec/typespec-emitter-php. DO NOT EDIT.\n\n";
  barrelContent += "require_once __DIR__ . '/../../vendor/autoload.php';\n\n";
  for (const svc of services) {
    barrelContent += `require_once __DIR__ . '/${dottedPathToSnakeCase(svc.serviceName)}_types.php';\n`;
  }
  await emitFile(program, { path: `${outputDir}/all_types.php`, content: barrelContent });
}
