require 'test_helper'

class Cat1Test < MiniTest::Unit::TestCase
  def setup
    @patient = Record.first

    @start_date = Time.now.years_ago(1)
    @end_date = Time.now

    @measures = MEASURES
    @qrda_xml = QrdaGenerator::Export::Cat1.export(@patient, @measures, @start_date, @end_date)
    @doc = Nokogiri::XML(@qrda_xml)
    @doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
  end

  def test_cda_header_export
    first_name = @doc.at_xpath('/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:given').text
    assert_equal 'Barry', first_name
  end

  def test_entries_for_data_criteria
    QrdaGenerator::Export::ValueSetManager.expects(:codes_for_oid).with("2.16.840.1.113883.3.464.0001.373").returns([{"set" => "RxNorm", "values" => ["89905"]}])
    data_criteria = @measures[0].all_data_criteria[0]
    entries = QrdaGenerator::Export::Cat1.entries_for_data_criteria(data_criteria, @patient)
    assert_equal 1, entries.length
    assert_equal 'Multivitamin', entries[0].description
  end

  def test_unique_data_criteria
    pairs = QrdaGenerator::Export::Cat1.unique_data_criteria(@measures)
    assert pairs
    assert pairs.include?({'data_criteria_oid' => "2.16.840.1.113883.3.560.1.8",
                           'value_set_oid' => "2.16.840.1.113883.3.464.0001.373"})
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

  def test_reporting_parameters_section_export
    effective_time = @doc.at_xpath('//cda:section[cda:templateId/@root="2.16.840.1.113883.10.20.17.2.1"]/cda:entry/cda:act/cda:effectiveTime')
    assert effective_time

    assert_equal @start_date.to_formatted_s(:number), effective_time.at_xpath('./cda:low')['value']
    assert_equal @end_date.to_formatted_s(:number), effective_time.at_xpath('./cda:high')['value']
  end
end