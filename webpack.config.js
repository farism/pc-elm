module.exports = {
  entry: './src/index.js',
  output: {
    path: './dist',
    filename: '[name].[chunkhash].js',
    chunkFilename: '[name].[chunkhash].js',
  },
  resolve: {
    extensions: ['.js', '.elm'],
  },
  module: {
    noParse: /\.elm$/,
    rules: [{
      test: /\.js/,
      exclude: [/node_modules/],
      use: {
        loader: 'babel-loader',
      }
    },{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      use: {
        loader: 'elm-webpack-loader',
      }
    }]
  },
};
