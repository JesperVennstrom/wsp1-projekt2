class App < Sinatra::Base

    def db
        return @db if @db
  
        @db = SQLite3::Database.new("db/todos.sqlite")
        @db.results_as_hash = true
  
        return @db
    end
    get '/' do
        redirect('/login')
    end
    get '/login' do
        erb(:login)
    end
    get '/todos' do
        @todos = db.execute('SELECT * FROM todos')
        erb(:index)
    end
    post '/todos' do
        db.execute('INSERT INTO todos (title, description) VALUES (?, ?)', [params[:title], params[:description]])
        redirect('/')
    end
    post '/todos/:id/delete' do
        db.execute('DELETE FROM todos WHERE id = ?', [params[:id]])
        redirect('/')
    end
    post '/todos/:id/:completed' do |id, completed|
        if completed == '0' 
            db.execute('UPDATE todos SET completed = 1 WHERE id = ?', [params[:id]])
        elsif completed == '1'
            db.execute('UPDATE todos SET completed = 0 WHERE id = ?', [params[:id]])
        end
        redirect('/')
    end

end
