require 'sqlite3'

class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS todos')
  end
  def self.create_tables
    db.execute('CREATE TABLE todos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                description TEXT,
                completed BOOLEAN DEFAULT FALSE)')
  end
  def self.populate_tables
    db.execute('INSERT INTO todos (title, description, completed) VALUES ("Gymma", "Gå till gymmet och kör ett bröstpass", 1)')
    db.execute('INSERT INTO todos (title, description) VALUES ("Laga mat", "Stek fläskytterfile och grädda potatisgratäng")')
    db.execute('INSERT INTO todos (title, description) VALUES ("Städa", "Dammsuga och torka golven")')
    db.execute('INSERT INTO todos (title, description) VALUES ("Läsa", "Läs ut boken om Steve Jobs")')
  end
  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/todos.sqlite')
    @db.results_as_hash = true
    @db
  end

end

Seeder.seed!