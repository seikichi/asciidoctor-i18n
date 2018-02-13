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
        src.lines = translator.translate(concatenated_lines(src))
      end

      def process_table(src, translator)
        (src.rows.head + src.rows.body).each do |row|
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

      # concat continuous lines if no hard line break exists
      def concatenated_lines(src)
        return src.lines if skip_concatenate?(src)
        result = [src.lines.first]
        src.lines.drop(1).each do |line|
          if line_break?(src, result.last, line)
            result.push(line)
          else
            result[-1] = result[-1] + " #{line}"
          end
        end
        result
      end

      def skip_concatenate?(src)
        src.lines.empty? || src.content_model != :simple
      end

      def line_break?(src, prev_line, next_line)
        content = src.apply_subs([prev_line, next_line].join("\n"), src.subs)
        content.include?('<br>') && !content.strip.end_with?('<br>')
      end
    end
  end
end
