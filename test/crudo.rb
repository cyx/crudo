require_relative "helper"

class Article < Struct.new(:id, :title)
  def new?
    id.nil?
  end

  def update(atts)
    self.title = atts[:title]
  end

  def to_s
    title
  end
end

Cuba.use Rack::Session::Cookie

Cuba.define {
  on "articles" do
    run(CRUD(Article, "/articles") { |c|
      c.textfield :title
    })
  end
}

scope do
  test "listing" do
    override(Article, all: [
      Article.new(1, "Foo"),
      Article.new(2, "Bar"),
      Article.new(3, "Baz")
    ])

    visit "/articles"

    assert has_css?("#article_1", text: "Foo")
    assert has_css?("#article_2", text: "Bar")
    assert has_css?("#article_3", text: "Baz")
  end

  test "create" do
    visit "/articles/add"

    fill_in "article[title]", with: "Title"
    click_button "Save"

    assert has_content?("You have successfully saved Title.")
  end

  test "update" do
    override(Article, :[] => Article.new(1, "Old Title"))

    visit "/articles/1"
    assert has_css?('input[name="article[title]"][value="Old Title"]')

    fill_in "article[title]", with: "New Title"
    click_button "Save"

    assert has_content?("You have successfully saved New Title.")
  end
end

scope do
  test "form html helpers" do
    visit "/articles/1"

    fill_in "article[title]", with: "New Title"
    click_button "Save"

    assert has_content?("You have successfully saved New Title.")
  end
end