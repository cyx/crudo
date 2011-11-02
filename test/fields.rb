require_relative "helper"

class Article < Ohm::Model
  attribute :title
  attribute :description
  attribute :status
  attribute :date_posted
  attribute :photo

  def to_s
    title
  end
end

Cuba.plugin Cuba::Mote
Cuba.plugin Crudo
Cuba.set :views, "./test/formviews"
Cuba.set :localized_errors, { not_present: "%{field} is required." }
Cuba.use Rack::Session::Cookie

Cuba.define do
  on "articles" do
    run(CRUD(Article, "/articles") { |config|
      config.dropdown  :status, lambda { [["Good", "1"], ["Bad", "-1"]] }
      config.textfield :title
      config.textarea  :description
      config.datefield :date_posted

      config.saved_message = "All systems go: %s"
    })
  end
end

scope do
  test do
    visit "/articles/add"

    assert has_css?("input.date[type=text][name='article[date_posted]']")

    fill_in "article[title]", with: "The Main Article"
    fill_in "article[description]", with: "Lorem ipsum dolor sit amet"
    fill_in "article[date_posted]", with: "2011-10-31"
    select "Good", from: "article[status]"
    select "Bad", from: "article[status]"
    click_button "Save"

    assert has_content?("All systems go: The Main Article")
  end
end