# README

## Environment Setup

Before starting, make sure your computer has all the necessary tools to build
the application and that these tools match up with what you'll use in a
production environment. This will ensure that when it comes time to deploy your
project, you'll be able to do so more easily.

### Requirements
- Ruby 2.7.4
- Postgresql

### Install the Latest Ruby Version

Verify which version of Ruby you're running by entering this in the terminal:

```console
$ ruby -v
```

Make sure that the Ruby version you're running is listed in the [supported
runtimes][] by Heroku. At the time of writing, supported versions are 2.6.8,
2.7.4, or 3.0.2. Our recommendation is 2.7.4, but make sure to check the site
for the latest supported versions.

If it's not, you can use `rvm` to install a newer version of Ruby:

```console
$ rvm install 2.7.4 --default
```

You should also install the latest versions of `bundler` and `rails`:

```console
$ gem install bundler
$ gem install rails
```

### Install Postgresql

Heroku requires that you use PostgreSQL for your database instead of SQLite.
PostgreSQL (or just Postgres for short) is an advanced database management
system with more features than SQLite. If you don't already have it installed,
you'll need to set it up.

#### PostgreSQL Installation for WSL

To install Postgres for WSL, run the following commands from your Ubuntu
terminal:

```console
$ sudo apt update
$ sudo apt install postgresql postgresql-contrib libpq-dev
```

Then confirm that Postgres was installed successfully:

```console
$ psql --version
```

Run this command to start the Postgres service:

```console
$ sudo service postgresql start
```

Finally, you'll also need to create a database user so that you are able to
connect to the database from Rails. First, check what your operating system
username is:

```console
$ whoami
```

If your username is "ian", for example, you'd need to create a Postgres user
with that same name. To do so, run this command to open the Postgres CLI:

```console
$ sudo -u postgres -i
```

From the Postgres CLI, run this command (replacing "ian" with your username):

```console
$ createuser -sr ian
```

Then enter `control + d` or type `logout` to exit.

[This guide][postgresql wsl] has more info on setting up Postgres on WSL if you
get stuck.

[postgresql wsl]:
  https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-postgresql

#### Postgresql Installation for OSX

To install Postgres for OSX, you can use Homebrew:

```console
$ brew install postgresql
```

Once Postgres has been installed, run this command to start the Postgres
service:

```console
$ brew services start postgresql
```

#### Start Up App

In order to test this API out I recommend using Postman as all visual examples of each step will be shown below using Postman.

To test this API out I used postman but any service similar to Postman should work. Link to download Postman. https://www.postman.com/downloads/

Once you set up with all of the necessary tools, if you haven't already done so, go ahead and clone this repository into your machine. Then cd into that repository.  Start your PostgresSQL server in a new terminal. Link to blog with instructions on starting and stopping PostgresSQL server https://tableplus.com/blog/2018/10/how-to-start-stop-restart-postgresql-server.html. Once your PostgresSQL server is running, in a different or new terminal create your database with the following command:

```console
$ rails db:create
```

If the database cannot be made due to pending migrations, run the following command:

```console
$ rails db:migrate
```

Start your rails server with the following command. 

```console
$ rails s
```

Open up your Postman service and create a new tab. http://127.0.0.1:3000/ will be your beginning url.
Make a post request to http://127.0.0.1:3000/signup in order to create a user. The body requires a json object with a string for the username and password (there are no requirements for the password). 




Next you need to make a post request to http://127.0.0.1:3000/login with the same json object for the body as the last request.


After that, you are free to make request the following request in order to test out the functionality of the API.


Post request http://127.0.0.1:3000/payers

To create a new payer. Also instead of "payer", I used the variable payer_name.

Post request http://127.0.0.1:3000/transactions 

To post transactions. For this request the user_id is required in the body along with the rest of the information called out in the pdf.
Also instead of "payer", I used the variable payer_name.

Get request http://127.0.0.1:3000/balance 

To get the balance.

Post request http://127.0.0.1:3000/spend

To spend points.




