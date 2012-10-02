require 'test_helper'

class Cat1Test < MiniTest::Unit::TestCase
  def setup
    collection_fixtures('records', '_id')
    collection_fixtures('measures')
    @patient = Record.first
    @measures = []

    Mongoid.session(:default)['measures'].find.each do |measure|
      @measures << HQMF::Document.from_json(measure)
    end
    @qrda_xml = QrdaGenerator::Export::Cat1.export(@patient, @measures)
    @doc = Nokogiri::XML(@qrda_xml)
    @doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    
  end

  def test_cda_header_export
    first_name = @doc.at_xpath('/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:given').text
    assert_equal 'Barry', first_name
  end

  def test_measure_section_export
    measure_entries = @doc.xpath('//cda:section[cda:templateId/@root="2.16.840.1.113883.10.20.24.2.3"]/cda:entry')
    assert_equal 3, measure_entries.size
    measure = measure_entries.find do |measure_entry|
      measure_entry.at_xpath('./cda:organizer/cda:reference/cda:externalDocument/cda:id[@root="0002"]').present? &&
      measure_entry.at_xpath('./cda:organizer/cda:reference/cda:externalDocument/cda:setId[@root="B5FEE67F-F5C4-4C73-9D58-1941F9729539"]').present?
    end
    assert measure
  end
end