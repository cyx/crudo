require_relative "helper"

class Article < Ohm::Model
  attribute :title

  def validate
    assert_present :title
  end

  def to_s
    title
  end
end

Cuba.plugin Cuba::Mote
Cuba.plugin Crudo
Cuba.set :views, "./test/views"
Cuba.set :localized_errors, { not_present: "%{field} is required." }

Cuba.define do
  on "articles" do
    run(CRUD(Article, "/articles") { |config|
      config.textfield :title
    })
  end
end

scope do
  test "listing" do
    visit "/articles"
    assert has_content?("No Articles yet")

    article = Article.create(title: "First Article")

    visit "/articles"
    assert has_css?("ul > li", text: "First Article")
  end

  test "adding articles" do
    visit "/articles/add"

    fill_in "article[title]", with: "The Main Article"
    click_button "Save"

    assert has_content?("Edit Article: The Main Article")
  end

  test "updating an article" do
    article = Article.create(title: "First Article")

    visit "/articles/#{article.id}"

    fill_in "article[title]", with: "The Main Article"
    click_button "Save"

    assert has_content?("Edit Article: The Main Article")
  end

  test "deleting an article" do
    article = Article.create(title: "First Article")

    visit "/articles"

    within "#article_#{article.id}" do
      click_button "Delete"
    end

    assert has_content?("No Articles yet")
  end

  test "deleting an article using XHR" do
    article = Article.create(title: "First Article")

    xhr :delete, "/articles/#{article.id}"

    assert_equal JSON.dump(redirect: "/articles"), page.source
  end

  test "validation errors" do
    visit "/articles/add"

    fill_in "article[title]", with: ""
    click_button "Save"

    assert has_css?("span.error > em", text: "Title is required.")
  end
end