import "@specodec/typespec-emitter-core";

using Specodec;

namespace AllTypes {
  @codec
  model Inner {
    x: int32;
    y: int32;
  }

  @codec
  model Coord {
    lat: float64;
    lng: float64;
  }

  @codec
  model IdVal {
    id: string;
    value: int32;
  }

  @codec
  model Label {
    key: string;
    text: string;
  }

  @codec
  model Money {
    amount: int64;
    currency: string;
  }

  @codec
  model Range32 {
    min: int32;
    max: int32;
  }

  @codec
  model Addr {
    street: string;
    city: string;
    zip: string;
  }

  @codec
  model Point3 {
    x: float64;
    y: float64;
    z: float64;
  }

  @codec
  model OptInner {
    name?: string;
    score?: float64;
    tag?: string;
  }

  namespace Arrays {
    @codec
    model ArrString {
      items: string[];
    }

    @codec
    model ArrInt32 {
      items: int32[];
    }

    @codec
    model ArrBoolean {
      items: boolean[];
    }

    @codec
    model ArrFloat64 {
      items: float64[];
    }

    @codec
    model ArrBytes {
      items: bytes[];
    }

    @codec
    model ArrInt64 {
      items: int64[];
    }

    @codec
    model ArrUint64 {
      items: uint64[];
    }

    @codec
    model MultiArr1 {
      names: string[];
      scores: int32[];
    }

    @codec
    model MultiArr2 {
      flags: boolean[];
      values: float64[];
      payload: bytes[];
    }

    @codec
    model MultiArr3 {
      a: string[];
      b: int32[];
      c: float64[];
    }

    @codec
    model MultiArr4 {
      ids: int64[];
      tags: string[];
    }

    @codec
    model MultiArr5 {
      xs: uint64[];
      ys: float32[];
      zs: boolean[];
    }

    @codec
    model OptCombo1 {
      req: string;
      opt_a?: int32;
    }

    @codec
    model OptCombo2 {
      req: string;
      opt_a?: int32;
      opt_b?: boolean;
    }

    @codec
    model OptCombo3 {
      req: string;
      opt_a?: int32;
      opt_b?: boolean;
      opt_c?: float64;
    }

    @codec
    model OptCombo4 {
      req: int32;
      opt_a?: string;
      opt_b?: bytes;
    }

    @codec
    model OptCombo5 {
      req1: string;
      req2: int32;
      opt_a?: boolean;
      opt_b?: float64;
    }

    @codec
    model OptCombo6 {
      req: string;
      opt_s?: string;
      opt_i?: int32;
      opt_f?: float64;
      opt_b?: bytes;
    }

    @codec
    model OptCombo7 {
      req: int64;
      opt_u64?: uint64;
      opt_str?: string;
    }

    @codec
    model OptCombo8 {
      a: string;
      b?: int32;
      c?: float64;
      d?: boolean;
      e?: bytes;
      f?: int64;
    }

    @codec
    model OptCombo9 {
      id: string;
      name?: string;
      age?: int32;
      score?: float64;
    }

    @codec
    model OptCombo10 {
      code: int32;
      msg?: string;
      detail?: string;
      retry?: boolean;
    }

  }
  namespace Edge {
    @codec
    model EdgeEmpty {
    }

    @codec
    model EdgeOneOpt {
      maybe?: string;
    }

    @codec
    model EdgeBigNums {
      i8: int8;
      i16: int16;
      i32: int32;
      i64: int64;
      u8: uint8;
      u16: uint16;
      u32: uint32;
      u64: uint64;
    }

    @codec
    model EdgeZeroVals {
      s: string;
      i: int32;
      f: float64;
      b: boolean;
      by_field: bytes;
    }

    @codec
    model EdgeNullable {
      a?: string;
      b?: int32;
      c?: Inner;
      d?: string[];
    }

    @codec
    model EdgeNegZero {
      v: float64;
    }

    @codec
    model EdgeNullByte {
      s: string;
      b: bytes;
    }

    @codec
    model EdgeBoundary {
      i32_neg129: int32;
      i32_128: int32;
      i32_256: int32;
      i32_65536: int32;
      i32_neg32769: int32;
      u32_65536: uint32;
    }

    @codec
    model EdgeStrLen {
      s31: string;
      s32: string;
      s255: string;
      s256: string;
    }

    @codec
    model EdgeBytesLen {
      b31: bytes;
      b32: bytes;
      b255: bytes;
      b256: bytes;
    }

