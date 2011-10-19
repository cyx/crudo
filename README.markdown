# crudo

_n._ A light-weight CRUD generator for Cuba using Mote.

## Description

Useful for quickly creating admin backends.

## Usage

Let's assume you have some kind of model.

``` ruby
class Article < Sequel::Model
end
```

In your main Cuba app file, define a form using `CRUD`:

``` ruby
Cuba.send :include, Crudo

Cuba.define do
  on "articles" do
    run(CRUD(Article, "/articles") do |config|
      config.textfield :title
      config.textarea  :description
      config.dropdown  :status, [["Draft", "draft"], ["Done", "done"]]
    end)
  end
end
```

Now, create a simple template in `views/article/list.mote`:

``` erb
Listing all articles

<a href="/articles/add">Add an Article</a>

% records.each do |record|
  {{ record.title }}
% end
```