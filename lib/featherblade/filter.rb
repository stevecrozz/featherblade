module Featherblade
  module Filter
    def featherblade(css)
      Featherblade.record_css(css)
      css
    end
  end
end
