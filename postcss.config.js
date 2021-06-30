module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    }),
    require('@fullhuman/postcss-purgecss')({
      content: ['./app/**/*.html.erb', 
                './app/helpers/**/*.rb', 
                './app/javascript/**/*.js'
                './app/assets/stylesheets/style.min.scss']
    }),
    defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || []
  ]
}