    @codec
    model EdgeArrEmpty {
      items: string[];
    }

    @codec
    model EdgeArrBoundary {
      a15: int32[];
      a16: int32[];
    }

  }
  namespace Enums {
    @codec
    enum Color {
      Red,
      Green,
      Blue,
    }

    @codec
    enum Priority {
      Low,
      Medium,
      High,
      Critical,
    }

    @codec
    enum Status {
      Active,
      Inactive,
      Pending,
      Archived,
    }

    @codec
    model EnumHolder {
      color: Color;
      priority: Priority;
      status: Status;
    }

    @codec
    model OptEnumHolder {
      color?: Color;
      priority?: Priority;
    }

    @codec
    model EnumArrayHolder {
      colors: Color[];
    }

    @codec
    model EnumMixedHolder {
      status: Status;
      name: string;
      count: int32;
      active: boolean;
    }

  }
  namespace Extra {
    @codec
    model OptArr1 {
      req: string;
      items?: int32[];
    }

    @codec
    model OptArr2 {
      id: int32;
      names?: string[];
      flags?: boolean[];
    }

    @codec
    model OptArr3 {
      a?: string[];
      b?: float64[];
    }

    @codec
    model OptArr4 {
      payload: bytes;
      chunks?: bytes[];
    }

    @codec
    model OptArr5 {
      models?: Inner[];
      name: string;
    }

    @codec
    model NestOpt1 {
      outer: Label;
      name: string;
    }

    @codec
    model NestOpt2 {
      a?: IdVal;
      b?: IdVal;
      c?: IdVal;
    }

    @codec
    model NestOpt3 {
      money: Money;
      value_range?: Range32;
    }

    @codec
    model NestOpt4 {
      addr?: Addr;
      coord?: Coord;
      name: string;
    }

    @codec
    model NestOpt5 {
      point: Point3;
      addr: Addr;
      label?: Label;
    }

    @codec
    model NestOptInner1 {
      tag: string;
      nested?: OptInner;
    }

    @codec
    model NestOptInner2 {
      tag: string;
      nested: OptInner;
    }

    @codec
    model NestOptInner3 {
      outer?: OptInner;
      nested?: OptInner;
    }

    @codec
    model DeepNest1 {
      label: string;
      nested: Addr;
    }

    @codec
    model DeepNest2 {
      name: string;
      money: Money;
      addr: Addr;
    }

    @codec
    model DeepNest3 {
      title: string;
      point: Point3;
      value_range: Range32;
      money: Money;
    }

    @codec
    model DeepNest4 {
      coords: Coord[];
      nested: Inner;
      tag: string;
    }

    @codec
    model DeepNest5 {
      labels: Label[];
      money: Money;
      name: string;
    }

    @codec
    model DeepNest6 {
      items: IdVal[];
      addr?: Addr;
      coord: Coord;
    }

    @codec
    model DeepNest7 {
      a: Addr;
      b: Addr;
      c: Addr;
    }

    @codec
    model TimestampEntry {
      ts: int64;
      event: string;
      payload?: bytes;
    }

    @codec
    model ConfigEntry {
      key: string;
      intValue?: int32;
      strValue?: string;
      boolValue?: boolean;
      floatValue?: float64;
    }

  }
  namespace Many {
    @codec
    model Five01 {
      f1: string;
      f2: int32;
      f3: boolean;
      f4: float64;
      f5: bytes;
    }

    @codec
    model Five02 {
      f1: int32;
      f2: int32;
      f3: int32;
      f4: int32;
      f5: int32;
    }

    @codec
    model Five03 {
      f1: string;
      f2: string;
      f3: string;
      f4: string;
      f5: string;
    }

    @codec
    model Five04 {
      f1: float64;
      f2: int32;
      f3: string;
      f4: boolean;
      f5: bytes;
    }

    @codec
    model Five05 {
      f1: int64;
      f2: uint64;
      f3: string;
      f4: float32;
      f5: int32;
    }

    @codec
    model Five06 {
      f1: boolean;
      f2: string;
      f3: int32;
      f4: float64;
      f5: uint32;
    }

    @codec
    model Five07 {
      f1: bytes;
      f2: bytes;
      f3: string;
      f4: int32;
      f5: float64;
    }

    @codec
    model Five08 {
      f1: uint8;
      f2: uint16;
      f3: uint32;
      f4: int8;
      f5: int16;
    }

