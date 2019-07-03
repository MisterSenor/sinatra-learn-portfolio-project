# I need to populate this database with some data!


artist_1= Artist.create(name: "Leonardo DaVinci", period: "Italian Renaissance", style: "Humanist", user_id: nil)
work_1_1 = Work.create(name: "Mona Lisa", year_completed: "1504", user_id: nil)

#Can I make seed data?  Will having a "nil" value for user_id throw errors?
patron_1 = Patron.create(name: "Madam Lisa Giacondo", user_id: nil)
patron_1.works << work_1_1
artist_1.works << work_1_1
