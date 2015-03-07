require 'fileutils'
require 'pathname'
require 'nokogiri'
require 'css_parser'
require 'set'

module Featherblade
  @css = {}

  def self.record_css(css)
    return if @css[css]

    parser = CssParser::Parser.new
    parser.add_block!(css.dup)
    @css[css] = parser.instance_variable_get(:@rules).map { |r| r[:rules] }
  end

  def self.strip_selector(selector)
    selector = selector.gsub(/^@.*/, '') # @-webkit-keyframes ...
    selector = selector.gsub(/:.*/, '')  # input#x:nth-child(2):not(#z.o[type='file'])
    selector.strip
  end

  def self.find_selectors(css)
    selectors = Set.new

    @css[css][:parser].each_selector do |selector, _, _|
      next if selectors.include?(strip_selector(selector))
      selectors << selector
    end

    selectors
  end

  def self.replacement(html, rules)
    doc = Nokogiri::HTML(html)
    matched = Set.new

    rules.each do |rule|
      rule.selectors.each do |selector|
        matched << rule unless doc.css(strip_selector(selector)).empty?
      end
    end

    matched.map(&:to_s).join
  end

  def self.with_measurement(page, &block)
    oldbytes = page.output.bytesize
    yield
    newbytes = page.output.bytesize
    diff = oldbytes - newbytes

    shaved = sprintf("%i bytes (%2.1f%%)", diff, diff * 100 / oldbytes.to_f)
    Jekyll.logger.info "Featherblade: shaved #{shaved} from #{page.path}"
  end

  def self.scrub(page)
    with_measurement(page) do
      @css.each do |block, rules|
        page.output.gsub!(block) { self.replacement(page.output, rules) }
      end
    end
  end

  module Filter
    def scrub_css(css)
      Featherblade.record_css(css)
      css
    end
  end
end

Liquid::Template.register_filter(Featherblade::Filter)

Jekyll::Hooks.register Jekyll::Page, :post_render, &Featherblade.method(:scrub)
