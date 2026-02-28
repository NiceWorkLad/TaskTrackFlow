class MarkdownRenderer
  def self.render(text)
    html = Commonmarker.to_html(text || "", options: {
      extension: {
        strikethrough: true,
        table: true,
        autolink: true,
        tasklist: true,
        blockquote: true,
        fenced_code: true,
        footnotes: true,
        math: true,
        tagfilter: true,
        table_captions: true,
        table_alignment: true,
        table_cell_line_breaks: true,
        table_headerless: true,
        table_rowspan: true,
        table_colspan: true
      }
    })

    Sanitize.fragment(html, Sanitize::Config::RELAXED)
  end
end
