const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  purge: [
    "./views/**/*.html.erb"
  ],
  darkMode: false,
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
