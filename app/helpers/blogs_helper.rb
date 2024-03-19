# frozen_string_literal: true

module BlogsHelper
  def format_content(blog)
    h(safe_join(blog.content.split("\n"), tag.br))
  end
end
