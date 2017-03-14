const webpack = require('webpack')
const ChunkManifestPlugin = require('chunk-manifest-webpack-plugin')
const CompressionPlugin = require('compression-webpack-plugin')
const ManifestPlugin = require('webpack-manifest-plugin')

const NODE_ENV = process.env.NODE_ENV || 'development'
const HOST = 'http://localhost'
const PORT = '8080'

const getEntry = prod =>
  prod
    ? { index: './src/index.js' }
    : {
        index: [`webpack-dev-server/client?${HOST}:${PORT}`, './src/index.js'],
      }

const getOutput = prod =>
  prod
    ? {
        path: 'dist',
        filename: '[name].[chunkhash].js',
        chunkFilename: '[name].[chunkhash].js',
      }
    : {
        path: '/build',
        publicPath: `/build/`,
        filename: '[name].js',
        chunkFilename: '[name].js',
      }

const getPlugins = prod =>
  prod
    ? [
        new webpack.optimize.UglifyJsPlugin({
          compress: {
            warnings: false,
            drop_debugger: true,
            drop_console: true,
          },
          output: {
            comments: false,
          },
          sourceMap: false,
        }),
        new CompressionPlugin({
          asset: '[path].gz[query]',
          algorithm: 'gzip',
          test: /\.js$/,
          threshold: 0,
          minRatio: 0.9,
        }),
        new ChunkManifestPlugin({
          filename: 'chunk-manifest.json',
          manifestVariable: 'webpackManifest',
        }),
        new ManifestPlugin({
          fileName: 'file-manifest.json',
          basePath: '',
        }),
      ]
    : []

const isProd = NODE_ENV === 'production'

module.exports = {
  entry: getEntry(isProd),

  output: getOutput(isProd),

  plugins: getPlugins(isProd),

  module: {
    // noParse: /\.elm$/,
    rules: [
      {
        test: /\.js$/,
        exclude: [/node_modules/],
        use: {
          loader: 'babel-loader?presets=latest&plugins=syntax-dynamic-import',
        },
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: 'elm-assets-loader?module=Assets&tagger=AssetPath',
          },
          {
            loader: 'elm-webpack-loader',
          },
        ],
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        loader: 'file-loader',
        query: {
          name: '[name].[hash].[ext]',
        },
      },
    ],
  },

  resolve: {
    extensions: ['.js', '.elm'],
  },

  devServer: {
    publicPath: `${HOST}:${PORT}/build/`,
    port: PORT,
    compress: true,
    stats: 'minimal',
    historyApiFallback: {
      rewrites: [{ from: /./, to: '/src/index.html' }],
    },
  },
}