    @codec
    model Five09 {
      f1: float32;
      f2: float64;
      f3: int32;
      f4: int64;
      f5: string;
    }

    @codec
    model Five10 {
      f1: string;
      f2: boolean;
      f3: int64;
      f4: uint64;
      f5: float64;
    }

    @codec
    model Ten01 {
      f1: string;
      f2: boolean;
      f3: int8;
      f4: int16;
      f5: int32;
      f6: int64;
      f7: uint8;
      f8: uint16;
      f9: uint32;
      f10: uint64;
    }

    @codec
    model Ten02 {
      f1: int16;
      f2: int32;
      f3: int64;
      f4: uint8;
      f5: uint16;
      f6: uint32;
      f7: uint64;
      f8: float32;
      f9: float64;
      f10: bytes;
    }

    @codec
    model Ten03 {
      f1: uint8;
      f2: uint16;
      f3: uint32;
      f4: uint64;
      f5: float32;
      f6: float64;
      f7: bytes;
      f8: string;
      f9: boolean;
      f10: int8;
    }

    @codec
    model Ten04 {
      f1: uint64;
      f2: float32;
      f3: float64;
      f4: bytes;
      f5: string;
      f6: boolean;
      f7: int8;
      f8: int16;
      f9: int32;
      f10: int64;
    }

    @codec
    model Ten05 {
      f1: bytes;
      f2: string;
      f3: boolean;
      f4: int8;
      f5: int16;
      f6: int32;
      f7: int64;
      f8: uint8;
      f9: uint16;
      f10: uint32;
    }

  }
  namespace Mixed {
    @codec
    model ModelArr1 {
      points: Inner[];
    }

    @codec
    model ModelArr2 {
      coords: Coord[];
    }

    @codec
    model ModelArr3 {
      items: IdVal[];
      tag: string;
    }

    @codec
    model ModelArr4 {
      labels: Label[];
      count: int32;
    }

    @codec
    model ModelArr5 {
      arr: Money[];
      bs: Addr[];
    }

    @codec
    model Mix01 {
      name: string;
      value: int32;
      point: Inner;
    }

    @codec
    model Mix02 {
      id: string;
      loc: Coord;
      tags: string[];
    }

    @codec
    model Mix03 {
      label: string;
      value_range: Range32;
      active: boolean;
    }

    @codec
    model Mix04 {
      title: string;
      price: Money;
      inStock: boolean;
      rating: float64;
    }

    @codec
    model Mix05 {
      addr: Addr;
      coords: Coord[];
    }

    @codec
    model Mix06 {
      name: string;
      age: int32;
      address?: Addr;
      email?: string;
    }

    @codec
    model Mix07 {
      origin: Point3;
      dest: Point3;
      distance: float64;
    }

    @codec
    model Mix08 {
      keys: string[];
      values: int32[];
      meta?: Label;
    }

    @codec
    model Mix09 {
      id: int64;
      payload: bytes;
      checksum: uint32;
      prev?: IdVal;
    }

    @codec
    model Mix10 {
      items: string[];
      total: int32;
      avg: float64;
      value_range: Range32;
    }

    @codec
    model Mix11 {
      name: string;
      values: float64[];
      nested?: Inner;
      flag?: boolean;
    }

    @codec
    model Mix12 {
      header: string;
      entries: IdVal[];
      footer?: string;
    }

    @codec
    model Mix13 {
      a: int32;
      b: float64;
      c: string;
      d: boolean;
      e: bytes;
      nested: Inner;
    }

    @codec
    model Mix14 {
      amounts: Money[];
      total: int64;
      currency: string;
    }

    @codec
    model Mix15 {
      src_addr: Addr;
      dst_addr: Addr;
      distance: float64;
      duration: float64;
    }

    @codec
    model AllOpt1 {
      a?: string;
      b?: int32;
      c?: boolean;
    }

    @codec
    model AllOpt2 {
      x?: float64;
      y?: bytes;
      z?: int64;
    }

    @codec
    model AllOpt3 {
      name?: string;
      age?: int32;
      score?: float64;
      active?: boolean;
    }

    @codec
    model AllOpt4 {
      a?: uint32;
      b?: uint64;
      c?: int32;
      d?: string;
      e?: bytes;
    }

    @codec
    model AllOpt5 {
      p?: Inner;
      q?: string;
    }

  }
  namespace Nests {
    @codec
    model NestInner {
      nested: Inner;
    }

    @codec
    model NestCoord {
      nested: Coord;
    }

