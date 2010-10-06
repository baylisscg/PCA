content_for :head do
  xml.title "Testing" 
end

xml.section( "id" => "test") {

xml.text! "Hi There"
  xml.table {
    xml.tr {
      xml.td { xml.text! "Subject DN"  }
      xml.td { xml.text! @cert.subject_dn  }
    }
    xml.tr {
      xml.td { xml.text! "Issuer DN"  }
      xml.td { xml.text! @cert.issuer_dn  }
    }
    xml.tr {
      xml.td { xml.text! "Valid From"  }
      xml.td { xml.text! @cert.valid_from.to_s  }
    }
    xml.tr {
      xml.td { xml.text! "Valid To"  }
      xml.td { xml.text! @cert.valid_to.to_s  }
    }
  }
}
