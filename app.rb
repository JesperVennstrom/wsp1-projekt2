class App < Sinatra::Base

    def db
        return @db if @db
  
        @db = SQLite3::Database.new("db/todos.sqlite")
        @db.results_as_hash = true
  
        return @db
    end
    get '/' do
        @todos = db.execute('SELECT * FROM todos')
        erb(:"index")
    end

end
