#
#
#

xml["atom"].entry {
  xml["atom"].id
  xml["atom"].published
  xml["atom"].updated
  xml["atom"].title
  xml["atom"].author {
    xml["atom"].name
    xml["atom"].uri
    xml["activity"]."object-type"
  }
  xml["activity"].verb
  xml["activity"].object
}
