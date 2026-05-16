import "../dist/decorators.js";

using TypeSpec.Reflection;

namespace Specodec {
  extern dec codec(target: Model | Enum | Union);
}
