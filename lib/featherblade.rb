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
    @css[css] = parser.rules_by_media_query
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

  def self.replacement(html, rules_by_media_query)
    doc = Nokogiri::HTML(html)
    ret = ''

    rules_by_media_query.each do |media_query, rules|
      matched_rules = Set.new

      rules.each do |rule|
        matched_selectors = Set.new

        rule.selectors.each do |selector|
          matched_selectors << selector unless doc.css(strip_selector(selector)).empty?
        end

        next if matched_selectors.empty?
        new_rule = rule.dup
        new_rule.instance_variable_set(:@selectors, matched_selectors.to_a)
        matched_rules << new_rule
      end

      next if matched_rules.empty?

      if media_query == :all
        ret << matched_rules.map(&:to_s).join
      else
        ret << sprintf("@media #{media_query}{%s}", matched_rules.map(&:to_s).join)
      end
    end

    ret
  end

  def self.with_measurement(page, &block)
    oldbytes = page.output.bytesize
    yield
    newbytes = page.output.bytesize
    diff = oldbytes - newbytes

    shaved = sprintf("%i bytes (%2.1f%%)", diff, diff * 100 / oldbytes.to_f)
    Jekyll.logger.info "Featherblade: shaved #{shaved} from #{page.path}"
  end

  def self.shave(page)
    with_measurement(page) do
      @css.each do |block, rules|
        page.output.gsub!(block) { self.replacement(page.output, rules) }
      end
    end
  end

  module Filter
    def featherblade(css)
      Featherblade.record_css(css)
      css
    end
  end
end

Liquid::Template.register_filter(Featherblade::Filter)

Jekyll::Hooks.register Jekyll::Page, :post_render, &Featherblade.method(:shave)
