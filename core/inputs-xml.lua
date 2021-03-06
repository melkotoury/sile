SILE.inputs.XML = {
  order = 1,
  appropriate = function(fn, sniff)
    return (fn:match("xml$") or sniff:match("<"))
  end,
  process = function (fn)
    local lom = require("lomwithpos")
    local fh = io.open(fn)
    local t, err = lom.parse(fh:read("*all"))
    if t == nil then
      error(err)
    end
    local root = SILE.documentState.documentClass == nil
    if root then
      if not(t.tag == "sile") then
        SU.error("This isn't a SILE document!")
      end
      SILE.inputs.common.init(fn, t)
    end
    SILE.currentCommand = t
    if SILE.Commands[t.tag] then
      SILE.Commands[t.tag](t.attr,t)
    else
      SILE.process(t)
    end
    if root and not SILE.preamble then
      SILE.documentState.documentClass:finish()
    end
  end,
}