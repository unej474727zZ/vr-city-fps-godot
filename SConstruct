#!/usr/bin/env python
import os
import sys

# Llama al archivo de compilación de godot-cpp para que configure todo automáticamente
env = SConscript("godot-cpp/SConstruct")

# Configuramos nuestra propia extensión
env.Append(CPPPATH=["src/"])
sources = Glob("src/*.cpp")

# Compilamos nuestra librería compartida dentro de la carpeta godot_project/bin
if env["platform"] == "windows":
    library = env.SharedLibrary(
        "godot_project/bin/vrcityfps{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )
elif env["platform"] == "linux":
    library = env.SharedLibrary(
        "godot_project/bin/vrcityfps{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )
elif env["platform"] == "macos":
    library = env.SharedLibrary(
        "godot_project/bin/vrcityfps{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )
elif env["platform"] == "android":
    library = env.SharedLibrary(
        "godot_project/bin/vrcityfps{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
