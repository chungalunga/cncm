	ProductionPosition.delete_all
   Project.delete_all
   Ident.delete_all

   production_line1 = ProductionPosition.create(description: 'Rezkanje');
	production_line2 = ProductionPosition.create(description: 'Vrtanje');
	production_line3 = ProductionPosition.create(description: 'Struženje');
	production_line4 = ProductionPosition.create(description: 'Ročna dela');
	production_line5 = ProductionPosition.create(description: 'Merilni protokol');

   project1 = Project.create(description: 'material 267', customer: 'Akrapovič',time_start: (DateTime.now.to_time - rand(100).hours).to_datetime,time_end: (DateTime.now.to_time + rand(100).hours).to_datetime, color: 'rgb(95,158,160)')
   project3 = Project.create(description: 'lorem ipsum', customer: 'SAVA',time_start: (DateTime.now.to_time - rand(100).hours).to_datetime,time_end: (DateTime.now.to_time + rand(100).hours).to_datetime, color: 'rgb(50,205,50)')
   project2 = Project.create(description: 'dummy text dummy text', customer: 'ISKRA',time_start: (DateTime.now.to_time - rand(100).hours).to_datetime,time_end: (DateTime.now.to_time + rand(100).hours).to_datetime, color: 'rgb(255,140,0)')

   #project2 = Project.create(description: 'Project 2', customer: 'customer2',time_start: DateTime.strptime("01/03/2015 06:00", "%d/%m/%Y %H:%M"),time_end: DateTime.strptime("02/3/2015 17:00", "%d/%m/%Y %H:%M"))
   #project3 = Project.create(description: 'Project 3', customer: 'customer1',time_start: (DateTime.now - (DateTime.current.wday)) , time_end: ((DateTime.now.to_time + 72.hours).to_datetime))

   Ident.create(ident_id: "R9388392", name: 'Ident1', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color,  project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 2, priority: 5)
    Ident.create(ident_id: "Z8287286", name: 'Ident4', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color, project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 8, priority: 2)

   Ident.create(ident_id: "JSOU83", name: 'The damage ', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "J3992U", name: 'Its request grows.', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "R9388392", name: 'Ident1', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color,  project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 2, priority: 5)
    Ident.create(ident_id: "Z8287286", name: 'Ident4', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color, project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 8, priority: 2)

   Ident.create(ident_id: "JSOU83", name: 'The damage ', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "J3992U", name: 'Its request grows.', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "R9388392", name: 'Ident1', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color,  project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 2, priority: 5)
    Ident.create(ident_id: "Z8287286", name: 'Ident4', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color, project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 8, priority: 2)

   Ident.create(ident_id: "JSOU83", name: 'The damage ', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "J3992U", name: 'Its request grows.', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "R9388392", name: 'Ident1', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color,  project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 2, priority: 5)
    Ident.create(ident_id: "Z8287286", name: 'Ident4', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color, project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 8, priority: 2)

   Ident.create(ident_id: "JSOU83", name: 'The damage ', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "J3992U", name: 'Its request grows.', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "R9388392", name: 'Ident1', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color,  project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 2, priority: 5)
    Ident.create(ident_id: "Z8287286", name: 'Ident4', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color, project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 8, priority: 2)

   Ident.create(ident_id: "JSOU83", name: 'The damage ', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "J3992U", name: 'Its request grows.', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "R9388392", name: 'Ident1', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color,  project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 2, priority: 5)
    Ident.create(ident_id: "Z8287286", name: 'Ident4', weight: 59.00, programiranje: 72.5,status: "new",color: project1.color, project_id: project1.id, production_line_text: production_line1.description, estimated_hours: 8, priority: 2)

   Ident.create(ident_id: "JSOU83", name: 'The damage ', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)
   Ident.create(ident_id: "J3992U", name: 'Its request grows.', weight: 59.00, programiranje: 72.5,status: "new",color: project2.color, project_id: project2.id, production_line_text: production_line1.description, estimated_hours: 9, priority: 3)

