# coding: utf-8

require 'asciidoctor/extensions'

require 'asciidoctor/i18n/processor'
require 'asciidoctor/i18n/version'

Asciidoctor::Extensions.register do
  treeprocessor Asciidoctor::I18n::Processor
end
