`var $`

cacheBust = '__rand__'

loadExternalResource = (type, source, callback, params) ->
  tag = null
  if type == "js"
    tag = document.createElement("script")
    tag.setAttribute "type", "text/javascript"
    tag.setAttribute "src", source
  else if type == "css"
    tag = document.createElement("link")
    tag.setAttribute "type", "text/css"
    tag.setAttribute "rel", "stylesheet"
    tag.setAttribute "href", source
  if tag.readyState
    tag.onreadystatechange = ->
      callback(params) if @readyState is "complete" or @readyState is "loaded"
      return
  else
    tag.onload = ->
      callback(params)
      return
  (document.getElementsByTagName("head")[0] or document.documentElement).appendChild tag

`var globalDefaults = {};`

loadExternalScripts = ->
  testmode = ($("#donation-script").data('testmode') == true)
  donationsJs = if testmode then "../js/jquery.donations.js" else "jquery.donations.js"
  scriptStrings = [donationsJs]
  loadedScripts = 0
  executeMain = ->
    loadedScripts++
    if loadedScripts == scriptStrings.length
      initJQueryPayments(jQuery)
      googleAnalyticsInit()
      initializeForm = (config) ->
        $('.donations-form-anchor').append(html)
        Honeybadger.configure
          api_key: "__honeybadgerpublickey__"
          environment: "__environment__"
        ko.applyBindings(new DonationsFormModel($, $.extend(config, $("#donation-script").data())))
      loadJson = (callback) ->
        serverPath = $("#donation-script").data('pathtoserver') or "__praguepathtoserver__"
        urlForConfig = if serverPath.slice(-1) == "/" then serverPath + "config" else serverPath + "/config"
        jsonUrl = if testmode then "config/config.json" else "#{urlForConfig}\/#{$('#donation-script').data('org')}.json"
        $.ajax
          dataType: if testmode then 'json' else 'jsonp'
          url: jsonUrl
          success: callback
          error: callback
      if testmode then loadJson(initializeForm) else loadJson(initializeForm)

  for scrString in scriptStrings
    loadExternalResource("js", scrString, executeMain)

googleAnalyticsInit = ->
  ((i, s, o, g, r, a, m) ->
    i["GoogleAnalyticsObject"] = r
    i[r] = i[r] or ->
      (i[r].q = i[r].q or []).push arguments
      return

    i[r].l = 1 * new Date()

    a = s.createElement(o)
    m = s.getElementsByTagName(o)[0]

    a.async = 1
    a.src = g
    m.parentNode.insertBefore a, m
    return
  ) window, document, "script", "//www.google-analytics.com/analytics.js", "gaDonations"
  gaDonations "create", "UA-48690908-1", "controlshiftlabs.com"
  gaDonations "send", "pageview"

scriptLoadHandler = ->
  `$ = jQuery = window.jQuery.noConflict(true)`
  testmode = ($("#donation-script").data('testmode') == true)
  cssSrc = if testmode then "../css/jquery.donations.css" else "jquery.donations.css"
  loadExternalResource("css", cssSrc, (->))
  loadExternalScripts()
  return

if window.jQuery is `undefined` or (window.jQuery.fn.jquery and (parseInt(window.jQuery.fn.jquery[0]) != 1 or parseInt(window.jQuery.fn.jquery[1]) < 9))
  loadExternalResource("js","https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js",scriptLoadHandler)
else
  scriptLoadHandler()
