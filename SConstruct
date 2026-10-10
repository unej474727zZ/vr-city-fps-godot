#!/usr/bin/env python
import os
import sys

# godot-cpp configura toolchain, plataforma, target y arquitectura automáticamente.
env = SConscript("godot-cpp/SConstruct")

# Extensión propia
env.Append(CPPPATH=["src/"])
sources = Glob("src/*.cpp")

# Nombre de salida: vrcityfps.<platform>.<target>.<arch>.<ext> en godot_project/bin
# (SHLIBPREFIX aporta el "lib" en Android/Linux/macOS, y SHLIBSUFFIX la extensión).
library = env.SharedLibrary(
    "godot_project/bin/vrcityfps{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
    source=sources,
)

Default(library)
