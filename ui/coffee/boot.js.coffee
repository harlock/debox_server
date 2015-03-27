# Main UnicoApp
#----------------------------------------------------------------------

window.app = app = new UnicoApp enableRouter: true, templateBasePath: '/tmpl'
window.app.debug = true


window.Debox =

  isLoggedIn: ->
    app.getCookie 'debox_auth'

  startSession: ->
    app.model('session').get().done (data) =>
      @user = data

    @liveLogger.start()




class BaseController
  @beforeAction: () ->
    unless Debox.isLoggedIn()
      return redirect: '/sessions/sign_in'


  user: -> Debox.user || {}


class AdminController extends BaseController
  layout: 'admin'

window.Debox.BaseController = BaseController
window.Debox.AdminController = AdminController

window.onload = ->
  Debox.startSession() if Debox.isLoggedIn()
  app.startRouter()
