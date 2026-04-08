# Web Export Guide — Unreal Albion

## Export from Godot

1. Open the project in Godot 4.3+
2. Project → Export → Add Preset → Web
3. Set features: GL Compatibility
4. Export to a folder (e.g. `web_build/`)

## Required Server Headers

Godot 4 web exports require these HTTP headers for SharedArrayBuffer support:

```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

### itch.io
itch.io sets these headers automatically. Upload the zip and it works.

### GitHub Pages
Add a `_headers` file or use a service worker. Easiest: use the
[coi-serviceworker](https://github.com/nicolgit/nicolgit.github.io/blob/main/service-worker-coop-coep.md) approach — drop `coi-serviceworker.js` next to your `index.html`.

### Netlify
Add a `_headers` file:
```
/*
  Cross-Origin-Opener-Policy: same-origin
  Cross-Origin-Embedder-Policy: require-corp
```

### Custom Server (nginx)
```nginx
add_header Cross-Origin-Opener-Policy "same-origin";
add_header Cross-Origin-Embedder-Policy "require-corp";
```

## Mobile Browser Notes

- Viewport is 1080x1920 (portrait-first)
- Touch input is enabled via `emulate_mouse_from_touch`
- All UI elements have 48px+ touch targets
- Phone UI is full-screen overlay with close button
- The `expand` stretch aspect mode adapts to any screen ratio
