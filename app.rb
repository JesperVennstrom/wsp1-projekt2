require 'sinatra'
require 'securerandom'

class App < Sinatra::Base
    
    configure do
        enable :sessions
        set :session_secret, SecureRandom.hex(64)
    end

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
        if !session[:user]
            erb(:login)
        else
            redirect('/todos')
        end
    end
    post '/login' do
        user = db.execute('SELECT * FROM users WHERE username = ?', [params[:username]]).first

        if user && user['password'] == params[:password]
            session[:user] = user
        else 
            status 401
            @error = 'Fel användarnamn eller lösenord'
        end
        redirect('/login')
    end
    get '/todos' do
        @todos = db.execute('SELECT * FROM todos WHERE user_id = ?', [session[:user]['id']])

        erb(:index)
    end
    post '/todos' do
        db.execute('INSERT INTO todos (title, description, user_id) VALUES (?, ?, ?)', [params[:title], params[:description], session[:user]['id']])
        redirect('/todos')
    end
    post '/todos/:id/delete' do
        db.execute('DELETE FROM todos WHERE id = ?', [params[:id]])
        redirect('/todos')
    end
    post '/todos/:id/:completed' do |id, completed|
        if completed == '0' 
            db.execute('UPDATE todos SET completed = 1 WHERE id = ?', [params[:id]])
        elsif completed == '1'
            db.execute('UPDATE todos SET completed = 0 WHERE id = ?', [params[:id]])
        end
        redirect('/todos')
    end

    post '/logout' do
        session.clear
        redirect('/login')
    end
    get '/register' do
        erb(:register)
    end
    post '/register' do
        db.execute('INSERT INTO users (username, password) VALUES (?, ?)', [params[:username], params[:password]])
        redirect('/login')
    end

end
