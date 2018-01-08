# coding: utf-8

require 'gettext'
require 'gettext/po'
require 'gettext/po_parser'
require 'asciidoctor/extensions'

module Asciidoctor
  module I18n
    class Processor < Extensions::Treeprocessor
      def process(document)
        locales = document.attr(:locales, 'locales')
        language = document.attr(:language, ENV['LANG'][0..1])
        po = GetText::POParser.new.parse(File.read(File.join(locales, "#{language}.po")), GetText::PO.new)

        process_document(document, po)
      end

      def process_document(document, po)
        document.find_by.each do |src|
          case src.context
          when :paragraph then process_paragraph(src, po)
          when :section then process_section(src, po)
          when :list_item then process_list_item(src, po)
          when :table then process_table(src, po)
          else puts src.context
          end
        end
      end

      private

      def process_section(src, po)
        return unless po.has_key?(src.title)
        src.title = po[src.title].msgstr
      end

      def process_table(src, po)
        process_section(src, po)

        src.rows.body.each do |row|
          row.each do |cell|
            if cell.style == nil
              process_list_item(cell, po)
            else
              process_document(cell.inner_document, po)
            end
          end
        end
      end

      def process_paragraph(src, po)
        src.lines = src.lines.map do |line|
          po.has_key?(line) ? po[line].msgstr : line
        end
      end

      def process_list_item(src, po)
        text = src.instance_variable_get(:@text)
        return unless po.has_key?(text)
        src.text = po[text].msgstr
      end
    end
  end
end
