class MarkdownRenderer
  def self.render(text)
    html = Commonmarker.to_tml(text || "", options: {
      extension: {
        strikethrough: true,
        table: true,
        autolink: true,
        tasklist: true
      }
    })

    Sanitize.fragment(html, Sanitize::Config::RELAXED)
  end
end
