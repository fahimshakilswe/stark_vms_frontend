{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    canvasKitBaseUrl: "canvaskit/"
  },
  onEntrypointLoaded: async function(engineInitializer) {
    try {
      const appRunner = await engineInitializer.initializeEngine({
        canvasKitBaseUrl: "canvaskit/"
      });
      await appRunner.runApp();
      if (window.__hideBootLoader) {
        window.__hideBootLoader();
      }
    } catch (error) {
      console.error("Stark Group VMS engine initialization failed:", error);
      if (window.__showBootError) {
        window.__showBootError(
          error && error.message ? error.message : String(error || "Unknown initialization error")
        );
      }
    }
  }
}).catch(function(error) {
  console.error("Stark Group VMS bootstrap failed:", error);
  if (window.__showBootError) {
    window.__showBootError(
      error && error.message ? error.message : String(error || "Failed to load application scripts")
    );
  }
});
