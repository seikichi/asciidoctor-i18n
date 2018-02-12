# coding: utf-8

require 'asciidoctor/extensions'
require_relative 'translator'

module Asciidoctor
  module I18n
    class Processor < Extensions::Treeprocessor
      def process(document)
        translator = Translator.new(document.attributes)
        process_document(document, translator)
        translator.save
      end

      def process_document(document, translator)
        document.find_by.each do |src|
          process_abstract_block(src, translator) if src.is_a?(Asciidoctor::AbstractBlock)
          process_block(src, translator) if src.is_a?(Asciidoctor::Block)
          process_table(src, translator) if src.is_a?(Asciidoctor::Table)
          process_list_item(src, translator) if src.is_a?(Asciidoctor::ListItem)
        end
      end

      private

      def process_abstract_block(src, translator)
        return unless src.title
        src.title = translator.translate(src.title)
      end

      def process_block(src, translator)
        src.lines = translator.translate(src.lines)
      end

      def process_table(src, translator)
        src.rows.body.each do |row|
          row.each do |cell|
            process_table_cell(cell, translator)
          end
        end
      end

      def process_list_item(src, translator)
        src.text = translator.translate(src.instance_variable_get(:@text))
      end

      def process_table_cell(src, translator)
        if src.style != :asciidoc
          src.text = translator.translate(src.instance_variable_get(:@text))
        else
          process_document(src.inner_document, translator)
        end
      end
    end
  end
end
