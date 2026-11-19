// Grafana supplies React and its panel API through the plugin module loader.
System.register(['react', '@grafana/data'], function (exports) {
  let React;
  let PanelPlugin;

  function HelloPanel() {
    return React.createElement('div', { style: { padding: '1rem' } }, 'Hello World');
  }

  return {
    setters: [
      (module) => { React = module.default ?? module; },
      (module) => { PanelPlugin = module.PanelPlugin; },
    ],
    execute() {
      exports('plugin', new PanelPlugin(HelloPanel));
    },
  };
});
