# coding: utf-8

require 'test/unit'
require 'asciidoctor/i18n/processor'
require 'gettext/po'
require 'asciidoctor'

class TestParagraph < Test::Unit::TestCase
  test 'paragraph is translated correctly' do
    po = GetText::PO.new
    po['Hello, world!'] = 'こんにちは、世界！'
    document = Asciidoctor.load('Hello, world!')
    Asciidoctor::I18n::Processor.new.process_document(document, po)

    para = document.find_by(context: :paragraph).first
    assert { para && para.content == 'こんにちは、世界！' }
  end
end
