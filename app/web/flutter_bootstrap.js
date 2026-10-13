{{flutter_js}}
{{flutter_build_config}}

// Die App läuft im Telefonrahmen auf der Seite, ohne Service Worker.
_flutter.loader.load({
  onEntrypointLoaded: async (engineInitializer) => {
    const appRunner = await engineInitializer.initializeEngine({
      hostElement: document.querySelector('#phone-screen'),
    });
    await appRunner.runApp();
    document.querySelector('#phone-loading')?.remove();
  },
});
