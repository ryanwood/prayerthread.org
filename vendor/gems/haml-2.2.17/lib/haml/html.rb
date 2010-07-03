require File.dirname(__FILE__) + '/../haml'

require 'haml/engine'
require 'rubygems'
require 'cgi'

module Haml
  class HTML
    # A module containing utility methods that every Hpricot node
    # should have.
    module Node
      # Returns the Haml representation of the given node.
      #
      # @param tabs [Fixnum] The indentation level of the resulting Haml.
      # @option options (see Haml::HTML#initialize)
      def to_haml(tabs, options)
        parse_text(self.to_s, tabs)
      end

      private

      def tabulate(tabs)
        '  ' * tabs
      end

      def attr_hash
        attributes.to_hash
      end

      def parse_text(text, tabs)
        text.strip!
        text.gsub!('#{', '\#{') #'
        if text.empty?
          String.new
        else
          lines = text.split("\n")

          lines.map do |line|
            line.strip!
            "#{tabulate(tabs)}#{'\\' if Haml::Engine::SPECIAL_CHARACTERS.include?(line[0])}#{line}\n"
          end.join
        end
      end
    end
  end
end

# Haml monkeypatches various Hpricot classes
# to add methods for conversion to Haml.
module Hpricot
  # @see Hpricot
  module Node
    include Haml::HTML::Node
  end

  # @see Hpricot
  class BaseEle
    include Haml::HTML::Node
  end
end

require 'hpricot'

module Haml
  # Converts HTML documents into Haml templates.
  # Depends on [Hpricot](http://github.com/whymirror/hpricot) for HTML parsing.
  #
  # Example usage:
  #
  #     Haml::Engine.new("<a href='http://google.com'>Blat</a>").render
  #       #=> "%a{:href => 'http://google.com'} Blat"
  class HTML
    # @param template [String, Hpricot::Node] The HTML template to convert
    # @option options :rhtml [Boolean] (false) Whether or not to parse
    #   ERB's `<%= %>` and `<% %>` into Haml's `=` and `-`
    # @option options :xhtml [Boolean] (false) Whether or not to parse
    #   the HTML strictly as XHTML
    def initialize(template, options = {})
      @options = options

      if template.is_a? Hpricot::Node
        @template = template
      else
        if template.is_a? IO
          template = template.read
        end

        if @options[:rhtml]
          match_to_html(template, /<%=(.*?)-?%>/m, 'loud')
          match_to_html(template, /<%-?(.*?)-?%>/m,  'silent')
        end

        method = @options[:xhtml] ? Hpricot.method(:XML) : method(:Hpricot)
        @template = method.call(template.gsub('&', '&amp;'))
      end
    end

    # Processes the document and returns the result as a string
    # containing the Haml template.
    def render
      @template.to_haml(0, @options)
    end
    alias_method :to_haml, :render

    TEXT_REGEXP = /^(\s*).*$/

    # @see Hpricot
    class ::Hpricot::Doc
      # @see Haml::HTML::Node#to_haml
      def to_haml(tabs, options)
        (children || []).inject('') {|s, c| s << c.to_haml(0, options)}
      end
    end

    # @see Hpricot
    class ::Hpricot::XMLDecl
      # @see Haml::HTML::Node#to_haml
      def to_haml(tabs, options)
        "#{tabulate(tabs)}!!! XML\n"
      end
    end

    # @see Hpricot
    class ::Hpricot::CData
      # @see Haml::HTML::Node#to_haml
      def to_haml(tabs, options)
        "#{tabulate(tabs)}:cdata\n#{parse_text(self.content, tabs + 1)}"
      end
    end

    # @see Hpricot
    class ::Hpricot::DocType
      # @see Haml::HTML::Node#to_haml
      def to_haml(tabs, options)
        attrs = public_id.nil? ? ["", "", ""] :
          public_id.scan(/DTD\s+([^\s]+)\s*([^\s]*)\s*([^\s]*)\s*\/\//)[0]
        if attrs == nil
          raise Exception.new("Invalid doctype")
        end

        type, version, strictness = attrs.map { |a| a.downcase }
        if type == "html"
          version = ""
          strictness = "strict" if strictness == ""
        end

        if version == "1.0" || version.empty?
          version = nil
        end

        if strictness == 'transitional' || strictness.empty?
          strictness = nil
        end

        version = " #{version.capitalize}" if version
        strictness = " #{strictness.capitalize}" if strictness

        "#{tabulate(tabs)}!!!#{version}#{strictness}\n"
      end
    end

    # @see Hpricot
    class ::Hpricot::Comment
      # @see Haml::HTML::Node#to_haml
      def to_haml(tabs, options)
        "#{tabulate(tabs)}/\n#{parse_text(self.content, tabs + 1)}"
      end
    end

    # @see Hpricot
    class ::Hpricot::Elem
      # @see Haml::HTML::Node#to_haml
      def to_haml(tabs, options)
        output = "#{tabulate(tabs)}"
        if options[:rhtml] && name[0...5] == 'haml:'
          return output + send("haml_tag_#{name[5..-1]}", CGI.unescapeHTML(self.inner_text))
        end

        output += "%#{name}" unless name == 'div' &&
          (static_id?(options) || static_classname?(options))

        if attr_hash
          if static_id?(options)
            output += "##{attr_hash['id']}"
            remove_attribute('id')
          end
          if static_classname?(options)
            attr_hash['class'].split(' ').each { |c| output += ".#{c}" }
            remove_attribute('class')
          end
          output += haml_attributes(options) if attr_hash.length > 0
        end

        (self.children || []).inject(output + "\n") do |output, child|
          output + child.to_haml(tabs + 1, options)
        end
      end

      private
      
      def dynamic_attributes
        @dynamic_attributes ||= begin
          Haml::Util.map_hash(attr_hash) do |name, value|
            next if value.empty?
            full_match = nil
            ruby_value = value.gsub(%r{<haml:loud>\s*(.+?)\s*</haml:loud>}) do
              full_match = $`.empty? && $'.empty?
              CGI.unescapeHTML(full_match ? $1: "\#{#{$1}}")
            end
            next if ruby_value == value
            [name, full_match ? ruby_value : %("#{ruby_value}")]
          end
        end
      end

      def haml_tag_loud(text)
        "= #{text.gsub(/\n\s*/, ' ').strip}\n"
      end

      def haml_tag_silent(text)
        text.split("\n").map { |line| "- #{line.strip}\n" }.join
      end

      def static_attribute?(name, options)
        attr_hash[name] and !dynamic_attribute?(name, options)
      end
      
      def dynamic_attribute?(name, options)
        options[:rhtml] and dynamic_attributes.key?(name)
      end
      
      def static_id?(options)
        static_attribute?('id', options)
      end
      
      def static_classname?(options)
        static_attribute?('class', options)
      end

      # Returns a string representation of an attributes hash
      # that's prettier than that produced by Hash#inspect
      def haml_attributes(options)
        attrs = attr_hash.map do |name, value|
          value = dynamic_attribute?(name, options) ? dynamic_attributes[name] : value.inspect
          name = name.index(/\W/) ? name.inspect : ":#{name}"
          "#{name} => #{value}"
        end
        "{ #{attrs.join(', ')} }"
      end
    end

    private

    def match_to_html(string, regex, tag)
      string.gsub!(regex) do
        "<haml:#{tag}>#{CGI.escapeHTML($1)}</haml:#{tag}>"
      end
    end
  end
end
