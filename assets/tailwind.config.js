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
      serif: ['Crimson Pro', 'ui-serif', 'Georgia', 'Cambria', '"Times New Roman"', 'Times', 'serif'],
      mono: [
        'ui-monospace',
        'SFMono-Regular',
        'Menlo',
        'Monaco',
        'Consolas',
        '"Liberation Mono"',
        '"Courier New"',
        'monospace',
      ],
      sans: [
        'ui-sans-serif',
        'system-ui',
        '-apple-system',
        'BlinkMacSystemFont',
        '"Segoe UI"',
        'Roboto',
        '"Helvetica Neue"',
        'Arial',
        '"Noto Sans"',
        'sans-serif',
        '"Apple Color Emoji"',
        '"Segoe UI Emoji"',
        '"Segoe UI Symbol"',
        '"Noto Color Emoji"',
      ],
    },
    colors: {
      white: {
        DEFAULT: '#FFFFFF',
      },
      purple: {
        DEFAULT: '#7B529B',
        dark: '#321C3D',
        light: '#B994D7'
      },
      lime: {
        DEFAULT: '#DBD420'
      },
      pink: {
        DEFAULT: '#FFE1DA',
        dark: '#E3ADA1'
      },
      meter: {
        '25': '#ff9595',
        '50': '#ffc295',
        '75': '#ffe995',
        '100': '#DBD420',
      }
    },
    extend: {
      height: {
        '100': '100px',
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