    @codec
    model NestIdVal {
      nested: IdVal;
    }

    @codec
    model NestLabel {
      nested: Label;
    }

    @codec
    model NestMoney {
      nested: Money;
    }

    @codec
    model NestRange32 {
      nested: Range32;
    }

    @codec
    model NestAddr {
      nested: Addr;
    }

    @codec
    model NestPoint3 {
      nested: Point3;
    }

    @codec
    model OptNestInner {
      label: string;
      nested?: Inner;
    }

    @codec
    model OptNestCoord {
      label: string;
      nested?: Coord;
    }

    @codec
    model OptNestIdVal {
      label: string;
      nested?: IdVal;
    }

    @codec
    model OptNestLabel {
      label: string;
      nested?: Label;
    }

    @codec
    model OptNestMoney {
      label: string;
      nested?: Money;
    }

    @codec
    model OptNestRange32 {
      label: string;
      nested?: Range32;
    }

    @codec
    model OptNestAddr {
      label: string;
      nested?: Addr;
    }

    @codec
    model OptNestPoint3 {
      label: string;
      nested?: Point3;
    }

  }
  namespace Opt {
    @codec
    model OptSingleString {
      v?: string;
    }

    @codec
    model OptSingleBoolean {
      v?: boolean;
    }

    @codec
    model OptSingleInt8 {
      v?: int8;
    }

    @codec
    model OptSingleInt16 {
      v?: int16;
    }

    @codec
    model OptSingleInt32 {
      v?: int32;
    }

    @codec
    model OptSingleInt64 {
      v?: int64;
    }

    @codec
    model OptSingleUint8 {
      v?: uint8;
    }

    @codec
    model OptSingleUint16 {
      v?: uint16;
    }

    @codec
    model OptSingleUint32 {
      v?: uint32;
    }

    @codec
    model OptSingleUint64 {
      v?: uint64;
    }

    @codec
    model OptSingleFloat32 {
      v?: float32;
    }

    @codec
    model OptSingleFloat64 {
      v?: float64;
    }

    @codec
    model OptSingleBytes {
      v?: bytes;
    }

  }
  namespace Pairs {
    @codec
    model PairString {
      a: string;
      b: string;
    }

    @codec
    model PairBoolean {
      a: boolean;
      b: boolean;
    }

    @codec
    model PairInt8 {
      a: int8;
      b: int8;
    }

    @codec
    model PairInt16 {
      a: int16;
      b: int16;
    }

    @codec
    model PairInt32 {
      a: int32;
      b: int32;
    }

    @codec
    model PairInt64 {
      a: int64;
      b: int64;
    }

    @codec
    model PairUint8 {
      a: uint8;
      b: uint8;
    }

    @codec
    model PairUint16 {
      a: uint16;
      b: uint16;
    }

    @codec
    model PairUint32 {
      a: uint32;
      b: uint32;
    }

    @codec
    model PairUint64 {
      a: uint64;
      b: uint64;
    }

    @codec
    model PairFloat32 {
      a: float32;
      b: float32;
    }

    @codec
    model PairFloat64 {
      a: float64;
      b: float64;
    }

    @codec
    model PairBytes {
      a: bytes;
      b: bytes;
    }

    @codec
    model DualStringInt32 {
      a: string;
      b: int32;
    }

    @codec
    model DualStringBoolean {
      a: string;
      b: boolean;
    }

    @codec
    model DualStringFloat64 {
      a: string;
      b: float64;
    }

    @codec
    model DualStringBytes {
      a: string;
      b: bytes;
    }

    @codec
    model DualInt32Boolean {
      a: int32;
      b: boolean;
    }

    @codec
    model DualInt32Float64 {
      a: int32;
      b: float64;
    }

    @codec
    model DualInt32Int64 {
      a: int32;
      b: int64;
    }

    @codec
    model DualInt32Uint32 {
      a: int32;
      b: uint32;
    }

    @codec
    model DualInt64Uint64 {
      a: int64;
      b: uint64;
    }

    @codec
    model DualFloat32Float64 {
      a: float32;
      b: float64;
    }

    @codec
    model DualFloat64Boolean {
      a: float64;
      b: boolean;
    }

    @codec
    model DualFloat64Bytes {
      a: float64;
      b: bytes;
    }

    @codec
    model DualUint32Uint64 {
      a: uint32;
      b: uint64;
    }

    @codec
    model DualBooleanBytes {
      a: boolean;
      b: bytes;
    }

