instructors = %w/
  Adri
  Barry
  Bobby
  Emma
  Felix
  Gaz
  Gordon
  Lionel
  Maddy
  Martin
  Mike
  Shannon
  Taz
/

instructors.each do |name|
  Person.find_or_create_by(name: name)
end
