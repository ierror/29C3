class Helper
  @i18nDateFormats

  constructor: ->
    @i18nDateFormats = @_i18nDateFormats()

  _i18nDateFormats: ->
    dayNames: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    monthNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

  formatDate: (date, mask, utc) ->
    # Build coffeescript version form Date Format 1.2.3
    #
    #    * Date Format 1.2.3
    #    * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
    #    * MIT license
    #    *
    #    * Includes enhancements by Scott Trenda <scott.trenda.net>
    #    * and Kris Kowal <cixar.com/~kris.kowal/>
    #    *
    #    * Accepts a date, a mask, or a date and a mask.
    #    * Returns a formatted version of the given date.
    #    * The date defaults to the current date/time.
    #    * The mask defaults to dateFormat.masks.default.
    #
    self = @
    inner = {}
    # Some common format strings
    inner.masks =
      default: "ddd mmm dd yyyy HH:MM:ss"
      shortDate: "m/d/yy"
      mediumDate: "mmm d, yyyy"
      longDate: "mmmm d, yyyy"
      fullDate: "dddd, mmmm d, yyyy"
      shortTime: "h:MM TT"
      mediumTime: "h:MM:ss TT"
      longTime: "h:MM:ss TT Z"
      isoDate: "yyyy-mm-dd"
      isoTime: "HH:MM:ss"
      isoDateTime: "yyyy-mm-dd'T'HH:MM:ss"
      isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"

    inner._dateFormat = ->
      token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g
      timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g
      timezoneClip = /[^-+\dA-Z]/g
      pad = (val, len) ->
        val = String(val)
        len = len or 2
        val = "0" + val  while val.length < len
        val

      # Passing date through Date applies Date.parse, if necessary
      date = (if date then new Date(date) else new Date)
      throw SyntaxError("invalid date")  if isNaN(date)
      mask = String(inner.masks[mask] or mask or inner.masks["default"])

      # Allow setting the utc argument via the mask
      if mask.slice(0, 4) is "UTC:"
        mask = mask.slice(4)
        utc = true
      _ = (if utc then "getUTC" else "get")
      d = date[_ + "Date"]()
      D = date[_ + "Day"]()
      m = date[_ + "Month"]()
      y = date[_ + "FullYear"]()
      H = date[_ + "Hours"]()
      M = date[_ + "Minutes"]()
      s = date[_ + "Seconds"]()
      L = date[_ + "Milliseconds"]()
      o = (if utc then 0 else date.getTimezoneOffset())
      flags =
        d: d
        dd: pad(d)
        ddd: self.i18nDateFormats.dayNames[D]
        dddd: self.i18nDateFormats.dayNames[D + 7]
        m: m + 1
        mm: pad(m + 1)
        mmm: self.i18nDateFormats.monthNames[m]
        mmmm: self.i18nDateFormats.monthNames[m + 12]
        yy: String(y).slice(2)
        yyyy: y
        h: H % 12 or 12
        hh: pad(H % 12 or 12)
        H: H
        HH: pad(H)
        M: M
        MM: pad(M)
        s: s
        ss: pad(s)
        l: pad(L, 3)
        L: pad((if L > 99 then Math.round(L / 10) else L))
        t: (if H < 12 then "a" else "p")
        tt: (if H < 12 then "am" else "pm")
        T: (if H < 12 then "A" else "P")
        TT: (if H < 12 then "AM" else "PM")
        Z: (if utc then "UTC" else (String(date).match(timezone) or [""]).pop().replace(timezoneClip, ""))
        o: ((if o > 0 then "-" else "+")) + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4)
        S: ["th", "st", "nd", "rd"][(if d % 10 > 3 then 0 else (d % 100 - d % 10 isnt 10) * d % 10)]

      mask.replace token, ($0) ->
        (if $0 of flags then flags[$0] else $0.slice(1, $0.length - 1))

    inner._dateFormat(date, mask, utc)

  get_obj_keys: (obj, keys) ->
    keys = new Array()
    for i of obj
      keys.push i if obj.hasOwnProperty(i)
    keys

helper = new Helper
