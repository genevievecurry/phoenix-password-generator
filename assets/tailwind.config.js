module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    fontFamily: {
      serif: ['Crimson Pro', 'serif'],
    },
    colors: {
      white: {
        DEFAULT: '#FFFFFF',
      },
      purple: {
        DEFAULT: '#7B529B',
        dark: '#321C3D',
      },
      lime: {
        DEFAULT: '#DBD420'
      },
      pink: {
        DEFAULT: '#FFE1DA'
      }
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
