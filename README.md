# Features of the Call_Response program
```
This program takes a given URL, breaks it up into sections and returns appropriate data based on the fields provided.

* GET http://localhost:3000/users HTTP/1.1 , will return a list of all the users stored in the db.
* GET http://localhost:3000/users/1 HTTP/1.1, will return the user with id = 1.
* GET http://localhost:3000/users/9999999 HTTP/1.1, will return an error unless their is a user with requested id.
* GET http://localhost:3000/users?first_name=s, will return users with names starting with 's'.
* GET http://localhost:3000/users?limit=10&offset=10, will return 10 users starting with the 10th.
* DELETE http://localhost:3000/users/1, will delete the user with the specified id #.
```

# Do the following to have your own call_response program
* Fork this repo
* Clone this repo
* `rake db:migrate` to run the migration and update the database


## Rundown

```
.
├── Gemfile                   # Details which gems are required by the project
├── Gemfile.lock
├── README.md
├── Rakefile                  # Defines `rake generate:migration` and `db:migrate`
├── bin
│   └── run.rb                # `ruby bin/run.rb` will start the program.
├── config
│   └── database.yml          # Defines the database config
├── console.rb                # `ruby console.rb` starts `pry` with models loaded
├── db
│   ├── dev.sqlite3           # Default location of the database file
│   ├── migrate               # Folder containing generated migrations
│   │   └── 20150601135003_add_user.rb      # Generated migration file
│   └── setup.rb              # `require`ing this file sets up the db connection
└── lib
    ├── all.rb                # Require this file to auto-require _all_ `.rb` files in `lib`
    └── user.rb               # Provides inheritance structure for User table

```
