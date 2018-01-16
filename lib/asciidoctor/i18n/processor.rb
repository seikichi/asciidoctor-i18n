# coding: utf-8

require 'gettext'
require 'gettext/po'
require 'gettext/po_parser'
require 'asciidoctor/extensions'

module Asciidoctor
  module I18n
    class Processor < Extensions::Treeprocessor
      def process(document)
        language = document.attr(:language, ENV['LANG'][0..1])
        po_path = File.join(document.attr(:po_directory, 'po_directory'), "#{language}.po")
        old_po = GetText::PO.new
        new_po = GetText::PO.new
        old_po = GetText::POParser.new.parse(File.read(po_path), old_po) if File.exist?(po_path)
        process_document(document, old_po, new_po)
        File.write(po_path, new_po.to_s)
      end

      def process_document(document, old_po, new_po)
        document.find_by.each do |src|
          process_abstract_block(src, old_po, new_po) if src.is_a?(Asciidoctor::AbstractBlock)
          process_block(src, old_po, new_po) if src.is_a?(Asciidoctor::Block)
          process_table(src, old_po, new_po) if src.is_a?(Asciidoctor::Table)
          process_list_item(src, old_po, new_po) if src.is_a?(Asciidoctor::ListItem)
        end
      end

      private

      def process_table(src, old_po, new_po)
        src.rows.body.each do |row|
          row.each do |cell|
            process_table_cell(cell, old_po, new_po)
          end
        end
      end

      def process_list_item(src, old_po, new_po)
        text = src.instance_variable_get(:@text)
        value = msgstr(text, old_po, new_po)
        src.text = value if value != ''
      end

      def process_table_cell(src, old_po, new_po)
        if src.style != :asciidoc
          text = src.instance_variable_get(:@text)
          value = msgstr(text, old_po, new_po)
          src.text = value if value != ''
        else
          process_document(src.inner_document, old_po, new_po)
        end
      end

      def process_block(src, old_po, new_po)
        text = src.lines.join("\n")
        value = msgstr(text, old_po, new_po)
        src.lines = value != '' ? value.split("\n") : src.lines
      end

      def process_abstract_block(src, old_po, new_po)
        return unless src.title
        value = msgstr(src.title, old_po, new_po)
        src.title = value if value != ''
      end

      def msgstr(key, old_po, new_po)
        new_po[key] = old_po.has_key?(key) ? old_po[key].msgstr : ''
        new_po[key].msgstr || ''
      end
    end
  end
end
