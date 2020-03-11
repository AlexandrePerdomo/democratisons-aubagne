module.exports = {
  extends: ["eslint-config-airbnb-base", "plugin:prettier/recommended"],

  env: {
    browser: true,
    jquery: true
  },

  rules: {
    "import/no-extraneous-dependencies": "off"
  },

  parser: "babel-eslint",

  settings: {
    "import/resolver": {
      webpack: {
        config: {
          resolve: {
            modules: ["frontend", "node_modules"]
          }
        }
      }
    }
  }
};
