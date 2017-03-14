const apps = { CustomReports: () => import('./CustomReports/Main.elm') }

function embed(node, appName, moduleName, flags) {
  try {
    if (apps[appName]) {
      apps[appName]().then(app => {
        if (app[moduleName]) {
          app[moduleName].embed(node, flags)
        } else {
          throw new Error(`Module \`${module}\` does not exist on \`${app}\``)
        }
      })
      // console.log(app())
      // .fail((error) => {
      //   throw new Error('Error loading component', error)
      // })
    } else {
      throw new Error(`App \`${app}\`does not exist`)
    }
  } catch (e) {
    console.error(e)
  }
}

window.embed = embed
