# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  description :text
#  duration    :integer
#  image       :string
#  title       :string
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  director_id :integer
#

#1 Using the "validations" feature of ActiveRecord, we can create validation rules that, if are NOT met, will NOT allow the new data to be saved into the database. 
class Movie < ApplicationRecord

#2 Defining our validation: this validation says "If the user does NOT include a director_id -> data will NOT be saved because .save will return FALSE"

#3 Validates format: the first argument -> a Symbol that represents the name of the COLUMN we are declaring constraints for. the second argument -> a Hash that defines the constraints we are applying (built-in). The most common uses are :presence = an input is present. :uniqueness = the value is not duplicated. :numericality -> validates that the value input only has numeric values.

#4 For the three COMMON hashes, the value can be associated with "true" or an INNER hash can be used to further specify constraints (i.e. minimum or maximul values for numericality)
validates(:director_id, { presence: true } )

#Syntax change. Secord argument is still a Hash.
validates(:title, uniqueness: true)

  def director
    my_director_id = self.director_id

    matching_directors = Director.where({ :id => my_director_id })
    
    the_director = matching_directors.at(0)

    return the_director
  end
end

=begin
#5 Use "rails c" to debug. To see why an Instance was NOT saved, we can check using the ActiveRecord attribute "errors": 

Example:
[1] pry(main)> m = Movie.new
=> #<Movie:0x00007f609a317160 id: nil, title: nil, year: nil, duration: nil, description: nil, image: nil, director_id: nil, created_at: nil, updated_at: nil>
[2] pry(main)> m.save
=> false
[3] pry(main)> m.errors
=> #<ActiveModel::Errors [#<ActiveModel::Error attribute=director_id, type=blank, options={}>]>
[4] pry(main)> m.errors.messages
=> {:director_id=>["can't be blank"]}
[5] pry(main)> m.errors.full_messages
=> ["Director can't be blank"]
=end

#6 Most common integiry checks are:
#   a. Make sure a value is present before saving. Especially useful in the case of foreign keys. (use :presence)

#   b. Make sure a value is unique before saving it (i.e. no other rows have the same value in that column, use :uniqueness)

#7 New validations effects (added :uniqueness)

=begin

[1] pry(main)> m = Movie.new
=> #<Movie:0x00007fc5b9603520 id: nil, title: nil, year: nil, duration: nil, description: nil, image: nil, director_id: nil, created_at: nil, updated_at: nil>
[2] pry(main)> m.title = "zebra"
=> "zebra"
[3] pry(main)> m.director_id = 1
=> 1
[4] pry(main)> m.save
  TRANSACTION (0.1ms)  begin transaction
  Movie Exists? (0.5ms)  SELECT 1 AS one FROM "movies" WHERE "movies"."title" = ? LIMIT ?  [["title", "zebra"], ["LIMIT", 1]]
  Movie Create (0.5ms)  INSERT INTO "movies" ("title", "year", "duration", "description", "image", "director_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?, ?)  [["title", "zebra"], ["year", nil], ["duration", nil], ["description", nil], ["image", nil], ["director_id", 1], ["created_at", "2024-02-13 17:04:47.085057"], ["updated_at", "2024-02-13 17:04:47.085057"]]
  TRANSACTION (31.6ms)  commit transaction
=> true
[5] pry(main)> n = Movie.new
=> #<Movie:0x00007fc5bc3f4600 id: nil, title: nil, year: nil, duration: nil, description: nil, image: nil, director_id: nil, created_at: nil, updated_at: nil>
[6] pry(main)> n.title="zebra"
=> "zebra"
[7] pry(main)> n.save
  TRANSACTION (0.1ms)  begin transaction
  Movie Exists? (0.2ms)  SELECT 1 AS one FROM "movies" WHERE "movies"."title" = ? LIMIT ?  [["title", "zebra"], ["LIMIT", 1]]
  TRANSACTION (0.0ms)  rollback transaction
=> false
[8] pry(main)> n.errors.full_messages
=> ["Director can't be blank", "Title has already been taken"]

=end