    @codec
    model DualInt8Uint8 {
      a: int8;
      b: uint8;
    }

    @codec
    model DualInt16Uint16 {
      a: int16;
      b: uint16;
    }

    @codec
    model DualStringInt64 {
      a: string;
      b: int64;
    }

    @codec
    model DualStringUint64 {
      a: string;
      b: uint64;
    }

    @codec
    model DualInt32Bytes {
      a: int32;
      b: bytes;
    }

    @codec
    model DualFloat64Int32 {
      a: float64;
      b: int32;
    }

    @codec
    model DualBooleanInt32 {
      a: boolean;
      b: int32;
    }

    @codec
    model DualBytesInt64 {
      a: bytes;
      b: int64;
    }

    @codec
    model DualInt8Float32 {
      a: int8;
      b: float32;
    }

    @codec
    model DualUint8Int16 {
      a: uint8;
      b: int16;
    }

    @codec
    model DualInt64Float64 {
      a: int64;
      b: float64;
    }

    @codec
    model DualUint64String {
      a: uint64;
      b: string;
    }

    @codec
    model Triple01 {
      a: string;
      b: int32;
      c: boolean;
    }

    @codec
    model Triple02 {
      a: float64;
      b: float64;
      c: float64;
    }

    @codec
    model Triple03 {
      a: int32;
      b: int32;
      c: int32;
    }

    @codec
    model Triple04 {
      a: string;
      b: string;
      c: int32;
    }

    @codec
    model Triple05 {
      a: int64;
      b: string;
      c: boolean;
    }

    @codec
    model Triple06 {
      a: uint32;
      b: uint64;
      c: string;
    }

    @codec
    model Triple07 {
      a: bytes;
      b: string;
      c: int32;
    }

    @codec
    model Triple08 {
      a: float32;
      b: int32;
      c: boolean;
    }

    @codec
    model Triple09 {
      a: string;
      b: int64;
      c: float64;
    }

    @codec
    model Triple10 {
      a: boolean;
      b: boolean;
      c: boolean;
    }

    @codec
    model Triple11 {
      a: int8;
      b: int16;
      c: int32;
    }

    @codec
    model Triple12 {
      a: uint8;
      b: uint16;
      c: uint32;
    }

    @codec
    model Triple13 {
      a: string;
      b: bytes;
      c: float64;
    }

    @codec
    model Triple14 {
      a: int64;
      b: uint64;
      c: boolean;
    }

    @codec
    model Triple15 {
      a: float64;
      b: string;
      c: bytes;
    }

  }
  namespace Recursive {
    @codec
    model RecList {
      value: int32;
      next?: RecList;
    }

    @codec
    model RecTree {
      value: string;
      left_node?: RecTree;
      right_node?: RecTree;
    }

    @codec
    model RecChain {
      id: int32;
      label: string;
      next?: RecChain;
    }

    @codec
    model RecWrap {
      payload: bytes;
      nested?: RecWrap;
    }

    @codec
    model RecWide {
      a: int32;
      b: string;
      c: float64;
      child?: RecWide;
    }

  }
  namespace Scalars {
    @codec
    model SingleString {
      v: string;
    }

    @codec
    model SingleBoolean {
      v: boolean;
    }

    @codec
    model SingleInt8 {
      v: int8;
    }

    @codec
    model SingleInt16 {
      v: int16;
    }

    @codec
    model SingleInt32 {
      v: int32;
    }

    @codec
    model SingleInt64 {
      v: int64;
    }

    @codec
    model SingleUint8 {
      v: uint8;
    }

    @codec
    model SingleUint16 {
      v: uint16;
    }

    @codec
    model SingleUint32 {
      v: uint32;
    }

    @codec
    model SingleUint64 {
      v: uint64;
    }

    @codec
    model SingleFloat32 {
      v: float32;
    }

    @codec
    model SingleFloat64 {
      v: float64;
    }

    @codec
    model SingleBytes {
      v: bytes;
    }

  }
  namespace Unions {
    @codec
    model UnionFieldHolder {
      shape: Shape;
      id: Ident;
    }

    @codec
    model OptUnionFieldHolder {
      shape?: Shape;
      name: string;
    }

    @codec
    model UnionArrayHolder {
      shapes: Shape[];
    }

    @codec
    model UnionMixedHolder {
      result: ResultMsg;
      tag: Tagged;
      count: int32;
    }

    @codec
    model UnionScalarHolder {
      id: Ident;
      sc: ScalarUnion;
      label: string;
    }

