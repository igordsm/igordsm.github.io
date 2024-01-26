import std/jsfetch
import std/[asyncjs, jsconsole, jsformdata, jsheaders]
from std/jsffi import JsObject
import xmlparser
import xmltree

type Bookmark = object
  mastoLink*: string
  content*: string

proc loadBookmarksFromMastodon() {.async.} =
  let r = await fetch "https://fosstodon.org/@igordsm.rss".cstring
  let t = await r.text()
  let xx = parseXml($t)

  for bookmark in xx.findAll("item"):
    var m: Bookmark
    for childTag in bookmark:
      case childTag.rawTag:
        of "link":
          m.mastoLink = childTag.innerText
          
    console.log($m)
    console.log("---------".cstring)

discard loadBookmarksFromMastodon()
