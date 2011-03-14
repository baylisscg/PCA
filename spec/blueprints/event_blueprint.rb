#
#
#

Sham.datestamp(:unique=>false) { Time.now }

Event.blueprint do

  action {"action"}
  datestamp 

end
