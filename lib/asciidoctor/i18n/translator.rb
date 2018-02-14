# coding: utf-8

require 'fileutils'
require 'gettext'
require 'gettext/po'
require 'gettext/po_parser'

module Asciidoctor
  module I18n
    class Translator
      def initialize(attributes)
        @attributes = attributes
        unless old_po
          raise ArgumentError, 'missing attributes: language' unless language
          raise ArgumentError, 'missing attributes: po-directory' unless po_directory
        end

        @new_po = create_new_po
        @old_po = load_old_po
      end

      def translate(source)
        return source if no_translations?

        if source.is_a?(String)
          translate_string(source)
        elsif source.is_a?(Array)
          translate_lines(source)
        else
          raise ArgumentError, "invalid argument for #translate method: #{source.inspect}"
        end
      end

      def save
        return if no_update?
        FileUtils.mkdir_p(po_directory)
        File.write(po_path, @new_po.to_s(max_line_width: -1))
      end

      private

      def translate_string(source)
        return source if skip?(source)
        @new_po[source] = @old_po.has_key?(source) ? @old_po[source].msgstr : ''
        translated = @new_po[source].msgstr || ''
        translated != '' ? translated : source
      end

      def translate_lines(lines)
        source = lines.join("\n")
        translate_string(source).split("\n")
      end

      def skip?(source)
        source == '' || !filter.match(source)
      end

      def no_update?
        @attributes['no-update']
      end

      def no_translations?
        @attributes['no-translations']
      end

      def po_directory
        @attributes['po-directory']
      end

      def language
        @attributes['language']
      end

      def old_po
        @attributes['old-po']
      end

      def filter
        @filter ||=
          begin
            if @attributes['msgid-filter']
              Regexp.new(@attributes['msgid-filter'])
            else
              /.*/
            end
          end
      end

      def po_path
        File.join(po_directory, "#{language}.po")
      end

      def create_new_po
        po = GetText::PO.new
        po[''] = "Content-Type: text/plain; charset=UTF-8\n"
        po
      end

      def load_old_po
        if old_po
          old_po
        elsif File.exist?(po_path)
          GetText::POParser.new.parse(File.read(po_path), GetText::PO.new)
        else
          GetText::PO.new
        end
      end
    end
  end
end
