# VR City FPS (Godot + C++)

Shooter táctico en 3ª persona en una ciudad, escrito como **GDExtension en C++** (`godot-cpp`) y ensamblado en **Godot 4.x** (renderer *GL Compatibility*). Objetivo principal: **Android**, jugado con mando. Se está migrando del modo estéreo VR a 3D normal de pantalla completa.

## Estructura

```
vr_city_fps/
├── SConstruct              # Build de la extensión (SCons)
├── godot-cpp/              # Bindings de C++ para Godot
├── src/                    # Código C++ (VRPlayer, registro de clases)
└── godot_project/          # Proyecto Godot
    ├── main.tscn           # Escena principal
    ├── vrcityfps.gdextension
    ├── assets/             # Modelos, animaciones, ciudad
    ├── bin/                # Librerías compiladas (ignorado por git)
    └── tools/              # Scripts de editor de un solo uso (generar ciudad, animaciones, blendspace…)
```

## Requisitos
- Godot 4.x (el proyecto declara 4.7)
- Python 3 + SCons (`pip install scons`)
- Windows: Visual Studio Community (MSVC) · Android: Android NDK

## Compilar la extensión

```powershell
# Windows (debug)
scons platform=windows target=template_debug

# Windows (release)
scons platform=windows target=template_release

# Android arm64
scons platform=android arch=arm64 target=template_release
```

La salida va a `godot_project/bin/` (ignorado por git; hay que compilar tras clonar).

## Controles (mando)
| Acción | Entrada |
|---|---|
| Mover | Stick izquierdo |
| Girar / mirar | Stick derecho |
| Saltar | Botón 0 (A / X) |
| Correr | Botón 8 / gatillo izquierdo |
| Disparar | Botón 10 |

## Herramientas (`godot_project/tools/`)
Son `EditorScript`/scripts de ayuda. Se ejecutan manualmente desde el editor (*File → Run*) y no forman parte del juego.
- `build_city.gd` — genera `assets/models/ciudad_lista.tscn` con colisiones a partir de la ciudad GLTF.
- `build_animations.gd` — construye `combat_anims.res` desde los GLB de animación.
- `setup_blendspace.gd`, `inject_locomotion.gd`, `inspect_bones.gd`, `dump_tree.gd` — utilidades de animación y depuración.

## Roadmap
- [ ] Quitar el estéreo VR (SubViewports/RemoteTransform) → una sola `Camera3D`
- [ ] Controles táctiles para Android (joysticks virtuales)
- [ ] Arreglar recoil, gravedad y salto en `VRPlayer`; exponer propiedades al editor
- [ ] Disparo real (raycast, daño, munición)
- [ ] Export a Android y optimización
