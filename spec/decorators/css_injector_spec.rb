# encoding: UTF-8
require_relative '../spec_helper.rb'
require_relative '../../lib/decorators/css_injector.rb'

RSpec.describe CssInjector do
  let(:html) do
    File.read(
      File.expand_path('../fixtures/files/email.html', File.dirname(__FILE__))
    )
  end

  it 'should handle empty css file' do
    injector = CssInjector.new('')
    decorated = injector.decorate(html)

    expect(decorated).to eq(html)
  end

  it 'should inline css with a single tag' do
    injector = CssInjector.new('table{border:1px}')
    decorated = injector.decorate(html)

    expected = html.gsub('<table', '<table style=\'border:1px\'')
    expect(decorated).to eq(expected)
  end

  it 'should inline css with a single tag and multiline definitions' do
    injector = CssInjector.new('table {
border:1px;
color: blue;
}')
    decorated = injector.decorate(html)

    expected = html.gsub('<table', '<table style=\'border:1px;color:blue;\'')
    expect(decorated).to eq(expected)
  end

  it 'should inline css with multiple tags' do
    injector = CssInjector.new('table{border: 1px;color: blue;}
td{padding: 1em;}')
    decorated = injector.decorate(html)

    expected = html.gsub('<table', '<table style=\'border:1px;color:blue;\'')
                   .gsub('<td', '<td style=\'padding:1em;\'')
    expect(decorated).to eq(expected)
  end

  it 'should inline css with multiple tags with overload' do
    injector = CssInjector.new('table{border: 1px;color: blue;}
table,td{padding: 1em;}')
    decorated = injector.decorate(html)

    expected = html.gsub('<table', %(<table style='border:1px;color:blue;\
padding:1em;')).gsub('<td', '<td style=\'padding:1em;\'')
    expect(decorated).to eq(expected)
  end

  it 'should inline css with multiple tags that substring of each other' do
    injector = CssInjector.new('thead{border: 1px;color: blue;}
th{padding: 1em;}')
    decorated = injector.decorate(html)

    expected = html.gsub('<thead', %(<thead style='border:1px;color:blue;'))
                   .gsub(/<th(?!\w)/, '<th style=\'padding:1em;\'')
    expect(decorated).to eq(expected)
  end

  it 'should maintain space in contents' do
    injector = CssInjector.new('table{border: 1px solid black}')
    decorated = injector.decorate(html)

    expected = html.gsub('<table', %(<table style='border:1px solid black'))
    expect(decorated).to eq(expected)
  end
end
