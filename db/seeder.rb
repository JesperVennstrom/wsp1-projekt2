require 'sqlite3'

class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS todos')
    db.execute('DROP TABLE IF EXISTS users')
  end
  def self.create_tables
    db.execute('CREATE TABLE todos(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                description TEXT,
                completed BOOLEAN DEFAULT FALSE,
                user_id INTEGER NOT NULL)')
    db.execute('CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                password TEXT NOT NULL)')
  end
  def self.populate_tables
    db.execute('INSERT INTO todos (title, description, completed, user_id) VALUES ("Gymma", "Gå till gymmet och kör ett bröstpass", 1, 1)')
    db.execute('INSERT INTO todos (title, description, user_id) VALUES ("Laga mat", "Stek fläskytterfile och grädda potatisgratäng", 1)')
    db.execute('INSERT INTO todos (title, description, user_id) VALUES ("Städa", "Dammsuga och torka golven", 1)')
    db.execute('INSERT INTO todos (title, description, user_id) VALUES ("Läsa", "Läs ut boken om Steve Jobs", 1)')

    db.execute('INSERT INTO users (username, password) VALUES ("admin", "admin")')
    
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