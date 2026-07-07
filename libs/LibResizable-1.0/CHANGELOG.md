# LibResizable-1.0 Changelog

## [1.0.0] - 2026-06-29

### Initial Release

First release of LibResizable-1.0.

- Bottom-right corner resize handle using native WoW StartSizing / StopMovingOrSizing API
- Throttled onResizing callback (~20 calls/sec by default) to prevent frame drops during drag
- onResizeStart and onResizeStop callbacks for full lifecycle control
- Min/max size enforcement via SetResizeBounds
- Snap-to-grid support — snaps on mouse release, no mid-drag jank
- Aspect ratio locking — ratio captured fresh at each drag start
- SavedVariables auto-save and restore — pass your DB table and a key, done
- MakeResizableGroup for applying the same config to multiple frames at once
- Full handle object API: Enable, Disable, SetMinSize, SetMaxSize, SetThrottle, SetSnapGrid, SetAspectLock, GetSize, ResetSize, Destroy
- DestroyAll for clean addon disable/unload
- LibStub versioning — safe to embed across multiple addons without conflicts
- Zero per-frame overhead when no resize is in progress