    @codec
    union Shape {
      circle: Coord,
      rect: Range32,
    }

    @codec
    union Ident {
      name: string,
      number: int32,
    }

    @codec
    union ResultMsg {
      ok: string,
      err: Label,
    }

    @codec
    union Tagged {
      tag: string,
      score: float64,
      active: boolean,
    }

    @codec
    union OptUnionHolder {
      shape: Shape,
      id: Ident,
    }

    @codec
    union MixedUnion {
      point: Coord,
      label: string,
      count: int32,
    }

    @codec
    union NestedUnion {
      result: ResultMsg,
      shape: Shape,
    }

    @codec
    union ScalarUnion {
      s: string,
      i: int32,
      f: float64,
      b: boolean,
    }

  }
  namespace Wide {
    @codec
    model Wide20 {
      f1: string;
      f2: boolean;
      f3: int8;
      f4: int16;
      f5: int32;
      f6: int64;
      f7: uint8;
      f8: uint16;
      f9: uint32;
      f10: uint64;
      f11: float32;
      f12: float64;
      f13: bytes;
      f14: string;
      f15: boolean;
      f16: int8;
      f17: int16;
      f18: int32;
      f19: int64;
      f20: uint8;
    }

    @codec
    model Wide25 {
      f1: uint16;
      f2: uint32;
      f3: uint64;
      f4: float32;
      f5: float64;
      f6: bytes;
      f7: string;
      f8: boolean;
      f9: int8;
      f10: int16;
      f11: int32;
      f12: int64;
      f13: uint8;
      f14: uint16;
      f15: uint32;
      f16: uint64;
      f17: float32;
      f18: float64;
      f19: bytes;
      f20: string;
      f21: boolean;
      f22: int8;
      f23: int16;
      f24: int32;
      f25: int64;
    }

    @codec
    model Wide30 {
      f1: boolean;
      f2: int8;
      f3: int16;
      f4: int32;
      f5: int64;
      f6: uint8;
      f7: uint16;
      f8: uint32;
      f9: uint64;
      f10: float32;
      f11: float64;
      f12: bytes;
      f13: string;
      f14: boolean;
      f15: int8;
      f16: int16;
      f17: int32;
      f18: int64;
      f19: uint8;
      f20: uint16;
      f21: uint32;
      f22: uint64;
      f23: float32;
      f24: float64;
      f25: bytes;
      f26: string;
      f27: boolean;
      f28: int8;
      f29: int16;
      f30: int32;
    }

    @codec
    model Wide35 {
      f1: uint32;
      f2: uint64;
      f3: float32;
      f4: float64;
      f5: bytes;
      f6: string;
      f7: boolean;
      f8: int8;
      f9: int16;
      f10: int32;
      f11: int64;
      f12: uint8;
      f13: uint16;
      f14: uint32;
      f15: uint64;
      f16: float32;
      f17: float64;
      f18: bytes;
      f19: string;
      f20: boolean;
      f21: int8;
      f22: int16;
      f23: int32;
      f24: int64;
      f25: uint8;
      f26: uint16;
      f27: uint32;
      f28: uint64;
      f29: float32;
      f30: float64;
      f31: bytes;
      f32: string;
      f33: boolean;
      f34: int8;
      f35: int16;
    }

    @codec
    model Wide40 {
      f1: int8;
      f2: int16;
      f3: int32;
      f4: int64;
      f5: uint8;
      f6: uint16;
      f7: uint32;
      f8: uint64;
      f9: float32;
      f10: float64;
      f11: bytes;
      f12: string;
      f13: boolean;
      f14: int8;
      f15: int16;
      f16: int32;
      f17: int64;
      f18: uint8;
      f19: uint16;
      f20: uint32;
      f21: uint64;
      f22: float32;
      f23: float64;
      f24: bytes;
      f25: string;
      f26: boolean;
      f27: int8;
      f28: int16;
      f29: int32;
      f30: int64;
      f31: uint8;
      f32: uint16;
      f33: uint32;
      f34: uint64;
      f35: float32;
      f36: float64;
      f37: bytes;
      f38: string;
      f39: boolean;
      f40: int8;
    }

  }
  namespace nested {
    @codec
    model NestedSimple {
      name: string;
      value: int32;
    }

  }
  namespace nested {
    namespace deep {
      @codec
      model DeepModel {
        payload: bytes;
        count: int64;
      }

    }
  }
}
