module ProductionCredits
  elizabethan = Venue.find_or_create_by!(name: "Elizabethan")
  bowmer = Venue.find_or_create_by!(name: "Angus Bowmer")
  Venue.find_or_create_by!(name: "Thomas")
  Venue.find_or_create_by!(name: "The Green Show")
  Venue.find_or_create_by!(name: "Craterian")
  swan = Venue.find_or_create_by!(name: "The Black Swan")

  hamlet = Work.find_or_create_by!(title: "Hamlet") { |work| work.author = "Shakespeare, William" }
  wrinkle = Work.find_or_create_by!(title: "A Wrinkle in Time") { |work| work.author = "Madeleine l'Engle" }

  Production.find_or_create_by!(production_name: "Hamlet 2005") { |p| p.open_on = "2005-04-01"; p.close_on = "2005-10-30"; p.work = hamlet; p.venue = elizabethan }
  Production.find_or_create_by!(production_name: "Hamlet 1968") { |p| p.open_on = "1968-05-07"; p.close_on = "1968-11-01"; p.work = hamlet; p.venue = swan }
  Production.find_or_create_by!(production_name: "A Wrinkle in Time") { |p| p.open_on = "2014-03-14"; p.close_on = "2014-09-15"; p.work = wrinkle; p.venue = bowmer }
end
