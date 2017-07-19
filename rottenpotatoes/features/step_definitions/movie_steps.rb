# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(title: movie["title"], rating: movie["rating"], director: movie["director"],
    description: movie["description"], release_date: movie["release_date"])
  end
  # fail "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
# When /I fill in "([^.]*)" with "([^.]*)"$/ do |input, name|
#   puts "ayyyyyyyyyyyyyyyyyyyyyyy"
#   puts input
#   puts name
#   puts "ayyyyyyyyyyyyyyyyyyyyyyy"

Then /^the director of "(.*)" should be "(.*)"$/ do |title, director|
  Movie.find_by(:title => title).director.should == director
end
  
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  movie_list = []
  all("tr").each do |tr|
    if tr.has_content?(e1)
      movie_list.push(e1)
    elsif tr.has_content?(e2)
      movie_list.push(e2)
    end
  end
  e1_index = movie_list.rindex(e1)
  e2_index = movie_list.rindex(e2)

  e1_index.should_not be_nil 
  e2_index.should_not be_nil 
  e1_comes_before_e2 = e1_index < e2_index
  e1_comes_before_e2.should == true
end

# When /^I should see "'(.*)' has no director info"$/ do |movie|
# end
# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  # fail "Unimplemented"
  ratings = rating_list.split(',')
  ratings.each do |rating|
    if uncheck
      uncheck("ratings_" + rating)
    else
      check("ratings_" + rating)
    end
  end
end

Then /I should see all of the movies/ do
  # Make sure that all the movies in the app are visible in the table
  all_rows = page.find(:css, 'table#movies').all(:css, 'tr')
  all_rows.size.should == Movie.count + 1 
  # +1 because of header
  Movie.all.each do |movie|
    page.should have_content(movie.title)
    
  end
end
