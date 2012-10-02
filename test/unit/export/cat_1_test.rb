require 'test_helper'

class Cat1Test < MiniTest::Unit::TestCase
  def setup
    collection_fixtures('records', '_id')
  end

  def test_export
    patient = Record.first
    qrda_xml = QrdaGenerator::Export::Cat1.export(patient)
    doc = Nokogiri::XML(qrda_xml)
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    first_name = doc.at_xpath('/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:given').text
    assert_equal 'Barry', first_name
  end
end